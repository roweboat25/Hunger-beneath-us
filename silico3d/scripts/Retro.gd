extends CanvasLayer
## The art style: a PS1-era horror render (Signalis, Mouthwashing) with a
## neon-noir grade laid over the real frame. Low resolution, 15-bit colour
## with ordered dither, saturated magenta and cyan neon, violet shadows,
## grain, a vignette, colour fringing and faint scanlines (ian's references:
## VirtuaVerse, Sunset-style pixel cyberpunk). Sits under the UI (layer 10),
## so the HUD and text stay sharp. `style=0` on the command line or URL turns it off.

const SHADER := """
shader_type canvas_item;
uniform sampler2D screen_tex : hint_screen_texture, filter_nearest;
uniform vec2 res = vec2(427.0, 240.0);
uniform float levels = 32.0;
uniform float grain = 0.09;
uniform float vignette = 0.6;
uniform float scanline = 0.08;
uniform float amount = 1.0;
uniform float haze = 1.0;
uniform float lift = 0.35;

float h(vec2 p) { return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453); }

// 4x4 Bayer matrix, the PS1 dither pattern
float bayer(vec2 p) {
	int x = int(mod(p.x, 4.0));
	int y = int(mod(p.y, 4.0));
	int i = (x ^ y) & 3;
	int v = ((y & 1) << 3) | ((x & 1) << 2) | ((i & 1) << 1) | ((i >> 1) & 1);
	return (float(v) + 0.5) / 16.0;
}

void fragment() {
	vec2 uv = SCREEN_UV;
	// the low-res frame
	vec2 px = floor(uv * res) + 0.5;
	vec2 luv = px / res;
	vec2 cc = luv - 0.5;
	float fr = dot(cc, cc) * 0.004;
	vec3 col;
	col.r = texture(screen_tex, luv + cc * fr).r;
	col.g = texture(screen_tex, luv).g;
	col.b = texture(screen_tex, luv - cc * fr).b;
	vec3 sharp = texture(screen_tex, uv).rgb;
	// neon haze: a cheap blur of the low-res frame, added back where it is
	// bright and saturated, so every sign and window bleeds into the wet air
	vec3 glow = vec3(0.0);
	for (int i = -2; i <= 2; i++)
		for (int j = -2; j <= 2; j++)
			glow += texture(screen_tex, luv + vec2(float(i), float(j)) * 2.5 / res).rgb;
	glow /= 25.0;
	float gl = dot(glow, vec3(0.299, 0.587, 0.114));
	float gsat = length(glow - vec3(gl));
	col += glow * (0.35 + 1.4 * gsat) * smoothstep(0.08, 0.5, gl) * haze;
	// the neon-noir grade, after ian's references: a lifted filmic curve so
	// the night keeps its shapes, colour pushed, shadows falling to violet,
	// highlights leaning cyan, the neon boosted further
	col = col * (1.0 + lift) / (col + lift);
	float lum = dot(col, vec3(0.299, 0.587, 0.114));
	float sat = length(col - vec3(lum));
	float neon = smoothstep(0.15, 0.45, sat) * smoothstep(0.2, 0.6, max(max(col.r, col.g), col.b));
	col = mix(vec3(lum), col, 1.3 + 0.5 * neon);
	float sh = 1.0 - smoothstep(0.0, 0.35, lum);
	col = mix(col, col * vec3(0.95, 0.75, 1.15) + vec3(0.05, 0.015, 0.09), sh * 0.7);
	col = mix(col, col * vec3(0.92, 1.02, 1.1), smoothstep(0.5, 1.0, lum) * 0.35);
	col = (col - 0.5) * 1.1 + 0.5;
	col = max(col, vec3(0.0));
	// 15-bit colour with ordered dithering
	float d = (bayer(px) - 0.5) / levels;
	col = floor(col * levels + d * levels + 0.5) / levels;
	// film grain and scanlines
	float g = h(px + vec2(fract(TIME * 7.0) * 100.0)) - 0.5;
	col += g * grain * (0.4 + lum);
	col *= 1.0 - scanline * step(0.5, fract(uv.y * res.y * 0.5));
	// vignette
	vec2 c = uv - 0.5;
	col *= 1.0 - vignette * dot(c, c) * 2.2;
	COLOR = vec4(mix(sharp, clamp(col, 0.0, 1.0), amount), 1.0);
}
"""

var rect: ColorRect
var mat: ShaderMaterial


func _ready() -> void:
	layer = 5
	rect = ColorRect.new()
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	mat = ShaderMaterial.new()
	var sh := Shader.new()
	sh.code = SHADER
	mat.shader = sh
	rect.material = mat
	add_child(rect)


## style=0 off, style=ps1 (default) on; res=W,H for another resolution.
func apply(args: Dictionary) -> void:
	visible = str(args.get("style", "ps1")) not in ["0", "off", "none"]
	if args.has("res"):
		var v: PackedStringArray = str(args["res"]).split(",")
		if v.size() == 2:
			mat.set_shader_parameter("res", Vector2(float(v[0]), float(v[1])))


## Daylight scenes get far less haze and lift, or the smog washes them out.
func tune(day: bool) -> void:
	# the curve col*(1+lift)/(col+lift) is near identity for a large lift and
	# a strong shadow lift for a small one
	mat.set_shader_parameter("haze", 0.15 if day else 1.0)
	mat.set_shader_parameter("lift", 6.0 if day else 0.35)
	mat.set_shader_parameter("grain", 0.06 if day else 0.09)
