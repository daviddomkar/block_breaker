#version 460 core

#include <flutter/runtime_effect.glsl>

precision mediump float;

uniform vec2 uSize;
uniform float uTime;
uniform sampler2D uTexture;

out vec4 fragColor;

void main() {
  vec2 uv = fract((FlutterFragCoord().xy / uSize.x * 12 + vec2(uTime * 0.5) * -1) * vec2(1, -1));
  fragColor = texture(uTexture, uv);
}