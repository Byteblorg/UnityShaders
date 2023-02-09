Shader "Custom/ConstructionSiteGround" {
    Properties {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Color", Color) = (1, 1, 1, 1)
        _Distortion ("Distortion", Range(0, 1)) = 0.5
        _DistortionSpeed ("Distortion Speed", Range(0, 10)) = 1.0
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
            float _Distortion;
            float _DistortionSpeed;

            v2f vert (appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            float4 frag (v2f i) : SV_Target {
                float2 distortedUV = i.uv + (tex2D(_MainTex, i.uv * 10.0 + _Time.y * _DistortionSpeed).r - 0.5) * _Distortion;
                float4 col = tex2D(_MainTex, distortedUV) * _Color;
                return col;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
