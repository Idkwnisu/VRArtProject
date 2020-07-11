Shader "Unlit/ChromaticAberration"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Amount("Amount", Range(0.0, 1)) = 0.0005
        _Speed("Speed", float) = 200
        _InvertSpeed("Invert Speed", float) = 200
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
            float4 _MainTex_ST;
            float _Amount;
            float _Speed;
            float _InvertSpeed;

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
                fixed4 col = tex2D(_MainTex, i.uv);
                 UNITY_APPLY_FOG(i.fogCoord, col);

                float colR = tex2D(_MainTex, float2(i.uv.x - _Amount, i.uv.y - _Amount)).r;
                float colG = tex2D(_MainTex, i.uv).g;
                float colB = tex2D(_MainTex, float2(i.uv.x + _Amount, i.uv.y + _Amount)).b;
                float4 chromatic = fixed4(colR, colG, colB, 1);

                float inverter = step(0.0,sin(_Time*_InvertSpeed));

                float4 color = lerp(col,chromatic,sin(_Time*_Speed));
                return lerp(color, 1-color, inverter);
                
                // apply fog
               
               // return col;
            }
            ENDCG
        }
    }
}
