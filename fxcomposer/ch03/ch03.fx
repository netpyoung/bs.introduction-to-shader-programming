cbuffer CBufferPerObject
{
    float4x4 WorldViewProjection : WORLDVIEWPROJECTION;
}

RasterizerState DisableCulling
{
    CullMode = NONE;
};


Texture2D ColorTexture <
	string ResourceName = "Earth.jpg";
	string UIName = "Color Texture";
	string ResourceType = "2D";
>;

SamplerState ColorSampler
{
	Filter = MIN_MAG_MIP_LINEAR;
	AddressU = WRAP;
	AddressV = WRAP;
};

struct VS_INPUT
{
    float4 ObjectPosition: POSITION;
	float2 mUV: TEXCOORD;
};

struct VS_OUTPUT
{
    float4 Position: SV_Position;
	float2 mUV: TEXCOORD;
};

VS_OUTPUT vertex_shader(VS_INPUT IN)
{
    VS_OUTPUT OUT = (VS_OUTPUT)0;
    OUT.Position = mul(IN.ObjectPosition, WorldViewProjection);
	OUT.mUV = IN.mUV;
    return OUT;
}

float4 pixel_shader(VS_OUTPUT IN) : SV_Target
{
	return ColorTexture.Sample(ColorSampler, IN.mUV);
}

technique10 main10
{
    pass p0
    {
        SetVertexShader(CompileShader(vs_4_0, vertex_shader()));
        SetGeometryShader(NULL);
        SetPixelShader(CompileShader(ps_4_0, pixel_shader()));
        SetRasterizerState(DisableCulling);
    }
}