Shader "Custom/Mud" {
    Properties {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Color", Color) = (1, 1, 1, 1)
        _Gloss ("Gloss", Range(0, 1)) = 0.5
        _Metallic ("Metallic", Range(0, 1)) = 0.0
    }

    SubShader {
        Tags {"RenderType"="Opaque"}
        LOD 200

        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;
            float _Gloss;
            float _Metallic;

            v2f vert (appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            float4 frag (v2f i) : SV_Target {
                float4 col = tex2D(_MainTex, i.uv) * _Color;
                float3 specular = pow(max(dot(Normalize(i.vertex.xyz), normalize(float3(0, 0, 1))), 0.0), 16.0);
                col.rgb = lerp(col.rgb * (1.0 - _Metallic), col.rgb + specular, _Gloss);
                return col;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
