# fxcomposer

|         |                            |
| ------- | -------------------------- |
| F6      | (Rebuild All)              |
| Ctrl+F7 | (Compile Selected Effect). |


SAS (that is, "Standard Annotations and
Semantics," and usually pronounced "sass")

- http://developer.download.nvidia.com/whitepapers/2008/Using_SAS_v1_03.pdf

DirectX 8.x : Shader Model 1.x
DirectX 9.x : Shader Model 2.x ~ 3.x
DirectX 10.x : Shader Model 4.x
Directx 11.x : Shader Model 5.x

by 낄낄

cbuffer: Constant Buffer

`technique10`은 Direct3D10을 나타낸다.(ex Direct3D11은 technique11).


 WORLD, VIEW,
PROJECTION, WORLDVIEW, VIEWPROJECTION, or WORLDVIEWPROJECTION

 suffixes INVERSE and TRANSPOSE

VIEWINVERSE

WORLDVIEWPROJECTIONINVERSETRANSPOSE


[FX Composer 2.5 - New Features](https://www.youtube.com/watch?v=KCWkq-L-HgY)



``` fxcomposer
cbuffer CBufferPerObject
{
    float4x4 WorldViewProjection : WORLDVIEWPROJECTION;
}

RasterizerState DisableCulling
{
    CullMode = NONE;
};

struct VS_INPUT
{
    float4 ObjectPosition: POSITION;
};

struct VS_OUTPUT
{
    float4 Position: SV_Position;
};

VS_OUTPUT vertex_shader(VS_INPUT IN)
{
    VS_OUTPUT OUT = (VS_OUTPUT)0;
    OUT.Position = mul(IN.ObjectPosition, WorldViewProjection);
    return OUT;
}

float4 pixel_shader(VS_OUTPUT IN) : SV_Target
{
    return float4 (1, 0, 0, 1);
}

technique10 main10
{
    pass p0
    {
        SetVertexShader( CompileShader (vs_4_0, vertex_shader()));
        SetGeometryShader( NULL );
        SetPixelShader( CompileShader (ps_4_0, pixel_shader()));
        SetRasterizerState(DisableCulling);
    }
}
```
