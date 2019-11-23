Shader "popo/ch03-1"
{
	Properties
	{
		_MainTex ("_MainTex", 2D) = "white" {}
	}

	SubShader
	{
		Pass
		{


HLSLPROGRAM
#include "UnityShaderVariables.cginc"
#pragma vertex vs_main
#pragma fragment ps_main

sampler2D _MainTex;

struct VS_INPUT
{
    float4 mPosition : POSITION;
    float2 mTexCoord : TEXCOORD0;
};

struct VS_OUTPUT
{
    float4 mPosition : SV_Position;
    float2 mTexCoord : TEXCOORD0;
};

VS_OUTPUT vs_main(VS_INPUT Input)
{
    VS_OUTPUT Output;

    Output.mPosition = mul(UNITY_MATRIX_M, Input.mPosition);
    Output.mPosition = mul(UNITY_MATRIX_V, Output.mPosition);
    Output.mPosition = mul(UNITY_MATRIX_P, Output.mPosition);

    Output.mTexCoord = Input.mTexCoord;

    float t = _Time[1];
    // float t = _SinTime[3];
    Output.mTexCoord.x += t;

    return Output;
}

float4 ps_main(VS_OUTPUT Input) : SV_Target
{
    float4 albedo = tex2D(_MainTex, Input.mTexCoord);

    return albedo.rgba;
}

ENDHLSL
		}
	}
}
