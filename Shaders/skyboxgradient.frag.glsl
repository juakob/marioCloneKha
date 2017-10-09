#version 450

#ifdef GL_ES
    precision lowp float;
#endif

smooth in vec3 eyeDirection;

out vec4 fragmentColor;

uniform vec4 skytop = vec4(1.0f, 1.0f, 1.0f, 1.0f);
uniform vec4 skyhorizon = vec4(1.0f, 1.0f, 1.0f, 1.0f);
uniform int steps = 100;



void main() {
    float delta = eyeDirection.y;
    vec4 mix =  mix(skyhorizon, skytop, delta);
    fragmentColor =  (mix * steps)/steps;
}