Shader "popo/ch04-specular-phong"
{
	SubShader
	{
		Pass
		{
			Tags{ "LightMode" = "ForwardAdd" }

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
			   // float3 mDiffuse : TEXCOORD1;
			   float3 mViewDirection : TEXCOORD2;
			   float3 mReflectionDirection : TEXCOORD3;

			};

			VS_OUTPUT vs_main(VS_INPUT Input)
			{
			   VS_OUTPUT Output;

			   float4 worldPosition = mul(UNITY_MATRIX_M, Input.mPosition);
                           float3 lightDirection = normalize(worldPosition.xyz - _WorldSpaceLightPos0.xyz);

			   float3 worldNormal = normalize(mul(Input.mNormal.xyz, (float3x3)unity_WorldToObject));


                           Output.mViewDirection = normalize(worldPosition.xyz - _WorldSpaceCameraPos.xyz);
			   Output.mReflectionDirection = reflect(lightDirection, worldNormal);

			   Output.mPosition = mul(UNITY_MATRIX_VP, worldPosition);

			   return Output;
			}

			float4 ps_main(VS_OUTPUT Input) : SV_Target
			{
                                float3 viewDirection = normalize(Input.mViewDirection);
				float3 reflectionDirection = normalize(Input.mReflectionDirection);
                                float3 specular = pow(saturate(dot(-viewDirection, reflectionDirection)), 20);

				return float4(specular, 1);
			}

			ENDCG
		}
	}
}
