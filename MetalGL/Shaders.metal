//
//  Shaders.metal
//  MetalGL
//
//  Created by Oliver Letterer on 19.08.24.
//

// File for Metal kernel and shader functions

#include <metal_stdlib>
#include <simd/simd.h>

// Including header shared between this Metal shader code and Swift/C code executing Metal API commands
#import "ShaderTypes.h"

using namespace metal;

typedef struct
{
    float3 position [[attribute(0)]];
    float2 texCoord [[attribute(1)]];
} Vertex;

typedef struct
{
    float4 position [[position]];
    float2 texCoord;
    float3 vertex_position;
} ColorInOut;

vertex ColorInOut vertexShader(Vertex in [[stage_in]],
                               constant Uniforms & uniforms [[ buffer(2) ]])
{
    ColorInOut out;

    float4 position = float4(in.position, 1.0);
    out.position = uniforms.projectionMatrix * uniforms.modelViewMatrix * position;
    out.texCoord = in.texCoord;
    out.vertex_position = out.position.xyz;

    return out;
}

fragment float4 fragmentShader(ColorInOut in [[stage_in]],
                               constant Uniforms & uniforms [[ buffer(2) ]],
                               texture2d<half> colorMap     [[ texture(0) ]])
{
    float intensity = 1.0 - (length(in.vertex_position - float3(0.0, 0.0, 0.0)) - 8.0) / 4.0;
    return float4(0.0, 0.0, 1.0, 0.0) * intensity;
}
