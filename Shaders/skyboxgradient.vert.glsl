#version 450

#ifdef GL_ES
    precision lowp float;
#endif

uniform mat4 inProjectionMatrix;
uniform mat4 modelView;

in vec4 vertexPosition;

smooth out vec3 eyeDirection;

mat3 trans(in mat3 inMatrix) {
    vec3 i0 = inMatrix[0];
    vec3 i1 = inMatrix[1];
    vec3 i2 = inMatrix[2];

    mat3 outMatrix = mat3(
        vec3(i0.x, i1.x, i2.x),
        vec3(i0.y, i1.y, i2.y),
        vec3(i0.z, i1.z, i2.z)
    );

    return outMatrix;
}

void main() {

    mat3 inverseModelview = trans(mat3(modelView));
    vec3 unprojected = (inProjectionMatrix * vertexPosition).xyz;
    eyeDirection = inverseModelview * unprojected;

    gl_Position = vertexPosition;
}