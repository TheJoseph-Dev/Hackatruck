//
//  Shaders.metal
//  iMetal
//
//  Created by Turma01-23 on 15/06/25.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]] half4 uvShader(float2 pos, half4 color, float2 resolution, float time) {
    float2 uv = (pos/resolution);
    uv.y = 1-uv.y;
    return half4(uv.x, uv.y, 1, 1);
}

float map(float3 ray, float time) {
    const float maxDist = 0.15;
    float m = maxDist;
    float3 sPos = float3(sin(time)*0.2, 0.3, cos(time));
    float sRadius = 0.3;
    float3 tRay = ray - sPos;
    m = min(m, length(tRay)-sRadius);
    
    float ground = (ray.y + 0.1);
    m = min(m, ground);
    return m;
}

float3 getNormal(float3 p, float time) {
    float d0 = map(p, time);
    const float2 eps = float2(0.0001,0);
    float3 d1 = float3(
                       map(p-eps.xyy, time),
                       map(p-eps.yxy, time),
                       map(p-eps.yyx, time)
                       );
    return normalize(d0-d1);
}

float raymarch(float2 uv, float depth, float time) {
    const int maxDepth = 80;
    const float fov = 5.0; // The higher, bigger to distortion will be
    float3 rayOrigin = float3(0.0, 0.2, -2.0);
    float3 rayDir = normalize(float3(uv*(fov/10.0), 1.0));
   
    for (int i = 0; i < maxDepth; i++) {
        
        // Marches the ray from the origin to the current raydirection (uv)
        // the higher the depth value, more detail it adds => better edges
        // the higher length(march), further it'll be, so "whiter" will the object become
        float3 march = (rayOrigin + (rayDir * depth));
        
        depth += map(march, time); // Adds to depth
        
        if (depth < 0.01) break; // break if it's already too close (need to be less than map.maxDist)
        if (depth > 8.0) break; // break if it's too far
    }
    
    float3 normal = getNormal((rayOrigin + (rayDir * depth)), time);
    float3 lightPos = float3(1, 1, 0);
    
    depth *= dot(normal, lightPos);
    
    return depth/2 + 1;
}

[[ stitchable ]] half4 sphSDF(float2 pos, half4 color, float2 resolution, float time) {
    float2 uv = (pos/resolution);
    uv.y = 1-uv.y;
    uv = uv*2 - 1;
    uv.x *= resolution.x/resolution.y;

    float depth = raymarch(uv, 0, time);
    float zSpace = 5.0;
    
    return half4(half3(depth/zSpace), 1);
}

[[ stitchable ]] half4 sinewave(float2 pos, half4 color, float2 resolution, float time) {
    float2 uv = (pos/resolution);
    uv.y = 1-uv.y;
    uv = uv*2 - 1;
    uv.x *= resolution.x/resolution.y;
    float wave = sin(uv.x + time);
    wave *= wave * 50;
    float luma = abs(1 / (100 * uv.y*(sin(time/4)) + wave));
    return half4(half3(luma), 1);
}
