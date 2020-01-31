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

struct PosAndColor {
    float4 pos [[position]];
    float4 color;
    float2 texCoords;
};

vertex PosAndColor vertex_shader(const device PosAndColor *vertexColorArray [[buffer(0)]], const device Constants *constants [[buffer(1)]], unsigned int vid [[vertex_id]]) {
    float4 xyzw = vertexColorArray[vid].pos;
    
    float4 NDC = xyzw/constants->bounds;
    PosAndColor pac;
    pac.pos = NDC;
    pac.color = vertexColorArray[vid].color;
    pac.texCoords = vertexColorArray[vid].texCoords;
    return pac;
}

fragment float4 fragment_color_shader(PosAndColor in [[stage_in]]) {
    return in.color;
}

fragment float4 fragment_texture_shader(PosAndColor in [[stage_in]], texture2d<float> texture [[texture(0)]]) {
    //I just, WHAT is with textures. Texels? MipMaps? %^%$%^%$%^%$%^%$!!@$@^%$##$%$#@!!!!
    constexpr sampler s(coord::normalized, address::clamp_to_border, filter::nearest);
    
    return texture.sample(s, in.texCoords);
}
