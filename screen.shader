Shader "Unlit/screen"
{
    Properties
    {
        _MainTex ("Texture",2D) = "white" {}
        _MaskTex ("Mask Texture",2D) = "white" {}
        _Color ("Color",Color) = (1,1,1,1)
        _GridSize ("GridSize", Range(1,10)) = 3
        _LineWidth ("LineWidth", Range(0.5,1)) = 0.5
        _Blur ("Blur", Range(0,1)) = 0.3
        _Speed ("Speed", Range(0.1,5)) = 1
        [MaterialToggle] _Turn ("Turn", float) = 0
        [Space]
        [Toggle(_SHADOW_ON)]
        _SHADOW_ON ("SHADOW_ON", float) = 0
        [Space]
        [Toggle(_EMISSION_ON)]
        _EMISSION_ON ("EMISSION_ON", float) = 0
        _Emission ("Emission", Range(0,1)) = 0
        [HDR] _EmissionColor ("Emission Color", Color) = (0,0,0)
    }

    SubShader
    {
        Tags
        {
            "Queue"="Transparent" 
            "RenderType"="Transparent"
            "LightMode"="ForwardBase"
        }
        Blend SrcAlpha OneMinusSrcAlpha
        LOD 100

        pass
        {
            CGPROGRAM
            #pragma vertex vert 
            #pragma fragment frag 
            #pragma shader_feature _SHADOW_ON
            #pragma shader_feature _EMISSION_ON

            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float2 mask_uv : TEXCOORD1;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float2 mask_uv : TEXCOORD1;
                float4 vertex : SV_POSITION;
                fixed4 diff : COLOR0;

            };

            sampler2D _MainTex;
            sampler2D _MaskTex;

            float4 _MainTex_ST;
            fixed4 _Color;
            int _GridSize;
            float _LineWidth;
            float _Blur;
            float _Speed;
            float _Turn;
            float _Emission;
            float4 _EmissionColor;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.mask_uv = v.mask_uv;
                // o.uv = v.uv;
                
                #if _SHADOW_ON
                    // ワールド空間で頂点法線を取得
                    half3 worldNormal = UnityObjectToWorldNormal(v.vertex);
                    // 標準拡散 (Lambert) ライティングを求めるための
                    //法線とライト方向間のドット積
                    half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));
                    // ライトカラーの積(ライトカラー積したくないからかけてない)
                    o.diff = nl;
                    o.diff.rgb += ShadeSH9(half4(worldNormal,1)); 
                #endif

                return o;
            }

            fixed4 frag (v2f i) : SV_TARGET
            {
                fixed4 col = _Color;

                // bool 0,1 を-1,1に変換
                _Turn = _Turn * 2 - 1;

                // 距離関数で縞模様を作成、_Timeでスクロール
                float d = smoothstep(_LineWidth, _LineWidth + _Blur, frac(i.uv.y * _GridSize - _Time.y * _Turn * _Speed)) 
                        + smoothstep(1 - _LineWidth, 1 - _LineWidth - _Blur, frac(i.uv.y * _GridSize - _Time.y * _Turn * _Speed));

                col.a *= tex2D(_MainTex, i.uv);
                col.a *= tex2D(_MaskTex, i.mask_uv);
                col.a *= 1 - d;

                // 影をONにする
                #if _SHADOW_ON
                    col *= i.diff;
                #endif

                // EmissionをONにする
                float4 emission = 0;
                #if _EMISSION_ON
                    emission = _EmissionColor * col.a * _Emission;
                #endif

                col = col * _Color + emission;

                return col;
            }
            ENDCG
        }
        // FallBack "Standard"
    }
    CustomEditor "screenShaderGUI"
}
