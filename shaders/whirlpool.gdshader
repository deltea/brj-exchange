shader_type canvas_item;

uniform float speed = 5.0;
uniform float arm_thickness = 0.2;
uniform vec3 color: source_color;
uniform sampler2D noise_texture: repeat_enable;

float swirl(vec2 uv, float size, int arms) {
	float angle = atan(-uv.y + 0.5, uv.x - 0.5);
	float len = length(uv - vec2(0.5));

	return sin(len * size + angle * float(arms) + TIME * speed);
}

void fragment() {
	float swirl = swirl(UV, 30.0, 5);
	float dist = distance(vec2(0.5), UV);
	float noise_val = texture(noise_texture, UV).x;
	vec4 final = swirl < arm_thickness ? vec4(0.0) : vec4(color, 1.0);
	COLOR = dist > 0.5 ? vec4(0.0) : final;
}
