shader_type canvas_item;

uniform vec4 color_1: source_color;
uniform vec4 color_2: source_color;
uniform float swirl_speed = 1;
uniform float looseness = 0.4;
uniform int arms = 3;
uniform float size = 20.0;
uniform sampler2D noise;

float swirl(vec2 uv) {
	float angle = atan(-uv.y + 0.5, uv.x - 0.5);
	float len = length(uv - vec2(0.5, 0.5));

	return sin(len * size + angle * float(arms) - TIME * swirl_speed);
}

void fragment() {
	float swirl = swirl(UV);
	float noise_val = texture(noise, UV).x;
	vec4 final = swirl * noise_val < looseness ? color_1 : color_2;
	COLOR = vec4(final);
}
