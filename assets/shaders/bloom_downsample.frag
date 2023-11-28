#version 460 core

#include <flutter/runtime_effect.glsl>

precision mediump float;

uniform vec2 uSize;
uniform sampler2D uTexture;

out vec4 fragColor;

void main() {
  vec2 uv = FlutterFragCoord().xy / uSize;

  vec2 srcTexelSize = 1.0 / uSize;
  float x = srcTexelSize.x;
  float y = srcTexelSize.y;

  // Take 13 samples around current texel:
  // a - b - c
  // - j - k -
  // d - e - f
  // - l - m -
  // g - h - i
  // === ('e' is the current texel) ===
  vec3 a = texture(uTexture, vec2(uv.x - 2*x, uv.y + 2*y)).rgb;
  vec3 b = texture(uTexture, vec2(uv.x,       uv.y + 2*y)).rgb;
  vec3 c = texture(uTexture, vec2(uv.x + 2*x, uv.y + 2*y)).rgb;

  vec3 d = texture(uTexture, vec2(uv.x - 2*x, uv.y)).rgb;
  vec3 e = texture(uTexture, vec2(uv.x,       uv.y)).rgb;
  vec3 f = texture(uTexture, vec2(uv.x + 2*x, uv.y)).rgb;

  vec3 g = texture(uTexture, vec2(uv.x - 2*x, uv.y - 2*y)).rgb;
  vec3 h = texture(uTexture, vec2(uv.x,       uv.y - 2*y)).rgb;
  vec3 i = texture(uTexture, vec2(uv.x + 2*x, uv.y - 2*y)).rgb;

  vec3 j = texture(uTexture, vec2(uv.x - x, uv.y + y)).rgb;
  vec3 k = texture(uTexture, vec2(uv.x + x, uv.y + y)).rgb;
  vec3 l = texture(uTexture, vec2(uv.x - x, uv.y - y)).rgb;
  vec3 m = texture(uTexture, vec2(uv.x + x, uv.y - y)).rgb;

  // vec4 color = texture(uTexture, uv);

  // Apply weighted distribution:
  // 0.5 + 0.125 + 0.125 + 0.125 + 0.125 = 1
  // a,b,d,e * 0.125
  // b,c,e,f * 0.125
  // d,e,g,h * 0.125
  // e,f,h,i * 0.125
  // j,k,l,m * 0.5
  // This shows 5 square areas that are being sampled. But some of them overlap,
  // so to have an energy preserving downsample we need to make some adjustments.
  // The weights are the distributed, so that the sum of j,k,l,m (e.g.)
  // contribute 0.5 to the final color output. The code below is written
  // to effectively yield this sum. We get:
  // 0.125*5 + 0.03125*4 + 0.0625*4 = 1
  fragColor = vec4(e*0.125, 1);
  fragColor += vec4((a+c+g+i)*0.03125, 1);
  fragColor += vec4((b+d+f+h)*0.0625, 1);
  fragColor += vec4((j+k+l+m)*0.125, 1);

  // fragColor = texture(uTexture, uv);
}