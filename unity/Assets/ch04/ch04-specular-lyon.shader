Shader "popo/ch04-specular-lyon"
{
	SubShader
	{
		Pass
		{
			//Tags{ "LightMode" = "ForwardBase" }

HLSLPROGRAM
#include "UnityShaderVariables.cginc"
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
   float Lyon : TEXCOORD2;
};

float Lyon(float3 normal, float3 view, float3 light, float specPower)
{
   float3 halfVector = normalize(light + view);
   float3 difference = halfVector - normal;
   float xs = saturate(dot(difference, difference) * specPower / 2);
   return pow(1 - xs, 3);
}

VS_OUTPUT vs_main(VS_INPUT Input)
{
   VS_OUTPUT Output;

   // 변환 위치 = 월드 행렬 * 정점 위치
   float4 worldPosition = mul(UNITY_MATRIX_M, Input.mPosition);

   // 빛 벡터 = normalize(변환 위치 - 빛 위치)
   float3 L = normalize(worldPosition.xyz - _WorldSpaceLightPos0.xyz);

   // 변환 법선 = 정점 법선 * 월드 행렬의 회전 행렬
   float3 N = normalize(mul(Input.mNormal.xyz, (float3x3)unity_WorldToObject));

   // 시선 벡터 = normalize(카메라 위치 - 변환 위치)
   float3 V = normalize(_WorldSpaceCameraPos.xyz - worldPosition.xyz);

   // lyon
   float specPower = 100;
   Output.Lyon = Lyon(N, V, L, specPower);

   Output.mPosition = mul(UNITY_MATRIX_VP, worldPosition);

   return Output;
}

float4 ps_main(VS_OUTPUT Input) : SV_Target
{
  float Lyon = Input.Lyon;
  float3 specular = float3(Lyon, Lyon, Lyon);
  return float4(specular, 1);
}
ENDHLSL
		}
	}
}
