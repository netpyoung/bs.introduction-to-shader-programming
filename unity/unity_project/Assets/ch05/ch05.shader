﻿Shader "popo/ch05"
{
	SubShader
	{
		Pass
		{
			Tags{ "LightMode" = "ForwardAdd" }

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			struct VS_INPUT
			{
			   float4 mPosition : POSITION;
			   float4 mNormal : NORMAL;
			};

			struct VS_OUTPUT
			{
			   float4 mPosition : SV_Position;
			   float3 mDiffuse : TEXCOORD1;
			   float3 mViewDirection : TEXCOORD2;
			   float3 mReflectionDirection : TEXCOORD3;
			};

			VS_OUTPUT vert(VS_INPUT Input)
			{
			   VS_OUTPUT Output;

			   float4 worldPosition = mul(UNITY_MATRIX_M, Input.mPosition);
			   float3 worldNormal = normalize(mul((float3x3)UNITY_MATRIX_M, Input.mNormal));
			   float3 lightDirection = normalize(worldPosition.xyz - _WorldSpaceLightPos0.xyz);

			   Output.mDiffuse = dot(worldNormal, -lightDirection);
			   Output.mViewDirection = normalize(worldPosition.xyz - _WorldSpaceCameraPos.xyz);
			   Output.mReflectionDirection = reflect(lightDirection, worldNormal);
			   Output.mPosition = mul(UNITY_MATRIX_VP, worldPosition);
			   return Output;
			}

			struct PS_INPUT
			{
				float2 mUV : TEXCOORD0;
				float3 mDiffuse : TEXCOORD1;
				float3 mViewDirection: TEXCOORD2;
				float3 mReflectionDirection: TEXCOORD3;
			};


			float4 frag(PS_INPUT Input) : SV_Target
			{
				float3 ambient = float3(0.1f, 0.1f, 0.1f);
				float3 diffuse = saturate(Input.mDiffuse);
				float3 specular = float3(0, 0, 0);
				if (diffuse.x > 0)
				{
					float3 viewDirection = normalize(Input.mViewDirection);
					float3 reflectionDirection = normalize(Input.mReflectionDirection);
					specular = pow(saturate(dot(-viewDirection, reflectionDirection)), 20);
				}
				//return float4(ambient, 1);
				//return float4(diffuse, 1);
				//return float4(specular, 1);
				return float4(ambient + diffuse + specular, 1);
			}

			ENDCG
		}
	}
}