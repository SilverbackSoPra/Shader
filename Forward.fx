float4x4 modelMatrix;
float4x4 viewMatrix;
float4x4 projectionMatrix;

float time;

texture albedoMap;
sampler2D textureSampler = sampler_state {
    Texture = (albedoMap);
    MagFilter = Linear;
    MinFilter = Linear;
    AddressU = Clamp;
    AddressV = Clamp;
};

struct VertexShaderInput
{
	float3 vertexPosition : POSITION0;
	float3 vertexNormal   : NORMAL0;
	float2 vertexTexCoord : TEXCOORD0;
};

struct VertexShaderOutput
{
	float4 vertexPosition : POSITION0;
	float3 pixelNormal : NORMAL;
	float2 pixelTexCoord : TEXCOORD;
};

VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
{
	
	VertexShaderOutput output;
	
	output.vertexPosition = mul(float4(input.vertexPosition, 1.0f), modelMatrix);
	output.vertexPosition = mul(output.vertexPosition, viewMatrix);
	output.vertexPosition = mul(output.vertexPosition, projectionMatrix);
	
	output.pixelNormal = input.vertexNormal;
	output.pixelTexCoord = input.vertexTexCoord;
	
	return output;
	
}

float4 PixelShaderFunction(VertexShaderOutput input) : COLOR
{
	
	float4 outColor = float4(1.0f, 1.0f, 1.0f, 1.0f);
	
	float4 textureColor = tex2D(textureSampler, input.pixelTexCoord);
	textureColor.a = 1;
	
	outColor = textureColor;
	
	return outColor;
	
}
	
	

technique Main
{
	pass Pass0
	{
		VertexShader = compile vs_5_0 VertexShaderFunction();
		PixelShader = compile ps_5_0 PixelShaderFunction();
	}
}