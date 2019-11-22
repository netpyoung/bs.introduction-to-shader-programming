Shader "popo/ch03"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}

	SubShader
	{
		Pass
		{
CGPROGRAM

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
    return Output;
}

float4 ps_main(VS_OUTPUT Input) : SV_Target
{
    float4 albedo = tex2D(_MainTex, Input.mTexCoord);
    return albedo.rgba;
}

ENDCG
		}
	}
}
