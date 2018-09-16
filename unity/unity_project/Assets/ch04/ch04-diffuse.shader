Shader "popo/ch04-diffuse"
{
	SubShader
	{
		Pass
		{
			Tags{ "LightMode" = "ForwardAdd" }
			//Tags{ "LightMode" = "ForwardBase" }

			CGPROGRAM

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

			   Output.mDiffuse = dot(worldNormal, -lightDirection);
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
