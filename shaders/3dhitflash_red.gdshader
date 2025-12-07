shader_type spatial;

render_mode blend_add, unshaded, cull_disabled, depth_draw_never;

uniform vec4 flash_color : source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform float flash_strength : hint_range(0.0, 1.0) = 0.0;
uniform bool hit_flash_on = false;

void fragment() {
	float is_active = hit_flash_on ? 1.0 : 0.0;
    ALBEDO = flash_color.rgb * (flash_strength * is_active);
}