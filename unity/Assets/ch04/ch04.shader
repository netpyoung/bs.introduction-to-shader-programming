Shader "popo/ch04"
{
	SubShader
	{
		Pass
		{
			//Tags{ "LightMode" = "ForwardAdd" }

			HLSLPROGRAM
			#include "UnityShaderVariables.cginc"
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

			   //float3 worldNormal = normalize(mul(transpose(unity_WorldToObject), float4(Input.mNormal.xyz, 0)).xyz);
                           //float3 worldNormal = normalize(mul(transpose(unity_WorldToObject), float4(Input.mNormal.xyz, 0)).xyz);
			   //float3 worldNormal = normalize(mul((float3x3)unity_ObjectToWorld, Input.mNormal));
			   float3 worldNormal = normalize(mul(Input.mNormal.xyz, (float3x3)unity_WorldToObject));
			   //float3 worldNormal = normalize(mul(Input.mNormal.xyz, (float3x3)UNITY_MATRIX_M));

			   //float3 worldNormal = mul((float3x3)UNITY_MATRIX_IT_MV, Input.mNormal);
			   float3 lightDirection = normalize(worldPosition.xyz - _WorldSpaceLightPos0.xyz);

			   Output.mDiffuse = dot(worldNormal, -lightDirection);
			   Output.mViewDirection = normalize(worldPosition.xyz - _WorldSpaceCameraPos.xyz);
			   Output.mReflectionDirection = reflect(lightDirection, worldNormal);
			   Output.mPosition = mul(UNITY_MATRIX_VP, worldPosition);
			   return Output;
			}

			float4 frag(VS_OUTPUT Input) : SV_Target
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

			ENDHLSL
		}
	}
}
