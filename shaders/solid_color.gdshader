shader_type canvas_item;

uniform vec4 color: source_color;

void fragment() {
	vec4 original_color = texture(TEXTURE, UV);
	COLOR = vec4(color.rgb, original_color.a);
}
