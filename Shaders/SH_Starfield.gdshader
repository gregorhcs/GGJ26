shader_type canvas_item;
render_mode unshaded;

uniform float density : hint_range(0.0, 1.0) = 0.25; // chance per cell
uniform float cell_size = 12.0;                     // spacing in pixels
uniform float star_size = 2.0;                      // star pixel size

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

vec3 star_color(float t) {
    if (t < 0.6) return vec3(1.0);
    else if (t < 0.75) return vec3(0.8, 0.9, 1.0);
    else if (t < 0.9) return vec3(1.0, 0.95, 0.8);
    else return vec3(1.0, 0.8, 0.8);
}

void fragment() {
    vec2 viewport_size = 1.0 / SCREEN_PIXEL_SIZE;
    vec2 pixel = SCREEN_UV * viewport_size;

    vec2 cell = floor(pixel / cell_size);
    float r = hash(cell);

	vec3 col = vec3(0.0);

    if (r < density) {
        // Random position inside cell (top-left of star)
        vec2 star_pos = floor(
            vec2(hash(cell + 1.3), hash(cell + 7.7)) * (cell_size - star_size)
        );

        vec2 local = mod(pixel, cell_size);
		
		float local_star_size = star_size *  hash(cell + 5.3);

        // Draw a star_size x star_size square
        if (
            local.x >= star_pos.x &&
            local.y >= star_pos.y &&
            local.x < star_pos.x + local_star_size &&
            local.y < star_pos.y + local_star_size
        ) {
            col = star_color(hash(cell * 2.7));
        }
    }

    COLOR = vec4(col, 1.0);
}