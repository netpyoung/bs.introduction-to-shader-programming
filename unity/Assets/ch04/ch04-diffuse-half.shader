Shader "popo/ch04-half-diffuse"
{
	SubShader
	{
		Pass
		{
			//Tags { "LightMode" = "ForwardAdd" }

			CGPROGRAM
        	#include "Lighting.cginc"

			#pragma vertex vs_main
			#pragma fragment ps_main

			struct VS_INPUT
			{
				float4 mPosition : POSITION;
				float4 mNormal : NORMAL;
			};

			struct VS_OUTPUT
			{
				float4 mPosition : SV_Position;
				float3 mDiffuse : TEXCOORD1;
			};

			VS_OUTPUT vs_main(VS_INPUT Input)
			{
                VS_OUTPUT Output;

				float4 worldPosition = mul(UNITY_MATRIX_M, Input.mPosition);
				float3 lightDirection = normalize(worldPosition.xyz - _WorldSpaceLightPos0.xyz);

				float3 worldNormal = normalize(mul(Input.mNormal.xyz, (float3x3)unity_WorldToObject));
				float3 lambert_diffuse = dot(worldNormal, -lightDirection);
				float3 half_lambert_diffuse = (lambert_diffuse * 0.5) + 0.5;
				Output.mDiffuse = half_lambert_diffuse;
				Output.mPosition = mul(UNITY_MATRIX_VP, worldPosition);

				return Output;
			}

			float4 ps_main(VS_OUTPUT Input) : SV_Target
			{
				float3 diffuse = saturate(Input.mDiffuse);
				return float4(diffuse, 1);
			}

			ENDCG
		}
	}
}
