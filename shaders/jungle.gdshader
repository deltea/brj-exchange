shader_type canvas_item;

uniform vec4 color: source_color;
uniform sampler2D noise_texture: repeat_enable;

void fragment() {
	float noise_value = texture(noise_texture, UV).x;
	COLOR = noise_value > 0.4 ? color : vec4(0.0);
}
