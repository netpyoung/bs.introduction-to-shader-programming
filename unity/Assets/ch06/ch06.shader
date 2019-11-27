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
			Tags{ "LightMode" = "UniversalForward"  }

			HLSLPROGRAM
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

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
				Output.mPosition = mul(UNITY_MATRIX_MVP, Input.mPosition);
				Light light = GetAdditionalLight(0, Output.mPosition.xyz);
				float3 lightDir = -light.direction;
				Output.mDiffuse = dot(mul(UNITY_MATRIX_M, Input.mNormal), -lightDir);
				return Output;
			}

			struct PS_INPUT
			{			   
				float4 mPosition : SV_Position;
				float3 mDiffuse : TEXCOORD1;
			};

			float4 frag(PS_INPUT Input) : SV_Target
			{
				float3 diffuse = saturate(Input.mDiffuse);
				diffuse = ceil(diffuse * _ToonLevel) / _ToonLevel;
				return float4(_BaseColor * diffuse.xyz, 1);
			}

			ENDHLSL
		}
	}
}
