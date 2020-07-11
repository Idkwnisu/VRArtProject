Shader "Unlit/DroppingV"
{
    Properties
    {
        _Speed1 ("Speed 1", Vector) = (0,0,0,0)
        _Speed2 ("Speed 2", Vector) = (0,0,0,0) 
        _MainTex ("Texture", 2D) = "white" {}
        _NoiseTex ("Texture", 2D) = "white" {}
        _Amount ("Amount", float) = 0.01
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
               
                fixed n = tex2D(_NoiseTex, i.uv + fixed2(0,_Speed1.y)*_Time);
                fixed n2 = tex2D(_NoiseTex, i.uv*2 +(0,_Speed2.y)*_Time);

                fixed NF = n * n2 * 2;
                NF = NF*2-1;
                fixed4 col = tex2D(_MainTex, i.uv + _Amount * NF);

                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
