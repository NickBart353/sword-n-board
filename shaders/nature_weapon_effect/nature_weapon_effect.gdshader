shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back;

// Colors
uniform vec3 base_color : source_color = vec3(0.05, 0.25, 0.1); // Dark vine green
uniform vec3 thorn_color : source_color = vec3(0.9, 0.1, 0.3); // Red/pink thorns

// Thorn structure
uniform float thorn_density = 40.0;
uniform float thorn_length = 0.05;
uniform float thorn_sharpness = 6.0;

// Pass data from vertex to fragment shader
varying float v_thorn_mask;

// Pseudo-random number generator based on UVs
vec2 random2(vec2 p) {
    return fract(sin(vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3)))) * 43758.5453);
}

// Procedural Voronoi noise to calculate distance to random cellular points
float voronoi(vec2 x) {
    vec2 n = floor(x);
    vec2 f = fract(x);
    float min_dist = 1.0;
    
    // Check neighboring grid cells to find the closest point
    for(int j = -1; j <= 1; j++) {
        for(int i = -1; i <= 1; i++) {
            vec2 g = vec2(float(i), float(j));
            vec2 o = random2(n + g); // Random point in cell
            vec2 r = g + o - f;      // Vector to the point
            float d = dot(r, r);     // Squared distance
            min_dist = min(min_dist, d);
        }
    }
    return min_dist; 
}

void vertex() {
    // 1. Generate the cellular distance field
    float v = voronoi(UV * thorn_density);
    
    // 2. Invert the distance so the cellular center points become the "peaks"
    float peak = 1.0 - sqrt(v);
    
    // 3. Sharpen the peaks using an exponential curve to make them look like thorns rather than bumps
    peak = pow(max(peak, 0.0), thorn_sharpness);
    
    // 4. Save the height data to color it in the fragment shader
    v_thorn_mask = peak;
    
    // 5. Physically displace the mesh vertices outward along their normals
    VERTEX += NORMAL * peak * thorn_length;
}

void fragment() {
    // Color gradient: blend from the dark green base to the red/pink thorn tip
    // Multiplying the mask by 1.5 forces the color transition to start slightly before the very tip of the thorn
    vec3 albedo = mix(base_color, thorn_color, clamp(v_thorn_mask * 1.5, 0.0, 1.0));
    
    ALBEDO = albedo;
    
    // Adjust material properties: thorns are slightly sharper/glossier than the vine base
    ROUGHNESS = mix(0.85, 0.3, v_thorn_mask);
}