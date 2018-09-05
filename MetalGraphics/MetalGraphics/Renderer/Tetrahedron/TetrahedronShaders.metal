//
//  Shaders.metal
//  TetrahedronShaders
//
//  Created by lowe on 2018/8/17.
//  Copyright © 2018 lowe. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct Vertex {
    float4 position [[position]];
    float4 color;
};

struct Uniforms {
    float4x4 modelViewProjectionMatrix;
};

vertex Vertex tetrahedronShader(device Vertex *vertics [[buffer(0)]],
                                constant Uniforms *uniforms [[buffer(1)]],
                                uint vid [[vertex_id]]) {
    Vertex vertexOut;
    vertexOut.position = uniforms->modelViewProjectionMatrix * vertics[vid].position;
    vertexOut.color = vertics[vid].color;
    
    return vertexOut;
}

fragment float4 tetrahedronFragment(Vertex inVertex [[stage_in]]) {
    return inVertex.color;
}

