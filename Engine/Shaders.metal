//
//  Shaders.metal
//  Engine
//
//  Created by Benjamin M. Pringle on 12/28/19.
//  Copyright © 2019 Benjamin M. Pringle. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct Constants {
    float4 bounds;
};

vertex float4 vertex_shader(const device float4 *vertexArray [[buffer(0)]], const device Constants *constants [[buffer(1)]], unsigned int vid [[vertex_id]]) {
    float4 xyzw = vertexArray[vid];
    
    
    float4 NDC = xyzw/constants->bounds;
    return NDC;
}

fragment half4 fragment_shader(float4 in [[stage_in]]) {
    return half4(1, 0, 0, 1);
}
