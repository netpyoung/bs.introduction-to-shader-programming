//**************************************************************//
//  Effect File exported by RenderMonkey 1.6
//
//  - Although many improvements were made to RenderMonkey FX  
//    file export, there are still situations that may cause   
//    compilation problems once the file is exported, such as  
//    occasional naming conflicts for methods, since FX format 
//    does not support any notions of name spaces. You need to 
//    try to create workspaces in such a way as to minimize    
//    potential naming conflicts on export.                    
//    
//  - Note that to minimize resulting name collisions in the FX 
//    file, RenderMonkey will mangle names for passes, shaders  
//    and function names as necessary to reduce name conflicts. 
//**************************************************************//

//--------------------------------------------------------------//
// ColorConversion
//--------------------------------------------------------------//
//--------------------------------------------------------------//
// EnvironmentMapping
//--------------------------------------------------------------//
string ColorConversion_EnvironmentMapping_Model : ModelData = "..\\..\\..\\..\\..\\Program Files (x86)\\AMD\\RenderMonkey 1.82\\Examples\\Media\\Models\\Teapot.3ds";

texture SceneTexture_Tex : RenderColorTarget
<
   float2 ViewportRatio={1.0,1.0};
   string Format="D3DFMT_A8R8G8B8";
   float  ClearDepth=1.000000;
   int    ClearColor=-16777216;
>;
float4x4 gWorldMatrix : World;
float4x4 gWorldViewProjectionMatrix : WorldViewProjection;


float4 gWorldLightPosition
<
   string UIName = "gWorldLightPosition";
   string UIWidget = "Direction";
   bool UIVisible =  false;
   float4 UIMin = float4( -10.00, -10.00, -10.00, -10.00 );
   float4 UIMax = float4( 10.00, 10.00, 10.00, 10.00 );
   bool Normalize =  false;
> = float4( 500.00, 500.00, -500.00, 1.00 );
float4 gWorldCameraPosition : ViewPosition;


struct VS_INPUT
{
   float4 mPosition : POSITION;
   float3 mNormal : NORMAL;
   float3 mTangent : TANGENT;
   float3 mBinormal : BINORMAL;
   float2 mUV : TEXCOORD0;
};



struct VS_OUTPUT
{
   float4 mPosition : POSITION;
   
   float2 mUV : TEXCOORD0;
   
   float3 mLightDir : TEXCOORD1;
   float3 mViewDir : TEXCOORD2;
   
   float3 T : TEXCOORD3;
   float3 B : TEXCOORD4;
   float3 N : TEXCOORD5;
};



VS_OUTPUT ColorConversion_EnvironmentMapping_Vertex_Shader_vs_main(VS_INPUT Input)
{
   VS_OUTPUT Output; 
   
   Output.mPosition = mul(Input.mPosition, gWorldViewProjectionMatrix);
   Output.mUV = Input.mUV;
 
   float4 worldPosition = mul(Input.mPosition, gWorldMatrix);
   float3 lightDir = worldPosition.xyz - gWorldLightPosition.xyz;
   Output.mLightDir = normalize(lightDir);
   
   
   float3 viewDir = normalize(worldPosition.xyz - gWorldCameraPosition.xyz);
   Output.mViewDir = viewDir;
   
   float3 worldNormal = mul(Input.mNormal, (float3x3)gWorldMatrix);
   Output.N = normalize(worldNormal);
   
   float3 worldTangent = mul(Input.mTangent, (float3x3)gWorldMatrix);
   Output.T = normalize(worldTangent);
   
   float3 worldBinormal = mul(Input.mBinormal, (float3x3)gWorldMatrix);
   Output.B = normalize(worldBinormal);
   
   return Output;  
}
texture DiffuseMap_Tex
<
   string ResourceName = "..\\..\\..\\..\\..\\Program Files (x86)\\AMD\\RenderMonkey 1.82\\Examples\\Media\\Textures\\Fieldstone.tga";
>;
sampler2D DiffuseSampler = sampler_state
{
   Texture = (DiffuseMap_Tex);
   MAGFILTER = LINEAR;
   MINFILTER = LINEAR;
};
texture SpecularMap_Tex
<
   string ResourceName = ".\\fieldstone_SM.tga";
>;
sampler2D SpecularSampler = sampler_state
{
   Texture = (SpecularMap_Tex);
   MAGFILTER = LINEAR;
   MINFILTER = LINEAR;
};
sampler2D NormalSampler;
texture EnvironmentMap_Tex
<
   string ResourceName = "..\\..\\..\\..\\..\\Program Files (x86)\\AMD\\RenderMonkey 1.82\\Examples\\Media\\Textures\\Snow.dds";
>;
samplerCUBE EnvironmentSampler = sampler_state
{
   Texture = (EnvironmentMap_Tex);
   MAGFILTER = LINEAR;
   MINFILTER = LINEAR;
};


float3 gLightColor
<
   string UIName = "gLightColor";
   string UIWidget = "Numeric";
   bool UIVisible =  false;
   float UIMin = -1.00;
   float UIMax = 1.00;
> = float3( 0.70, 0.70, 1.00 );



struct PS_INPUT
{
   float2 mUV : TEXCOORD0;
   float3 mLightDir : TEXCOORD1;
   float3 mViewDir : TEXCOORD2;
   float3 T : TEXCOORD3;
   float3 B : TEXCOORD4;
   float3 N : TEXCOORD5;
};



float4 ColorConversion_EnvironmentMapping_Pixel_Shader_ps_main(PS_INPUT Input) : COLOR
{
   float3 tangentNormal = tex2D(NormalSampler, Input.mUV).xyz;
   // tangentNormal = normalize(tangentNormal * 2 - 1);
   tangentNormal = float3(0, 0, 1);
   
   float3x3 TBN = float3x3(normalize(Input.T), normalize(Input.B), normalize(Input.N));
   TBN = transpose(TBN);
   
   float3 worldNormal = mul(TBN, tangentNormal);
   
   float4 albedo = tex2D(DiffuseSampler, Input.mUV);
   float3 lightDir = normalize(Input.mLightDir);
   float3 diffuse = saturate(dot(worldNormal, -lightDir));
   diffuse = gLightColor * albedo.rgb * diffuse;
   
   float3 viewDir = normalize(Input.mViewDir);
   float3 specular = 0;
   if (diffuse.x > 0)
   {
      float3 reflection = reflect(lightDir, worldNormal);
      
      specular = saturate(dot(reflection, -viewDir));
      specular = pow(specular, 20.0f);
      
      float4 specularIntensity = tex2D(SpecularSampler, Input.mUV);
      specular *= specularIntensity.rgb * gLightColor;
   }
   
   float3 viewReflect = reflect(viewDir, worldNormal);
   float3 environment = texCUBE(EnvironmentSampler, viewReflect).rgb;
   
   float3 ambient = float3(0.1f, 0.1f, 0.1f) * albedo;
   
   // return float4(environment, 1);
   return float4(ambient + diffuse + specular + environment * 0.5f, 1);
}
//--------------------------------------------------------------//
// EdgeDetection
//--------------------------------------------------------------//
string ColorConversion_EdgeDetection_ScreenAlignedQuad : ModelData = "..\\..\\..\\..\\..\\Program Files (x86)\\AMD\\RenderMonkey 1.82\\Examples\\Media\\Models\\ScreenAlignedQuad.3ds";

struct ColorConversion_EdgeDetection_Vertex_Shader_VS_INPUT 
{
   float4 mPosition : POSITION;
   float2 mUV : TEXCOORD0;   
};

struct ColorConversion_EdgeDetection_Vertex_Shader_VS_OUTPUT 
{
   float4 mPosition : POSITION;
   float2 mUV : TEXCOORD0;
};

ColorConversion_EdgeDetection_Vertex_Shader_VS_OUTPUT ColorConversion_EdgeDetection_Vertex_Shader_vs_main( ColorConversion_EdgeDetection_Vertex_Shader_VS_INPUT Input )
{
   ColorConversion_EdgeDetection_Vertex_Shader_VS_OUTPUT Output;

   Output.mPosition = Input.mPosition;
   Output.mUV = Input.mUV;
   
   return( Output );
   
}





struct ColorConversion_EdgeDetection_Pixel_Shader_PS_INPUT
{
   float2 mUV : TEXCOORD0;
};

sampler2D SceneSampler = sampler_state
{
   Texture = (SceneTexture_Tex);
};
float2 gPixelOffset : ViewportDimensionsInverse;

float3x3 Kx = { -1,  0, +1,
                -2,  0, +2,
                -1,  0, +1};

     
float3x3 Ky = { +1, +2, +1,
                 0,  0,  0,
                -1, -2, -1};
     
float4 ColorConversion_EdgeDetection_Pixel_Shader_ps_main(ColorConversion_EdgeDetection_Pixel_Shader_PS_INPUT Input) : COLOR
{
   float Lx = 0;
   float Ly = 0;
   
   for (int y = -1; y <= 1; ++y)
   {
      for (int x = -1; x <= 1; ++x)
      {
         float2 offset = float2(x, y) * gPixelOffset;
         float3 tex = tex2D(SceneSampler, Input.mUV + offset).rgb;
         float luminance = dot(tex, float3(0.3f, 0.59f, 0.11f));
         
         Lx += luminance * Kx[y + 1][x + 1];
         Ly += luminance * Ky[y + 1][x + 1];
      }
   }
   
   float L = sqrt((Lx * Lx) + (Ly * Ly));
   return float4(L.xxx, 1);
}
//--------------------------------------------------------------//
// Technique Section for ColorConversion
//--------------------------------------------------------------//
technique ColorConversion
{
   pass EnvironmentMapping
   <
      string Script = "RenderColorTarget0 = SceneTexture_Tex;"
                      "ClearColor = (0, 0, 0, 255);"
                      "ClearDepth = 1.000000;";
   >
   {
      VertexShader = compile vs_2_0 ColorConversion_EnvironmentMapping_Vertex_Shader_vs_main();
      PixelShader = compile ps_2_0 ColorConversion_EnvironmentMapping_Pixel_Shader_ps_main();
   }

   pass EdgeDetection
   {
      CULLMODE = NONE;

      VertexShader = compile vs_2_0 ColorConversion_EdgeDetection_Vertex_Shader_vs_main();
      PixelShader = compile ps_2_0 ColorConversion_EdgeDetection_Pixel_Shader_ps_main();
   }

}

