#version 450

#ifdef GL_ES
precision lowp float;
#endif

in vec2 fTexCoord;
uniform sampler2D tex;

out vec4 fragColor;

void main() {

	fragColor = texture(tex, fTexCoord) ;
	
}