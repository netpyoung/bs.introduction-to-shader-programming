Shader "popo/ch05"
{
	Properties
	{
		_BaseColor ("_BaseColor", Color) = (1, 1, 1, 1)
		_DiffuseTex ("Texture", 2D) = "" {}
		_SpecularTex ("_SpecularTex", 2D) = "" {}
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

			float4		_BaseColor;
			sampler2D	_DiffuseTex;
			sampler2D	_SpecularTex;

			struct VS_INPUT
			{
			   float4 mPosition	: POSITION;
			   float3 mNormal	: NORMAL;
			   float2 mUV		: TEXCOORD0;
			};

			struct VS_OUTPUT
			{
			   float4 mPosition				: SV_Position;
			   float2 mUV					: TEXCOORD0;
			   float3 mDiffuse				: TEXCOORD1;
			   float3 mViewDirection		: TEXCOORD2;
			   float3 mReflectionDirection	: TEXCOORD3;
			   float3 mLightColor			: TEXCOORD4;
			};

			VS_OUTPUT vert(VS_INPUT Input)
			{
				VS_OUTPUT Output;

				float4 worldPosition = mul(UNITY_MATRIX_M, Input.mPosition);
				float3 worldNormal = normalize(mul(Input.mNormal, (float3x3)unity_WorldToObject));

				Output.mUV = Input.mUV;
				Output.mViewDirection = normalize(worldPosition.xyz - _WorldSpaceCameraPos.xyz);
				Output.mPosition = mul(UNITY_MATRIX_VP, worldPosition);

				Light light = GetAdditionalLight(0, Output.mPosition.xyz);
				float3 lightDirection = -light.direction;
				Output.mDiffuse = dot(-lightDirection, worldNormal);
				Output.mReflectionDirection = reflect(lightDirection, worldNormal);
				Output.mLightColor = light.color;
				return Output;
			}

			struct PS_INPUT
			{			   
				float4 mPosition			: SV_Position;
				float2 mUV					: TEXCOORD0;
				float3 mDiffuse				: TEXCOORD1;
				float3 mViewDirection		: TEXCOORD2;
				float3 mReflectionDirection	: TEXCOORD3;
				float3 mLightColor			: TEXCOORD4;
			};

			float4 frag(PS_INPUT Input) : SV_Target
			{
				float4 albedo = tex2D(_DiffuseTex, Input.mUV);
				float3 light_color = Input.mLightColor;

				float3 diffuse =  light_color * albedo.rgb * saturate(Input.mDiffuse);

				float4 ambient = _BaseColor * albedo;
				float3 specular = float3(0, 0, 0);
				if (diffuse.x > 0)
				{
					float3 viewDirection = normalize(Input.mViewDirection);
					float3 reflectionDirection = normalize(Input.mReflectionDirection);
					specular = pow(saturate(dot(-viewDirection, reflectionDirection)), 20);

					float3 specularIntensity = tex2D(_SpecularTex, Input.mUV).xyz;
					specular *= specularIntensity * light_color;
				}
				
				// return ambient;
				return float4(ambient.xyz + diffuse + specular, 1);
			}

			ENDHLSL
		}
	}
}
