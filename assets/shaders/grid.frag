#version 460 core

#include <flutter/runtime_effect.glsl>

precision mediump float;

uniform float uNumberOfCells;
uniform float uWidth;
uniform float uTime;
uniform sampler2D uTexture;

out vec4 fragColor;

void main() {
  vec2 uv = fract(FlutterFragCoord().xy / uWidth * uNumberOfCells * vec2(-1, 1) + vec2(uTime * 0.25));
  fragColor = texture(uTexture, uv);
}