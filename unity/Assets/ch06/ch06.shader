Shader "popo/ch06"
{
	Properties
	{
		_BaseColor ("_BaseColor", Color) = (1, 1, 1, 1)
		_ToonLevel ("_ToonLevel", Range (1, 20)) = 4
	}

	SubShader
	{
		Pass
		{
			//Tags{ "LightMode" = "ForwardAdd" }

			HLSLPROGRAM
			#include "UnityShaderVariables.cginc"
			#pragma vertex vert
			#pragma fragment frag

			uniform float3 _BaseColor;
			uniform float _ToonLevel;


			struct VS_INPUT
			{
			   float4 mPosition : POSITION;
			   float3 mNormal : NORMAL;
			};

			struct VS_OUTPUT
			{
			   float4 mPosition : SV_Position;
			   float3 mDiffuse : TEXCOORD1;
			};

			VS_OUTPUT vert(VS_INPUT Input)
			{
			   VS_OUTPUT Output;

			   float4 worldPosition = mul(UNITY_MATRIX_M, Input.mPosition);
			   float3 worldNormal = normalize(mul(Input.mNormal, (float3x3)unity_WorldToObject));
			   float3 lightDirectionUnnormlized = worldPosition.xyz - _WorldSpaceLightPos0.xyz;
			   float3 lightDirection = normalize(lightDirectionUnnormlized);

			   Output.mDiffuse = dot(worldNormal, -lightDirection);
			   Output.mPosition = mul(UNITY_MATRIX_VP, worldPosition);
			   return Output;
			}

			struct PS_INPUT
			{
				float3 mDiffuse : TEXCOORD1;
			};


			float4 frag(PS_INPUT Input) : SV_Target
			{
				float3 diffuse = saturate(Input.mDiffuse);
				//diffuse = ceil(diffuse * 4) / 4;
				diffuse = ceil(diffuse * _ToonLevel) / _ToonLevel;
				return float4(_BaseColor * diffuse.xyz, 1);
			}

			ENDHLSL
		}
	}
}
