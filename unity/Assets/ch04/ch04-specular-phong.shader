Shader "popo/ch04-specular-phong"
{
	SubShader
	{
		Pass
		{
			//Tags{ "LightMode" = "ForwardAdd" }

CGPROGRAM
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
   float3 V : TEXCOORD2;
   float3 R : TEXCOORD3;
};

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
   Output.V = normalize(_WorldSpaceCameraPos.xyz - worldPosition.xyz);

   // 반사 벡터 = 2 * dot(빛의 방향, 변환 법선) * 변환 법선 - 빛의 방향
   Output.R = reflect(L, N);

   Output.mPosition = mul(UNITY_MATRIX_VP, worldPosition);

   return Output;
}

float4 ps_main(VS_OUTPUT Input) : SV_Target
{
  float3 V = normalize(Input.V);
  float3 R = normalize(Input.R);

  // 퐁 반사의 세기 = dot(시선 벡터, 반사 벡터)^Power
  float3 phong_specular = pow(saturate(dot(V, R)), 20);

  return float4(phong_specular, 1);
}
ENDCG
		}
	}
}
