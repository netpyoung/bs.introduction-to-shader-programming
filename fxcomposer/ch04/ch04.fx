cbuffer CBufferPerFrame
{
	float3 gLightDirection : DIRECTION;
	float3 gCameraPosition : CAMERAPOSITION;
}

cbuffer CBufferPerObject
{
    float4x4 MATRIX_MVP : WORLDVIEWPROJECTION;
	float4x4 MATRIX_VP : VIEWPROJECTION;
	float4x4 MATRIX_M : WORLD;
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
    float4 mPosition: POSITION;
	float3 mNormal: NORMAL;
	float2 mUV: TEXCOORD;
};

struct VS_OUTPUT
{
    float4 mPosition: SV_Position;
	float2 mUV: TEXCOORD0;
	float3 mDiffuse: TEXCOORD1;
	float3 mViewDir: TEXCOORD2;
	float3 mReflect: TEXCOORD3;
};

VS_OUTPUT vertex_shader(VS_INPUT In)
{
    VS_OUTPUT Out = (VS_OUTPUT)0;

	Out.mUV = In.mUV;
	Out.mPosition = mul(In.mPosition, MATRIX_M);
	Out.mViewDir = normalize(Out.mPosition.xyz - gCameraPosition.xyz);
	Out.mPosition = mul(Out.mPosition, MATRIX_VP);
	
	float3 worldNormal = mul((float3x3)MATRIX_M, In.mNormal);
	Out.mDiffuse = dot(-gLightDirection, worldNormal);
	Out.mReflect = reflect(gLightDirection, worldNormal);
    return Out;
}

float4 pixel_shader(VS_OUTPUT In) : SV_Target
{
	float3 ambient = ColorTexture.Sample(ColorSampler, In.mUV);
	float3 diffuse = saturate(In.mDiffuse);
	float3 specular = 0;
	if (diffuse.x > 0)
	{
		float3 viewDir = normalize(In.mViewDir);
		float3 reflect = normalize(In.mReflect);
		specular = pow(dot(reflect, -viewDir), 20);
	}
	return float4(diffuse + specular, 1);
	return float4(specular, 1);
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