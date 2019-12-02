Shader "popo/ch11"
{
//     Properties
//     {
//         _MainTex ("_MainTex", 2D) = "white" {}
//     }
//     SubShader
//     {
//         Pass
//         {
// Tags{ "LightMode" = "UniversalForward"  }

// HLSLPROGRAM
// #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

// #pragma vertex vs_main
// #pragma fragment ps_main

// sampler2D _MainTex;

// struct VS_INPUT
// {
//    float4 mPosition : POSITION;
//    float2 mUV : TEXCOORD0;
// };

// struct VS_OUTPUT
// {
//    float4 mPosition : SV_Position;
//    float2 mUV : TEXCOORD0;
// };

// VS_OUTPUT vs_main(VS_INPUT Input)
// {
//     VS_OUTPUT Output;
//     Output.mPosition = Input.mPosition;
//     Output.mUV = Input.mUV;
//     return Output;
// }

// float4 ps_main(VS_OUTPUT Input) : SV_Target
// {
//     float3 c = tex2D(_MainTex, Input.mUV).rgb;
//     float lum = c.r * 0.3f + c.g * 0.59f + c.b * 0.11f;
//     return float4(1, 1, 1, 1.0f);
// }

// ENDHLSL

//         }
//     }

HLSLINCLUDE

        #include "Packages/com.unity.postprocessing/PostProcessing/Shaders/StdLib.hlsl"

        TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);
        float _Blend;

        float4 Frag(VaryingsDefault i) : SV_Target
        {
            float4 color = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.texcoord);
            float luminance = dot(color.rgb, float3(0.2126729, 0.7151522, 0.0721750));
            color.rgb = lerp(color.rgb, luminance.xxx, _Blend.xxx);
            //return color;
            return float4(1, 0, 0, 1);
        }

    ENDHLSL
    SubShader
    {
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            HLSLPROGRAM

                #pragma vertex VertDefault
                #pragma fragment Frag

            ENDHLSL
        }
    }
}
