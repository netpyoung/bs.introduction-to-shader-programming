Shader "popo/ch06"
{
	Properties
	{
		_BaseColor ("_BaseColor", Color) = (1, 1, 1, 1)
		_ToonLevel ("_ToonLevel", Range (1,20)) = 4
	}

	SubShader
	{
		Pass
		{
			Tags{ "LightMode" = "ForwardAdd" }

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			float3 _BaseColor;
			float _ToonLevel;


			struct VS_INPUT
			{
			   float4 mPosition : POSITION;
			   float4 mNormal : NORMAL;
			};

			struct VS_OUTPUT
			{
			   float4 mPosition : SV_Position;
			   float3 mDiffuse : TEXCOORD1;
			};

			VS_OUTPUT vert(VS_INPUT Input)
			{
			   VS_OUTPUT Output;

			   float4 worldPosition = mul(UNITY_MATRIX_M, Input.mPosition);
			   float3 worldNormal = normalize(mul((float3x3)UNITY_MATRIX_M, Input.mNormal));
			   float3 lightDirectionUnnormlized = worldPosition.xyz - _WorldSpaceLightPos0.xyz;
			   float3 lightDirection = normalize(lightDirectionUnnormlized);

			   Output.mDiffuse = dot(worldNormal, -lightDirection);
			   Output.mPosition = mul(UNITY_MATRIX_VP, worldPosition);
			   return Output;
			}

			struct PS_INPUT
			{
				float3 mDiffuse : TEXCOORD1;
			};


			float4 frag(PS_INPUT Input) : SV_Target
			{
				float3 diffuse = saturate(Input.mDiffuse);
				//diffuse = ceil(diffuse * 4) / 4;
				diffuse = ceil(diffuse * _ToonLevel) / _ToonLevel;
				return float4(diffuse, 1);
			}

			ENDCG
		}
	}
}
