Shader "Unlit/Dropping"
{
    Properties
    {
        _Speed1 ("Speed 1", Vector) = (0,0,0,0)
        _Speed2 ("Speed 2", Vector) = (0,0,0,0) 
        _MainTex ("Texture", 2D) = "white" {}
        _NoiseTex ("Texture", 2D) = "white" {}
        _Amount ("Amount", float) = 0.01
        _HueShift ("Hue", float) = 0.3
        _ShiftSpeed ("Hue speed", float) = 50
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            sampler2D _NoiseTex;
            float4 _MainTex_ST;
            float _Amount;
            float4 _Speed1;
            float4 _Speed2;
            float _HueShift;
            float _ShiftSpeed;
                float3 rgb_to_hsv_no_clip(float3 RGB)
            {
                    float3 HSV;
            
            float minChannel, maxChannel;
            if (RGB.x > RGB.y) {
            maxChannel = RGB.x;
            minChannel = RGB.y;
            }
            else {
            maxChannel = RGB.y;
            minChannel = RGB.x;
            }
            
            if (RGB.z > maxChannel) maxChannel = RGB.z;
            if (RGB.z < minChannel) minChannel = RGB.z;
            
                    HSV.xy = 0;
                    HSV.z = maxChannel;
                    float delta = maxChannel - minChannel;             //Delta RGB value
                    if (delta != 0) {                    // If gray, leave H  S at zero
                    HSV.y = delta / HSV.z;
                    float3 delRGB;
                    delRGB = (HSV.zzz - RGB + 3*delta) / (6.0*delta);
                    if      ( RGB.x == HSV.z ) HSV.x = delRGB.z - delRGB.y;
                    else if ( RGB.y == HSV.z ) HSV.x = ( 1.0/3.0) + delRGB.x - delRGB.z;
                    else if ( RGB.z == HSV.z ) HSV.x = ( 2.0/3.0) + delRGB.y - delRGB.x;
                    }
                    return (HSV);
            }
    
            float3 hsv_to_rgb(float3 HSV)
            {
                    float3 RGB = HSV.z;
            
                    float var_h = HSV.x * 6;
                    float var_i = floor(var_h);   // Or ... var_i = floor( var_h )
                    float var_1 = HSV.z * (1.0 - HSV.y);
                    float var_2 = HSV.z * (1.0 - HSV.y * (var_h-var_i));
                    float var_3 = HSV.z * (1.0 - HSV.y * (1-(var_h-var_i)));
                    if      (var_i == 0) { RGB = float3(HSV.z, var_3, var_1); }
                    else if (var_i == 1) { RGB = float3(var_2, HSV.z, var_1); }
                    else if (var_i == 2) { RGB = float3(var_1, HSV.z, var_3); }
                    else if (var_i == 3) { RGB = float3(var_1, var_2, HSV.z); }
                    else if (var_i == 4) { RGB = float3(var_3, var_1, HSV.z); }
                    else                 { RGB = float3(HSV.z, var_1, var_2); }
            
            return (RGB);
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
               
                fixed n = tex2D(_NoiseTex, i.uv + _Speed1.xy*_Time);
                fixed n2 = tex2D(_NoiseTex, i.uv*2 + _Speed2.xy*_Time);

                fixed NF = n * n2 * 2;
                NF = NF*2-1;
                fixed4 col = tex2D(_MainTex, i.uv + _Amount * NF);
             //   fixed4 shift =  fixed4(sin(_Time.x*50)*0.4,sin(_Time.x*80)*0.25,sin(_Time.x*40)*0.25,1);
               
                fixed3 shift = rgb_to_hsv_no_clip(col.xyz);
                shift = fixed3(shift.x + sin(_Time.x*_ShiftSpeed)*_HueShift, shift.y, shift.z);
                col = fixed4(hsv_to_rgb(shift),1);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
