shader_type spatial;
render_mode cull_back, depth_draw_opaque;

uniform sampler2D heightmap;
uniform vec3 terrain_origin;   // World-space bottom-left corner of terrain
uniform vec2 terrain_size;     // Size of terrain in XZ (world units)
uniform float height_scale = 0.5;

void vertex() {
    vec3 instance_world_pos = (MODEL_MATRIX * vec4(0.0, 0.0, 0.0, 1.0)).xyz;

    vec2 uv;
    uv.x = (instance_world_pos.x - terrain_origin.x) / terrain_size.x;
    uv.y = (instance_world_pos.z - terrain_origin.z) / terrain_size.y;

    float height = texture(heightmap, uv).r * height_scale;

    float offset = (terrain_origin.y + height) - instance_world_pos.y;

    VERTEX.y += offset;
}
