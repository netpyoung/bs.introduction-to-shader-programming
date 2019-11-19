# ch03

사실 빨강색으로 칠하기만 해서는 쓸모가 없다.

디자이너가 넘겨준 텍스쳐를 3D오브젝트에 뿌려줘야 간지난다.

그렇다면 Unity에서 Texture를 어떻게 쉐이더에 넘길까?

[unity: SL-Shader]

``` shader
Shader "#{shader-name}"
{
    [Properties]
    Subshaders
    [Fallback]
    [CustomEditor]
}
```

[unity: SL-Properties]

2D texture를 쓸것이니까, 다음과 같은 모양이 되겠다.

``` shader
Properties
{
  #{name} ("#{display name}", 2D) = "#{defaulttexture}" {}
}
```

보통 유니티에서 메인으로 쓰이는걸 변수로 `_MainTex`를 많이 쓴다. 그리고 텍스쳐가 맵핑되지 않았을때 기본텍스쳐를 `white`로 지정해주자. 가끔 선홍색으로 표시되기도 하는데, 그건 쉐이더 컴파일 에러가 났을시 보여주는 색이다.

``` shader
Properties
{
    _MainTex ("Texture", 2D) = "white" {}
}
```

``` shader
Shader "popo/ch03-1"
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
ENDCG
        }
    }
}
```

자 이제 shader program을 짜보자.

``` shader
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
```

## uv coordinate

texel(`TE`xture + pi`XEL`) coordinate

``` ref
Direct X

(0,0)        (1,0)
  +-----+-----+
  |     |     |
  |     |     |
  +-----+-----+
  |     |     |
  |     |     |
  +-----+-----+
(0,1)        (1,1)


OpenGL / UnityEngine

(0,1)        (1,1)
  +-----+-----+
  |     |     |
  |     |     |
  +-----+-----+
  |     |     |
  |     |     |
  +-----+-----+
(0,0)        (1,0)
```

수학적으로 바라보면 모든 2D좌표계를 OpenGL방식으로하면 좌표계를 헷갈릴 걱정이 없다.
하지만, 프로그래밍 하는 입장에서는 Direct X방식이 좀 더 와닿을 것이다.

## ch03-1

### 간단한 uv animation

간단하게 시간에 따라 uv좌표를 변환. 유니티에 있는 `UnityCG.cginc`를 포함시키자.

[unity: SL-BuiltinIncludes], [unity: SL-UnityShaderVariables]

``` shder
CGPROGRAM
// ...

#include "UnityCG.cginc"

// ...
ENDCG
```

|                 |                                                                                             |
| --------------- | ------------------------------------------------------------------------------------------- |
| _Time           | float4	Time since level load (t/20, t, t*2, t*3), use to animate things inside the shaders. |
| _SinTime        | float4	Sine of time: (t/8, t/4, t/2, t).                                                    |
| _CosTime        | float4	Cosine of time: (t/8, t/4, t/2, t).                                                  |
| unity_DeltaTime | float4	Delta time: (dt, 1/dt, smoothDt, 1/smoothDt).                                        |

``` csharp
Material mat;
Vector2 offset;
mat.SetTextureOffset ("_MainTex", offset);
```

``` shader
#include "UnityCG.cginc"

VS_OUTPUT vs_main(VS_INPUT Input)
{
    VS_OUTPUT Output;

    Output.mPosition = mul(UNITY_MATRIX_M, Input.mPosition);
    Output.mPosition = mul(UNITY_MATRIX_V, Output.mPosition);
    Output.mPosition = mul(UNITY_MATRIX_P, Output.mPosition);

    Output.mTexCoord = Input.mTexCoord;

    // _Time : float4
    // Time since level load (t/20, t, t*2, t*3), use to animate things inside the shaders.
    float t = _Time[1];
    Output.mTexCoord.x += t;

    return Output;
}

```

[unity: SL-Shader]: https://docs.unity3d.com/Manual/SL-Shader.html
[unity: SL-SubShader]: https://docs.unity3d.com/Manual/SL-SubShader.html
[unity: SL-Pass]: https://docs.unity3d.com/Manual/SL-Pass.html
[unity: SL-Properties]: https://docs.unity3d.com/Manual/SL-Properties.html
[unity: SL-BuiltinIncludes]: https://docs.unity3d.com/Manual/SL-BuiltinIncludes.html
[unity: SL-UnityShaderVariables]: https://docs.unity3d.com/Manual/SL-UnityShaderVariables.html
