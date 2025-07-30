#include <metal_stdlib>
using namespace metal;

float ringOutline(float dist, float radius, float thickness) {
    return smoothstep(radius - thickness, radius, dist) - smoothstep(radius, radius + thickness, dist);
}

float3 orbit(float2 uv, float3 baseColor, float time, float onCamera) {
    float dist = length(uv);
    float3 orbitColor  = float3(250.0, 215.0, 76.0) / 255.0;     // #FAD74C
    float orbitRadius = onCamera < 0.1 ? 0.4 : 0.3;
    float orbitThickness = 0.01;
    float orbitLine = ringOutline(dist, orbitRadius, orbitThickness);

    float orbitAlpha = 0.5 * orbitLine;
    baseColor = mix(baseColor, orbitColor, orbitAlpha);
    
    float angle = time * 0.5; // angular velocity
    float2 planetPos = float2(cos(angle), sin(angle)) * orbitRadius;
    float planetDist = length(uv - planetPos);
    float planetRadius = 0.03;

    float planet = smoothstep(planetRadius, planetRadius - 0.01, planetDist);
    float planetAlpha = 0.5 * planet;
    baseColor = mix(baseColor, orbitColor, planetAlpha);
    return baseColor;
}

float3 ripple(float2 uv, float3 baseColor, float progress, float speed) {
    float dist = length(uv);
    float3 circleColor = float3(63.0, 183.0, 234.0) / 255.0;     // #3FB7EA
    float t = fract(progress * speed);
    float eased = smoothstep(0.0, 1.0, t);
    float wave = mix(0.0, 1.1, eased);
    float thickness = 0.05;
    float fade = 1.0 - eased;

    // Ring shape using double smoothstep (both edges)
    float ring = smoothstep(wave, wave - thickness, dist) *
                 smoothstep(wave + thickness, wave, dist);

    // Apply fade and alpha blend over base
    float ringAlpha = ring * fade;
    
    baseColor = mix(baseColor, circleColor, ringAlpha);
    return baseColor;
}

float3 circles(float2 uv, float time, float onCamera) {
    float dist = length(uv);

    float s = ((sin(time)+1.0)*0.5)*0.03;
    float r1 = onCamera < 0.1 ? 0.25 : 0.18;
    float r2 = onCamera < 0.1 ? 0.3 + s*0.5 : 0.2 + s*0.3;
    float r3 = onCamera < 0.1 ? 0.36 + s : 0.24 + s*0.8;

    float edge = 0.01;

    // Create soft circles using smoothstep
    float a1 = smoothstep(r1, r1 - edge, dist);
    float a2 = smoothstep(r2, r2 - edge, dist);
    float a3 = smoothstep(r3, r3 - edge, dist);

    float alpha1 = 0.5 * a1;
    float alpha2 = 0.5 * a2;
    float alpha3 = 0.5 * a3;

    float totalAlpha = 1.0 - (1.0 - alpha1) * (1.0 - alpha2) * (1.0 - alpha3);
    float3 circleColor = float3(63.0, 183.0, 234.0) / 255.0;     // #3FB7EA
    
    float3 bgColor = float3(1.0);
    // Blended result over white
    return mix(bgColor, circleColor, totalAlpha);
}

[[ stitchable ]] half4 horus(float2 pos, half4 color, float2 resolution, float time, float progress, float discard) {
    float2 uv = (pos / resolution);
    uv.y = 1 - uv.y;
    uv = uv * 2 - 1;
    uv.x *= resolution.x / resolution.y;
    uv.y += discard > 0.1 ? 0.4 : -0.15;
    
    float3 baseColor = circles(uv, time, discard);
    //if(discard < 0.1) baseColor = ripple(uv, baseColor, progress, 0.5);
    if(discard < 0.1) baseColor = orbit(uv, baseColor, time, discard);
    
    if(discard > 0.1 && baseColor.x >= 0.9 && baseColor.y >= 0.9 && baseColor.z >= 0.9) return half4(0.0,0.0,0.0,0.0);
    return half4(baseColor.x, baseColor.y, baseColor.z, 1);
}
