Shader "popo/ch07"
{
	Properties
	{
		_BaseColor ("_BaseColor", Color) = (1, 1, 1, 1)

		_D_Texture ("_ToonLevel", 2D) = "" {}
		_S_Texture ("_S_Texture", 2D) = "" {}
		[Normal] _N_Texture ("_N_Texture", 2D) = "" {}
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
			sampler2D _D_Texture;
			sampler2D _S_Texture;
			sampler2D _N_Texture;
			

			struct VS_INPUT
			{
				float4 mPosition : POSITION;
				float4 mNormal : NORMAL;
				float3 mTangent : TANGENT;

				// https://docs.unity3d.com/Manual/SL-VertexProgramInputs.html
				float3 mBinormal : TANGENT;//BINORMAL;
				float2 mUV : TEXCOORD0;
			};

			struct VS_OUTPUT
			{
				float4 mPosition : SV_Position;

				float2 mUV : TEXCOORD0;
				float3 mLightDir : TEXCOORD1;
				float3 mViewDir : TEXCOORD2;

				float3 T : TEXCOORD3;
				float3 B : TEXCOORD4;
				float3 N : TEXCOORD5;
			};

			VS_OUTPUT vert(VS_INPUT Input)
			{
				VS_OUTPUT Output;

				float4 worldPosition = mul(UNITY_MATRIX_M, Input.mPosition);
				Output.mPosition = mul(UNITY_MATRIX_VP, worldPosition);

				Output.mUV = Input.mUV;
				Output.mLightDir = normalize(worldPosition.xyz - _WorldSpaceLightPos0.xyz);
				Output.mViewDir = normalize(worldPosition.xyz - _WorldSpaceCameraPos.xyz);

				Output.N = normalize(mul((float3x3)UNITY_MATRIX_M, Input.mNormal));
				Output.T = normalize(mul((float3x3)UNITY_MATRIX_M, Input.mTangent));
				Output.B = normalize(mul((float3x3)UNITY_MATRIX_M, Input.mBinormal));
				return Output;
			}

			struct PS_INPUT
			{
				float2 mUV : TEXCOORD0;
				float3 mLightDir : TEXCOORD1;
				float3 mViewDir : TEXCOORD2;

				float3 T : TEXCOORD3;
				float3 B : TEXCOORD4;
				float3 N : TEXCOORD5;
			};


			float4 frag(PS_INPUT Input) : SV_Target
			{
				float3 light_color = unity_LightColor[0].rgb;

				float3 tangentNormal = tex2D(_N_Texture, Input.mUV).xyz;
				float3x3 TBN = float3x3(normalize(Input.T), normalize(Input.B), normalize(Input.N));
				TBN = transpose(TBN);
				float3 worldNormal = mul(TBN, tangentNormal);
				float4 albedo = tex2D(_D_Texture, Input.mUV);
				float3 lightDir = normalize(Input.mLightDir);
				float3 diffuse = saturate(dot(worldNormal, -lightDir));
				diffuse = light_color * albedo.rgb * diffuse;

				//float3 diffuse = light_color * albedo.rgb * saturate(Input.mDiffuse);

				//diffuse = ceil(diffuse * 4) / 4;
				//diffuse = ceil(diffuse * _ToonLevel) / _ToonLevel;
				float3 ambient = float3(0.1f, 0.1f, 0.1f) * albedo;
				//return float4(diffuse, 1);
				return float4(diffuse + ambient, 1);
				return float4(ambient, 1);
				return float4(1,1,1,1);
			}

			ENDCG
		}
	}
}
