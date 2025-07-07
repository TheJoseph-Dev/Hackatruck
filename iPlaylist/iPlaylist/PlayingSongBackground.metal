//
//  PlayingSongBackground.metal
//  iPlaylist
//
//  Created by Turma01-23 on 19/06/25.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]] half4 songBackground(float2 pos, half4 color, float2 resolution, float time, float3 avrgColor) {
    float2 uv = (pos/resolution);
    uv.y = 1-uv.y;
    uv = uv*2 - 1;
    uv.x *= resolution.x/resolution.y;
    
    return half4(half3(avrgColor+sin(time/2)*0.2), 1) * (uv.y+0.5);
}
