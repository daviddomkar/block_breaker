#version 460 core

#include <flutter/runtime_effect.glsl>

precision mediump float;

uniform float uTreshold;
uniform float uIntensity;
uniform vec2 uSize;
uniform sampler2D uTexture;

out vec4 fragColor;

void main() {
  vec2 uv = FlutterFragCoord().xy / uSize;
  vec4 color = texture(uTexture, uv);

  float luma = 0.212 * color.r + 0.701 * color.g + 0.087 * color.b;

  if (luma < uTreshold) {
    fragColor = vec4(0);
  } else {
    fragColor = color * uIntensity;
  }
}