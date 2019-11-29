Shader "popo/ch09"
{
	Properties
	{
		_BaseColor ("_BaseColor", Color) = (1, 1, 1, 1)
		_D_Texture ("_D_Texture", 2D) = "" {}
		_S_Texture ("_S_Texture", 2D) = "" {}
        _WaveHeight ("_WaveHeight", Float) = 3
        _Speed ("_Speed", Float) = 2
        _WaveFrequency ("_WaveFrequency", Float) = 10
        _UVSpeed ("_UVSpeed", Float) = 0.25
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
            float _WaveHeight;
            float _Speed;
            float _WaveFrequency;
            float _UVSpeed;

            struct VS_INPUT
            {
                float4 mPosition : POSITION;
                float3 mNormal : NORMAL;
                float2 mUV : TEXCOORD0;
            };

            struct VS_OUTPUT
            {
                float4 mPosition : SV_Position;
                float2 mUV : TEXCOORD0;
                float3 mDiffuse : TEXCOORD1;
                float3 mViewDir : TEXCOORD2;
                float3 mReflection : TEXCOORD3;
            };

            VS_OUTPUT vs_main(VS_INPUT Input)
            {
                VS_OUTPUT Output;
                
                float time = _Time.y;
                float cosTime = _WaveHeight * cos(time * _Speed + Input.mUV.x * _WaveFrequency);
                Input.mPosition.y += cosTime;
                
                Output.mUV = Input.mUV + float2(time * _UVSpeed, 0);
                Output.mPosition = mul(UNITY_MATRIX_MVP, Input.mPosition);
                float3 worldPosition = mul(UNITY_MATRIX_M, Input.mPosition).xyz;

                Light light = GetAdditionalLight(0, worldPosition.xyz);
				float3 lightDir = -light.direction;
                float3 viewDir = normalize(worldPosition.xyz - _WorldSpaceCameraPos.xyz);
                Output.mViewDir = viewDir;

                float3 worldNormal = mul(Input.mNormal, (float3x3)unity_WorldToObject);
                Output.mDiffuse = dot(-lightDir, worldNormal);
                Output.mReflection = reflect(lightDir, worldNormal);
                return Output;
            }

            float4 ps_main(VS_OUTPUT Input) : SV_Target
            {
                float4 albedo = tex2D(_D_Texture, Input.mUV);
                float3 diffuse = albedo.rgb * saturate(Input.mDiffuse);
                float3 reflection = normalize(Input.mReflection);
                float3 viewDir = normalize(Input.mViewDir);
                float3 specular = 0;
                if (diffuse.x > 0)
                {
                    specular = saturate(dot(reflection, -viewDir));
                    specular = pow(specular, 20);
                    float4 specularIntensity = tex2D(_S_Texture, Input.mUV);
                    specular *= specularIntensity.rgb;
                }
                float3 ambient = float3(0.1f, 0.1f, 0.1f) * albedo.xyz;
                return float4(ambient + diffuse + specular, 1);
            }

            ENDHLSL
        }
    }
}
