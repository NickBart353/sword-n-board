shader_type spatial;

uniform sampler2D height_map;
uniform float region_size;
uniform vec2 region_world_pos;
uniform vec2 height_range;

void vertex() {
    // 1. Get the world position of THIS SPECIFIC VERTEX
    // Instead of using the instance origin, we use the actual vertex world-space coordinate
    vec3 vertex_world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;

    // 2. Calculate UV based on this vertex's specific location
    vec2 offset_pos = vertex_world_pos.xz - region_world_pos;
    vec2 uv = offset_pos / region_size;

    // 3. Sample height
    float height_sample = texture(height_map, uv).r;
    float terrain_height = mix(height_range.x, height_range.y, height_sample);

    // 4. Snap the vertex to the terrain
    // We adjust VERTEX.y so that its world-space Y matches the terrain_height
    VERTEX.y += (terrain_height - vertex_world_pos.y);
}

void fragment() {
    ALBEDO = vec3(0.1, 0.4, 0.1);
}