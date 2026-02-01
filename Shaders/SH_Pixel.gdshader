shader_type canvas_item;
render_mode unshaded;

uniform float pixel_size = 4.0;

void fragment() {
    vec2 uv = UV;

    vec2 pixel_uv = floor(uv / (SCREEN_PIXEL_SIZE * pixel_size))
                  * (SCREEN_PIXEL_SIZE * pixel_size);

    COLOR = texture(TEXTURE, pixel_uv) * COLOR;
}
