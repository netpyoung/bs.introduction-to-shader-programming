Shader "popo/ch08"
{
	Properties
	{
		_BaseColor ("_BaseColor", Color) = (1, 1, 1, 1)
		_D_Texture ("_D_Texture", 2D) = "" {}
		_S_Texture ("_S_Texture", 2D) = "" {}
		_N_Texture ("_N_Texture", 2D) = "" {}
        _Cubemap_Texture ("_Cubemap_Texture", Cube) = "" {}
	}

	SubShader
	{
		Pass
		{
			Tags{ "LightMode" = "UniversalForward"  }

			HLSLPROGRAM
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
                
            #pragma vertex vs_main
            #pragma fragment ps_main

            sampler2D _D_Texture;
            sampler2D _S_Texture;
            sampler2D _N_Texture;
            samplerCUBE _Cubemap_Texture;

            struct VS_INPUT
            {
                float4 mPosition    : POSITION;
                float3 mNormal      : NORMAL;
                float4 mTangent     : TANGENT;
                float2 mUV          : TEXCOORD0;
            };

            struct VS_OUTPUT
            {
                float4 mPosition    : SV_Position;
                float2 mUV          : TEXCOORD0;
                float3 mLightDir    : TEXCOORD1;
                float3 mViewDir     : TEXCOORD2;
                float3 T            : TEXCOORD3;
                float3 B            : TEXCOORD4;
                float3 N            : TEXCOORD5;
                float3 mLightColor  : COLOR1;
            };

            VS_OUTPUT vs_main(VS_INPUT Input)
            {
                VS_OUTPUT Output;
                float3 worldPosition = mul(UNITY_MATRIX_M, Input.mPosition).xyz;
                Output.mPosition = mul(UNITY_MATRIX_MVP, Input.mPosition);
                Output.mUV = Input.mUV;

                float3 objBinormal = cross(Input.mNormal, Input.mTangent.xyz) * Input.mTangent.w;
                Output.T = normalize(mul((float3x3)UNITY_MATRIX_M, Input.mTangent.xyz));
                Output.B = normalize(mul((float3x3)UNITY_MATRIX_M, objBinormal));
                Output.N = normalize(mul(Input.mNormal, (float3x3)unity_WorldToObject));

		        Light light = GetAdditionalLight(0, worldPosition.xyz);
				Output.mLightDir = -light.direction;
				Output.mViewDir = normalize(worldPosition.xyz - _WorldSpaceCameraPos.xyz);
                Output.mLightColor = light.color;
                return Output;
            }

            float4 ps_main(VS_OUTPUT Input) : SV_Target
            {
                float4 albedo = tex2D(_D_Texture, Input.mUV);

                float3 tangentNormal = tex2D(_N_Texture, Input.mUV).xyz;
                tangentNormal = normalize(tangentNormal * 2.0 - 1.0);
                // tangentNormal = float3(0, 0, 1);

                float3x3 TBN = float3x3(normalize(Input.T), normalize(Input.B), normalize(Input.N));
                float3 worldNormal = mul(tangentNormal, TBN);

                float3 viewDir = normalize(Input.mViewDir);
                float3 lightDir = normalize(Input.mLightDir);
                float3 diffuse = saturate(dot(worldNormal, -lightDir)) * albedo.rgb * Input.mLightColor.rgb;

                float3 specular = 0;
                if (diffuse.x > 0)
                {
                    float3 reflection = reflect(lightDir, worldNormal);
                    specular = saturate(dot(reflection, -viewDir));
                    specular = pow(specular, 20);
                    float4 specularIntensity = tex2D(_S_Texture, Input.mUV);
                    specular *=  specularIntensity.xyz;
                }

                float3 viewReflect = reflect(viewDir, worldNormal);// mul(float3(0, 0, 1), TBN));
                float3 environment = texCUBE(_Cubemap_Texture, viewReflect).rgb;
                // return float4(environment * 0.5f, 1.0f);

                return float4(diffuse + specular + environment * 0.5f, 1.0f);
            }
            ENDHLSL
        }
    }
}