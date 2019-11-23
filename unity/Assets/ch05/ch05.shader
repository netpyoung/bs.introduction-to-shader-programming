Shader "popo/ch05"
{
	Properties
	{
		_BaseColor ("_BaseColor", Color) = (1, 1, 1, 1)
		_DiffuseTex ("_DiffuseTex", 2D) = "" {}
		_SpecularTex ("_SpecularTex", 2D) = "" {}
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

			uniform float4 _BaseColor;
			uniform sampler2D _DiffuseTex;
			uniform sampler2D _SpecularTex;

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
			};

			VS_OUTPUT vert(VS_INPUT Input)
			{
			   VS_OUTPUT Output;

			   float4 worldPosition = mul(UNITY_MATRIX_M, Input.mPosition);
			   float3 worldNormal = normalize(mul(Input.mNormal, (float3x3)unity_WorldToObject));
			   float3 lightDirectionUnnormlized = worldPosition.xyz - _WorldSpaceLightPos0.xyz;
			   float3 lightDirection = normalize(lightDirectionUnnormlized);

			   Output.mUV = Input.mUV;
			   Output.mDiffuse = dot(-lightDirection, worldNormal);
			   Output.mViewDirection = normalize(worldPosition.xyz - _WorldSpaceCameraPos.xyz);
			   Output.mReflectionDirection = reflect(lightDirectionUnnormlized, worldNormal);
			   Output.mPosition = mul(UNITY_MATRIX_VP, worldPosition);
			   return Output;
			}

			struct PS_INPUT
			{
				float2 mUV					: TEXCOORD0;
				float3 mDiffuse				: TEXCOORD1;
				float3 mViewDirection		: TEXCOORD2;
				float3 mReflectionDirection	: TEXCOORD3;
			};

			float4 frag(PS_INPUT Input) : SV_Target
			{
				float4 albedo = tex2D(_DiffuseTex, Input.mUV);
				float3 light_color = float3(1, 1, 1);//unity_LightColor[0].rgb;

				float3 diffuse =  light_color * albedo.rgb * saturate(Input.mDiffuse);

				float3 ambient = _BaseColor * albedo;
				float3 specular = float3(0, 0, 0);
				if (diffuse.x > 0)
				{
					float3 viewDirection = normalize(Input.mViewDirection);
					float3 reflectionDirection = normalize(Input.mReflectionDirection);
					specular = pow(saturate(dot(-viewDirection, reflectionDirection)), 20);

					float4 specularIntensity = tex2D(_SpecularTex, Input.mUV);
					specular *= specularIntensity * light_color;
				}
				 //return float4(ambient, 1);
				return float4(diffuse, 1);
				//return float4(specular, 1);
				return float4(ambient + diffuse + specular, 1);
			}

			ENDHLSL
		}
	}
}
