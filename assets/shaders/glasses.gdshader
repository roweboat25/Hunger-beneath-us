shader_type canvas_item;

// Screen-space filter for the ORA-frames.
// glasses: 1 = on, 0 = off. corruption: Game.connection / 100.
uniform sampler2D screen_tex : hint_screen_texture, filter_nearest, repeat_disable;
uniform float glasses : hint_range(0.0, 1.0) = 1.0;
uniform float corruption : hint_range(0.0, 1.0) = 0.0;
uniform float flash : hint_range(0.0, 1.0) = 0.0;

float rand(vec2 co) {
	return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
	vec2 uv = SCREEN_UV;
	float ab = corruption * 0.004 * glasses;
	vec3 col;
	col.r = texture(screen_tex, uv + vec2(ab, 0.0)).r;
	col.g = texture(screen_tex, uv).g;
	col.b = texture(screen_tex, uv - vec2(ab, 0.0)).b;

	// film grain, only with the glasses on and only once the frames are infected
	float g = (rand(floor(uv * vec2(480.0, 270.0)) + vec2(fract(TIME * 7.0))) - 0.5);
	col += g * 0.16 * corruption * glasses;

	// faint scanlines from the frames' display
	float scan = mod(floor(uv.y * 270.0), 2.0) * 0.045 * glasses;
	col *= 1.0 - scan;

	// vignette, tighter as corruption rises
	float d = distance(uv, vec2(0.5));
	col *= 1.0 - smoothstep(0.42, 0.95, d) * (0.3 + 0.45 * corruption) * glasses;

	// glasses off: 20% desaturated, a little darker, nothing else
	float lum = dot(col, vec3(0.299, 0.587, 0.114));
	vec3 off = mix(col, vec3(lum), 0.2) * 0.88;
	col = mix(off, col, glasses);

	col = mix(col, vec3(1.0), flash);
	COLOR = vec4(col, 1.0);
}
