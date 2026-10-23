extends CanvasLayer
## Prototype: the "cinematic" look, after how Fallout: New York (an AI-built
## browser game, Sept 2026) dressed its procedural world: a full-resolution
## HDR frame, ACES, bloom, soft shadows, god rays through volumetric fog,
## depth of field, film grain and one strong colour grade per place.
## `look=cine` on the command line turns it on in place of Retro (the PS1
## layer); `grade=silico|day|psyon` picks the grade.
##
## The grade is a split tone (shadows to teal-violet, highlights to warm
## magenta-amber), a filmic S-curve, saturation held back in the mids so the
## neon is the only loud thing, a soft vignette and a fine grain. No pixelation,
## no dither: the detail stays.

const SHADER := """
shader_type canvas_item;
uniform sampler2D screen_tex : hint_screen_texture, filter_linear_mipmap;
uniform vec3 shadow_tint = vec3(0.06, 0.10, 0.16);
uniform vec3 high_tint = vec3(1.06, 0.96, 0.92);
uniform float contrast = 1.12;
uniform float sat = 0.92;
uniform float neon_keep = 1.25;
uniform float grain = 0.035;
uniform float vignette = 0.42;
uniform float letterbox = 0.0;
uniform float time_s = 0.0;

float h(vec2 p) { return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453); }

void fragment() {
	vec2 uv = SCREEN_UV;
	vec3 col = textureLod(screen_tex, uv, 0.0).rgb;
	// a touch of lens: colour fringe only at the very edges
	vec2 cc = uv - 0.5;
	float fr = dot(cc, cc) * 0.0035;
	col.r = mix(col.r, textureLod(screen_tex, uv + cc * fr, 0.0).r, 0.8);
	col.b = mix(col.b, textureLod(screen_tex, uv - cc * fr, 0.0).b, 0.8);
	float l = dot(col, vec3(0.2126, 0.7152, 0.0722));
	// saturation: hold the mids back, let strongly coloured light (neon) keep its punch
	float s = length(col - vec3(l));
	col = mix(vec3(l), col, mix(sat, neon_keep, smoothstep(0.15, 0.45, s)));
	// split tone
	col += shadow_tint * (1.0 - smoothstep(0.0, 0.45, l)) * 0.6;
	col *= mix(vec3(1.0), high_tint, smoothstep(0.35, 1.0, l));
	// filmic S around mid grey
	col = clamp(col, 0.0, 1.0);
	col = mix(col, col * col * (3.0 - 2.0 * col), contrast - 1.0);
	// vignette
	col *= 1.0 - vignette * smoothstep(0.25, 0.95, length(cc * vec2(1.0, 0.8)) * 1.35);
	// grain, stronger in the shadows like film
	float g = h(uv * vec2(1931.0, 1093.0) + fract(time_s) * 37.0) - 0.5;
	col += g * grain * (1.2 - l);
	// dialogue letterbox
	float lb = letterbox * 0.5;
	if (uv.y < lb * 0.14 || uv.y > 1.0 - lb * 0.14) col = vec3(0.0);
	COLOR = vec4(col, 1.0);
}
"""

const GRADES := {
	# Silico at night: teal-violet shadows, warm magenta highlights
	"silico": {"shadow_tint": Vector3(0.05, 0.09, 0.16), "high_tint": Vector3(1.08, 0.94, 0.98), "contrast": 1.16, "sat": 0.9, "neon_keep": 1.3},
	# the day: amber smog, like the book's dust
	"day": {"shadow_tint": Vector3(0.08, 0.07, 0.05), "high_tint": Vector3(1.07, 1.0, 0.86), "contrast": 1.1, "sat": 0.82, "neon_keep": 1.1},
	# Psyon's green, for the eye layer and the tower
	"psyon": {"shadow_tint": Vector3(0.03, 0.12, 0.08), "high_tint": Vector3(0.94, 1.08, 0.96), "contrast": 1.18, "sat": 0.85, "neon_keep": 1.25},
}

var rect: ColorRect
var mat: ShaderMaterial
var grade := "silico"
var _t := 0.0


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


func _process(delta: float) -> void:
	_t += delta
	mat.set_shader_parameter("time_s", _t)


func set_grade(g: String) -> void:
	grade = g if GRADES.has(g) else "silico"
	for k: String in GRADES[grade]:
		mat.set_shader_parameter(k, GRADES[grade][k])


func set_letterbox(on: bool) -> void:
	mat.set_shader_parameter("letterbox", 1.0 if on else 0.0)


## The renderer side, after the level's own setup_env and hifi: bloom from the
## HDR frame, deeper contact shadows, light shafts, and depth of field on the
## player's camera so the far city softens like a lens would.
func apply_env(env: Environment, sun: DirectionalLight3D, cam: Camera3D, day: bool) -> void:
	set_grade("day" if day else grade)
	env.tonemap_mode = Environment.TONE_MAPPER_ACES
	env.tonemap_white = 6.0
	env.glow_enabled = true
	env.glow_normalized = true
	env.glow_intensity = 0.9
	env.glow_strength = 1.0
	env.glow_bloom = 0.06
	env.glow_hdr_threshold = 0.9
	env.glow_hdr_scale = 2.0
	env.glow_blend_mode = Environment.GLOW_BLEND_MODE_SOFTLIGHT
	for i in 7:
		env.set_glow_level(i, 1.0 if i in [1, 2, 3, 4] else 0.0)
	env.adjustment_enabled = true
	env.adjustment_contrast = 1.05
	env.adjustment_saturation = 1.0
	if RenderingServer.get_rendering_device() != null:
		env.ssao_enabled = true
		env.ssao_radius = 0.9
		env.ssao_intensity = 2.8
		env.ssao_power = 1.6
		env.ssao_detail = 0.8
		env.volumetric_fog_enabled = true
		env.volumetric_fog_anisotropy = 0.7
	sun.shadow_enabled = true
	sun.shadow_blur = 2.0
	var ca := CameraAttributesPractical.new()
	ca.dof_blur_far_enabled = true
	ca.dof_blur_far_distance = 45.0
	ca.dof_blur_far_transition = 80.0
	ca.dof_blur_amount = 0.06
	cam.attributes = ca


## A close dialogue framing: near blur on, far blur pulled in to the subject.
func focus(cam: Camera3D, dist: float) -> void:
	var ca := cam.attributes as CameraAttributesPractical
	if ca == null:
		return
	ca.dof_blur_far_distance = dist + 0.6
	ca.dof_blur_far_transition = 3.0
	ca.dof_blur_amount = 0.1
