shader_type canvas_item;

uniform vec3 color_1: source_color;
uniform vec3 color_2: source_color;
uniform float swirl_speed = 1.0;

float swirl(vec2 uv, float size, int arms) {
	float angle = atan(-uv.y + 0.5, uv.x - 0.5);
	float len = length(uv - vec2(0.5, 0.5));

	return sin(len * size + angle * float(arms) - TIME * swirl_speed);
}

void fragment() {
	float swirl = swirl(UV, 20.0, 3);
	vec3 final = swirl < 0.5 ? color_1 : color_2;
	COLOR = vec4(final, 1.0);
}
