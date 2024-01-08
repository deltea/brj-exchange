shader_type canvas_item;

uniform bool enabled = false;
uniform vec4 color: source_color = vec4(1);

void fragment() {
	if (enabled) {
		vec4 original_color = texture(TEXTURE, UV);
		COLOR = vec4(color.rgb, original_color.a);
	}
}
