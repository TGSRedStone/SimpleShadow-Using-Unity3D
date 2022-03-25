Shader "Talents Program/Receiver"
{
    Properties
    {
        _MainTex ("MainTex", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            Tags{ "LightMode" = "ForwardBase" }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _MainTex;

            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 shadowCoord : TEXCOORD0;
                float2 uv : TEXCOORD1;
            };

            float4x4 _gWorldToShadow;
            sampler2D _gShadowMapTexture;
            float4 _gShadowMapTexture_TexelSize;
            float _gShadowStrength;

            v2f vert (appdata_full v) 
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                float4 worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.shadowCoord = mul(_gWorldToShadow, worldPos);
                o.uv = v.texcoord;

                return o; 
            }

            fixed4 frag (v2f i) : COLOR0 
            {
                // shadow
                float2 uv = i.shadowCoord.xy / i.shadowCoord.w;
                uv = uv * 0.5 + 0.5; //(-1, 1)-->(0, 1)

                float depth = i.shadowCoord.z / i.shadowCoord.w;
            #if defined (SHADER_TARGET_GLSL)
                depth = depth * 0.5 + 0.5; //(-1, 1)-->(0, 1)
            #elif defined (UNITY_REVERSED_Z)
                depth = 1 - depth;       //(1, 0)-->(0, 1)
            #endif

                // sample depth texture
                float shadow = 0;
                for(int x = -2; x <= 2; x++)
                {
                    for(int y = -2; y <= 2; y++)
                    {
                        float4 orignDepth = tex2D(_gShadowMapTexture, uv + float2(x, y) * _gShadowMapTexture_TexelSize.xy);
                        float sampleDepth = DecodeFloatRGBA(orignDepth);
                        shadow += sampleDepth < depth ? _gShadowStrength : 1;
                    }
                }
                
                shadow /= 25;

                fixed4 col = tex2D(_MainTex, i.uv);

                return col * shadow;
            }    

            ENDCG
        }
    }
}
