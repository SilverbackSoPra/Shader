float4x4 modelMatrix;
float4x4 viewMatrix;
float4x4 projectionMatrix;

float3 lightLocation;
float3 lightColor;
float lightAmbient;

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
	float3 pixelPosition : POSITION1;
	float2 pixelTexCoord : TEXCOORD;
};
	

VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
{
	
	VertexShaderOutput output;

	float4x4 mvMatrix = mul(modelMatrix, viewMatrix);
	
	output.vertexPosition = mul(float4(input.vertexPosition, 1.0f), mvMatrix);
	output.pixelPosition = output.vertexPosition.xyz;
	output.vertexPosition = mul(output.vertexPosition, projectionMatrix);
	
	output.pixelNormal = mul(float4(input.vertexNormal, 0.0f), mvMatrix).xyz;
	output.pixelTexCoord = input.vertexTexCoord;
	
	return output;
	
}

float3 PixelShaderFunction(VertexShaderOutput input) : COLOR
{
	
	float3 outColor = float3(1.0f, 1.0f, 1.0f);
	
	float3 textureColor = tex2D(textureSampler, input.pixelTexCoord).xyz;

	float3 normal = normalize(input.pixelNormal);
	float3 lightDirection = normalize(lightLocation - input.pixelPosition);

	// Specular lighting not necessary for now
	float3 ambient = textureColor.xyz * lightAmbient;
	float3 diffuse = max((dot(normal, lightDirection) * lightColor), ambient) * textureColor;
	
	outColor = diffuse + ambient;
	
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