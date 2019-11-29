Shader "popo/ch10_1"
{
	Properties
	{
		_BaseColor ("_BaseColor", Color) = (1, 1, 1, 1)
        // _ScreenSpaceShadowMap ("_ScreenSpaceShadowMap ", 2D) = "White"
	}

	SubShader
	{
        Tags {"Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }

		Pass
		{
            Name "ShadowCaster"
            Tags{ "Queue" = "Opaque" "LightMode" = "ShadowCaster" }
            ZWrite On
            Cull Off

			HLSLPROGRAM
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

            #pragma vertex vs_main
            #pragma fragment ps_main

            struct VS_INPUT
            {
                float4 mPosition : POSITION;
            };

            struct VS_OUTPUT
            {
                float4 mPosition : SV_Position;
            };

            VS_OUTPUT vs_main(VS_INPUT Input)
            {
                VS_OUTPUT Output;
                Output.mPosition = mul(UNITY_MATRIX_MVP, Input.mPosition);
                return Output;
            }

            float4 ps_main(VS_OUTPUT Input) : SV_Target
            {
                return 0;
            }

            ENDHLSL
        }

        Pass
		{
            Name "ApplyShadow"
            // LightweightForward
            Tags{ "LightMode" = "UniversalForward" }
            Blend SrcAlpha OneMinusSrcAlpha

			HLSLPROGRAM
			// #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            
            #pragma vertex vs_main
            #pragma fragment ps_main

            float4 _BaseColor;
            // _ShadowMapTexture  => _ScreenSpaceShadowMap
            sampler2D _LocalShadowmapTexture;

            struct VS_INPUT
            {
                float4 mPosition : POSITION;
                float3 mNormal : NORMAL;
            };

            struct VS_OUTPUT
            {
                float4 mPosition : SV_Position;
                float4 mClipPosition : TEXCOORD1;
                float4 mDiffuse : TEXCOORD2;
            };

            float4 ProjectionToTextureSpace(float4 pos)
            {
                float4 textureSpacePos = pos;
                #if defined(UNITY_HALF_TEXEL_OFFSET)
                    textureSpacePos.xy = float2(textureSpacePos.x, textureSpacePos.y * _ProjectionParams.x) + textureSpacePos.w * _ScreenParams.zw;
                #else
                    textureSpacePos.xy = float2(textureSpacePos.x, textureSpacePos.y * _ProjectionParams.x) + textureSpacePos.w;
                #endif
                textureSpacePos.xy = float2(textureSpacePos.x / textureSpacePos.w, textureSpacePos.y / textureSpacePos.w);
                textureSpacePos.xy = textureSpacePos.xy * 0.5f;
                return textureSpacePos;
            }

            VS_OUTPUT vs_main(VS_INPUT Input)
            {
                VS_OUTPUT Output;

                Output.mPosition = mul(UNITY_MATRIX_MVP, Input.mPosition);
                Output.mClipPosition = ProjectionToTextureSpace(Output.mPosition);

                float3 worldPosition = mul(UNITY_MATRIX_M, Input.mPosition).xyz;
                Light light = GetAdditionalLight(0, worldPosition.xyz);
				float3 lightDir = -light.direction;
                float3 worldNormal = mul(Input.mNormal, (float3x3)unity_WorldToObject);
                Output.mDiffuse = dot(-lightDir, worldNormal);

                return Output;
            }

            float4 ps_main(VS_OUTPUT Input) : SV_Target
            {
                //float3 rgb = saturate(Input.mDiffuse) * _BaseColor;
                float3 rgb = _BaseColor.rgb;
                float depth = tex2D(_LocalShadowmapTexture , Input.mClipPosition.xy).r;
                // float depth = RealtimeShadowAttenuation(Input.mClipPosition);
                return float4(rgb * depth, 1);
            }

            ENDHLSL
        }
    }
}
