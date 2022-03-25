Shader "Talents Program/Caster"
{
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            Cull front

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            float _Bias;

            struct v2f
            {
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata_full v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.vertex.z += _Bias;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float depth = i.vertex.z / i.vertex.w;
#if defined (SHADER_TARGET_GLSL)
			depth = depth*0.5 + 0.5; //(-1, 1)-->(0, 1)
#elif defined (UNITY_REVERSED_Z)
			depth = 1 - depth;       //(1, 0)-->(0, 1)
#endif
                return EncodeFloatRGBA(depth);
            }
            ENDCG
        }
    }
}
