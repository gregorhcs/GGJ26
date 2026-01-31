shader_type canvas_item;
render_mode unshaded;

// === Editable parameters ===
uniform int CRACK_depth : hint_range(1, 10) = 3;                  // Number of fractal crack layers
uniform float CRACK_zebra_scale : hint_range(0.0, 5.0) = 1.0;    // Scale of fractal displacement along cracks
uniform float CRACK_zebra_amp : hint_range(0.0, 1.0) = 0.67;     // Amplitude of fractal displacement
uniform float CRACK_profile : hint_range(0.0, 1.0) = 1.0;       // Vertical falloff profile
uniform float CRACK_slope : hint_range(1.0, 100.0) = 50.0;       // Crack slope multiplier
uniform float RATIO : hint_range(0.1, 10.0) = 1.0;               // Stone length/width ratio
uniform float fracture_amount : hint_range(0.0, 1.0) = 0.0;      // 0 = intact, 1 = fully cracked

// === Hash / Noise Functions ===
float hash21(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float noise2(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f*f*(3.0 - 2.0*f);
    float v = mix(
        mix(hash21(i + vec2(0.0,0.0)), hash21(i + vec2(1.0,0.0)), f.x),
        mix(hash21(i + vec2(0.0,1.0)), hash21(i + vec2(1.0,1.0)), f.x),
        f.y
    );
    return 2.0*v - 1.0;
}

mat2 rot(float a) {
    float c = cos(a);
    float s = sin(a);
    return mat2(vec2(c, s), vec2(-s, c));
}

vec2 noise22(vec2 p) {
    return vec2(noise2(p), noise2(p + 17.7));
}

vec2 fbm22(vec2 p) {
    vec2 v = vec2(0.0);
    float a = 0.5;
    mat2 R = rot(0.37);
    for (int i = 0; i < 6; i++) {
        p *= 2.0;
        p *= R;
        v += a * noise22(p);
        a /= 2.0;
    }
    return v;
}

// === Voronoi ===
const float ofs = 0.5; // cell jitter

float disp(vec2 p) {
    return -ofs + (1.0 + 2.0*ofs) * hash21(p);
}

vec3 voronoiB(vec2 u) {
    vec2 iu = floor(u);
    vec2 C, P;
    float m = 1e9, d;

    for (int k=0; k < 25; k++) {
        vec2 p = iu + vec2(float(k%5-2), float(k/5-2));
        vec2 o = vec2(disp(p), disp(p+13.7));
        vec2 r = p - u + o;
        if (dot(r,r) < m) {
            m = dot(r,r);
            C = p-iu;
            P = r;
        }
    }

    m = 1e9;

    for (int k=0; k < 25; k++) {
        vec2 p = iu + C + vec2(float(k%5-2), float(k/5-2));
        vec2 o = vec2(disp(p), disp(p+13.7));
        vec2 r = p-u + o;
        if (dot(P-r,P-r) > 1e-5) {
            m = min(m, 0.5*dot((P+r), normalize(r-P)));
        }
    }

    return vec3(m, P+u);
}

// === Fragment ===
void fragment() {
    vec2 uv = UV;
    vec2 U = uv * 4.0; // scaling for Voronoi

    vec4 O = vec4(0.0);
    vec3 H0;

    for (float i = 0.0; i < float(CRACK_depth); i += 1.0) {
        vec2 V = U / vec2(RATIO, 1.0);
        vec2 D = CRACK_zebra_amp * fbm22(U / CRACK_zebra_scale) * CRACK_zebra_scale;
        vec3 H = voronoiB(V + D);
        if (i == 0.0) H0 = H;

        float d = H.x;
        d = min(1.0, CRACK_slope * pow(d, CRACK_profile * 5.0));

        O += vec4(1.0 - d) / pow(2.0, i);
        U *= 1.5 * rot(0.37);
    }

    // === Fracture amount threshold ===
	
	// O.r ranges from ~0 (crack) to ~1 (intact)
	// Invert mask so 0 = visible, 1 = transparent
	float mask = clamp(O.r, 0.0, 1.0);

	// Final color: fade texture to transparent
	COLOR = mix(texture(TEXTURE, UV), vec4(0.0), mask);
}
