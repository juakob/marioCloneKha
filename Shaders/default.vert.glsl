#version 450

#ifdef GL_ES
precision lowp float;
#endif

// Input vertex data, different for all executions of this shader
layout(location = 0) in vec3 position;
layout(location = 1) in vec2 uv;
layout(location = 2) in vec3 normal;

out vec2 fTexCoord;

uniform mat4 MVP;


void main() {
  vec4 npos = MVP * vec4(position,1.0);
  fTexCoord = uv;
  gl_Position =   npos;
}