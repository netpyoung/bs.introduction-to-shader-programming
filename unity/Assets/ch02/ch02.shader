Shader "popo/ch02"
{
    SubShader
    {
        Pass
        {
Tags{ "LightMode" = "UniversalForward"  }

HLSLPROGRAM
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

#pragma vertex vs_main
#pragma fragment ps_main

struct Raw {
    float4 Postion;
    float2 uv;
    float3 normal;
    float3 tangent;
};


struct VS_INPUT
{
   float4 mPosition : POSITION; // << object_Position
   float2 mUV : TEXCOORD0;      // << obj's coordinate
};

struct VS_OUTPUT
{
   float4 mPosition : SV_Position;
   float4 mUV : TEXCOORD0;
};

VS_OUTPUT vs_main(VS_INPUT Input)
{
    VS_OUTPUT Output = (VS_OUTPUT)0;
    Output.mPosition = mul(UNITY_MATRIX_M, Input.mPosition);
    Output.mPosition = mul(UNITY_MATRIX_V, Output.mPosition);
    Output.mPosition = mul(UNITY_MATRIX_P, Output.mPosition);
    return Output;
}

float4 ps_main(VS_OUTPUT Input) : SV_Target
{
    return float4(1.0f, 0.0f, 0.0f, 1.0f);
}

ENDHLSL

        }
    }
}
