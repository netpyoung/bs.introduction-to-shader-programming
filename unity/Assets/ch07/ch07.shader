Shader "popo/ch07"
{
	Properties
	{
		_BaseColor ("_BaseColor", Color) = (1, 1, 1, 1)
		_D_Texture ("_D_Texture", 2D) = "" {}
		_S_Texture ("_S_Texture", 2D) = "" {}
		[Normal] _N_Texture ("_N_Texture", 2D) = "" {}
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

			float3		_BaseColor;
			sampler2D	_D_Texture;
			sampler2D	_S_Texture;
			sampler2D	_N_Texture;
			
			struct VS_INPUT
			{
				float4 mPosition	: POSITION;
				float3 mNormal		: NORMAL;
				float4 mTangent		: TANGENT;

				// https://docs.unity3d.com/Manual/SL-VertexProgramInputs.html
				// https://answers.unity.com/questions/1103042/what-does-this-error-mean-6.html
				// Unity에서는 BINORMAL; 지원 안함 => 따로 계산해 주어야 함.
				// binormal = cross( Input.mNormal, Input.mTangent.xyz ) * Input.mTangent.w;
				// float4 mBinormal    : BINORMAL;
				float2 mUV			: TEXCOORD0;
			};

			struct VS_OUTPUT
			{
				float4 mPosition	: SV_Position;
				float2 mUV			: TEXCOORD0;
				float3 mLightDir	: TEXCOORD1;
				float3 mViewDir		: TEXCOORD2;
				float3 T			: TEXCOORD3;
				float3 B			: TEXCOORD4;
				float3 N			: TEXCOORD5;

				float3 mLightColor	: TEXCOORD6;
			};

			VS_OUTPUT vert(VS_INPUT Input)
			{
				VS_OUTPUT Output;

				float4 worldPosition = mul(UNITY_MATRIX_M, Input.mPosition);

				Output.mPosition = mul(UNITY_MATRIX_VP, worldPosition);
				Light light = GetAdditionalLight(0, Output.mPosition.xyz);

				Output.mUV = Input.mUV;
				Output.mLightDir = -light.direction;
				Output.mLightColor = light.color;
				Output.mViewDir = normalize(worldPosition.xyz - _WorldSpaceCameraPos.xyz);

				Output.N = normalize(mul(Input.mNormal, (float3x3)unity_WorldToObject));
				Output.T = normalize(mul((float3x3)UNITY_MATRIX_M, Input.mTangent.xyz));
				float3 binormal = cross( Input.mNormal, Input.mTangent.xyz ) * Input.mTangent.w;
				Output.B = normalize(mul((float3x3)UNITY_MATRIX_M, binormal));
				return Output;
			}

			struct PS_INPUT
			{
				float4 mPosition	: SV_Position;
				float2 mUV			: TEXCOORD0;
				float3 mLightDir	: TEXCOORD1;
				float3 mViewDir		: TEXCOORD2;
				float3 T			: TEXCOORD3;
				float3 B			: TEXCOORD4;
				float3 N			: TEXCOORD5;

				float3 mLightColor	: TEXCOORD6;
			};

			float4 frag(PS_INPUT Input) : SV_Target
			{
				float3x3 TBN = float3x3(normalize(Input.T), normalize(Input.B), normalize(Input.N));
				float3 tangentNormal = tex2D(_N_Texture, Input.mUV).xyz;
				tangentNormal = normalize(tangentNormal * 2 - 1);
				float3 worldNormal = mul(tangentNormal, TBN);
				
				float3 lightDir = normalize(Input.mLightDir);
				float3 diffuse = saturate(dot(worldNormal, -lightDir));

				float3 light_color = Input.mLightColor;
				float4 albedo = tex2D(_D_Texture, Input.mUV);
				diffuse = light_color * albedo.rgb * diffuse;

				float3 specular = 0;
				if (diffuse.x > 0)
				{
					float3 reflection = reflect(lightDir, worldNormal);
					float3 viewDir = normalize(Input.mViewDir);

					specular = saturate(dot(reflection, -viewDir));
					specular = pow(specular, 20.0f);

					float4 specularIntensity = tex2D(_S_Texture, Input.mUV);
					specular *= specularIntensity.rgb * light_color;
				}
				
				float3 ambient = float3(0.1f, 0.1f, 0.1f) * albedo.xyz;

				//return float4(ambient, 1);
				// return float4(diffuse, 1);
				// return float4(specular, 1);
				 return float4(diffuse + ambient + specular, 1);
				// return float4(1, 1, 1, 1);
			}

			ENDHLSL
		}
	}
}
