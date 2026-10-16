extends RefCounted
## Every sound in the slice is synthesized at startup: rain, the drone whine
## over the city, the preacher's chant, footsteps, the outage, the stings.
## Placeholders for a sound designer's work; each is one AudioStream to swap.

const RATE := 22050


static func _wav(s: PackedFloat32Array, loop: bool) -> AudioStreamWAV:
	var b := PackedByteArray()
	b.resize(s.size() * 2)
	for i in s.size():
		b.encode_s16(i * 2, int(clampf(s[i], -1.0, 1.0) * 32000.0))
	var w := AudioStreamWAV.new()
	w.format = AudioStreamWAV.FORMAT_16_BITS
	w.mix_rate = RATE
	w.stereo = false
	w.data = b
	if loop:
		w.loop_mode = AudioStreamWAV.LOOP_FORWARD
		w.loop_begin = 0
		w.loop_end = s.size()
	return w


static func _buf(seconds: float) -> PackedFloat32Array:
	var s := PackedFloat32Array()
	s.resize(int(seconds * RATE))
	return s


## Rain on wet concrete: filtered noise with droplets.
static func rain() -> AudioStreamWAV:
	var s := _buf(4.0)
	var lp := 0.0
	var lp2 := 0.0
	for i in s.size():
		var n := randf() * 2.0 - 1.0
		lp += (n - lp) * 0.35
		lp2 += (lp - lp2) * 0.5
		var v := lp2 * 0.45
		if randf() < 0.004:
			v += randf_range(-0.3, 0.3)
		s[i] = v
	# smooth the loop seam
	var fade := 600
	for i in fade:
		var a := float(i) / fade
		s[i] = s[i] * a + s[s.size() - fade + i] * (1.0 - a)
	return _wav(s, true)


## The city at night: a low electrical hum and the high whine of drones.
static func hum() -> AudioStreamWAV:
	var s := _buf(4.0)
	for i in s.size():
		var t := float(i) / RATE
		var v := sin(TAU * 55.0 * t) * 0.18 + sin(TAU * 110.0 * t) * 0.08 + sin(TAU * 165.25 * t) * 0.03
		var am := 0.5 + 0.5 * sin(TAU * 0.5 * t)
		v += (sin(TAU * 1402.0 * t) + sin(TAU * 1408.5 * t)) * 0.012 * am
		v += (randf() - 0.5) * 0.02
		s[i] = v
	return _wav(s, true)


## The chant: a voice-like buzz through two vowel formants, three even
## syllables and a breath, over and over. "Like a lullaby."
static func chant() -> AudioStreamWAV:
	var s := _buf(4.0)
	var vowels := [[700.0, 1100.0], [400.0, 800.0], [300.0, 2300.0], [500.0, 900.0]]
	var f1s := [0.0, 0.0]
	var b1 := [0.0, 0.0, 0.0, 0.0]
	var phase := 0.0
	for i in s.size():
		var t := float(i) / RATE
		var syl := int(t / 0.8)
		var in_syl := fmod(t, 0.8) / 0.8
		var env := 0.0
		if syl < 4:
			env = sin(PI * clampf(in_syl / 0.9, 0.0, 1.0))
		var pitch := 98.0 if syl != 2 else 110.0
		phase = fmod(phase + pitch / RATE, 1.0)
		var src := (phase * 2.0 - 1.0) * 0.5 + (randf() - 0.5) * 0.15
		var vw: Array = vowels[clampi(syl, 0, 3)]
		var out := 0.0
		for k in 2:
			# resonant two-pole bandpass
			var f: float = vw[k]
			var r := 0.985
			var c := 2.0 * r * cos(TAU * f / RATE)
			var y: float = src * (1.0 - r) + c * b1[k * 2] - r * r * b1[k * 2 + 1]
			b1[k * 2 + 1] = b1[k * 2]
			b1[k * 2] = y
			out += y * (1.0 if k == 0 else 0.6)
		s[i] = out * env * 2.2
	return _wav(s, true)


## A wood-and-wet-concrete footstep.
static func step() -> AudioStreamWAV:
	var s := _buf(0.16)
	var lp := 0.0
	for i in s.size():
		var t := float(i) / s.size()
		lp += ((randf() * 2.0 - 1.0) - lp) * 0.18
		s[i] = lp * pow(1.0 - t, 3.0) * 0.9 + sin(TAU * 70.0 * i / RATE) * pow(1.0 - t, 6.0) * 0.4
	return _wav(s, false)


## The power going: a deep thunk, then everything electrical winding down.
static func outage() -> AudioStreamWAV:
	var s := _buf(3.0)
	var ph := 0.0
	for i in s.size():
		var t := float(i) / RATE
		var v := sin(TAU * 38.0 * t) * exp(-t * 2.5) * 0.9
		if t < 0.02:
			v += randf_range(-0.8, 0.8)
		var f := 900.0 * exp(-t * 1.2) + 30.0
		ph = fmod(ph + f / RATE, 1.0)
		v += (1.0 if ph < 0.5 else -1.0) * 0.06 * exp(-t * 0.9)
		s[i] = v
	return _wav(s, false)


## A scare sting: a dissonant swell that cuts off.
static func sting() -> AudioStreamWAV:
	var s := _buf(2.2)
	var freqs := [196.0, 207.65, 277.18, 415.3, 61.7]
	for i in s.size():
		var t := float(i) / RATE
		var env := minf(1.0, t / 0.05) * exp(-t * 1.3)
		var v := 0.0
		for f in freqs:
			v += fmod(t * f, 1.0) * 2.0 - 1.0
		v = v / freqs.size() * 0.9 + (randf() - 0.5) * 0.4 * exp(-t * 6.0)
		s[i] = v * env
	return _wav(s, false)


## Frames going on or off: a short electronic blip.
static func blip(up: bool) -> AudioStreamWAV:
	var s := _buf(0.18)
	for i in s.size():
		var t := float(i) / s.size()
		var f := lerpf(600.0, 1400.0, t) if up else lerpf(1400.0, 500.0, t)
		s[i] = sin(TAU * f * i / RATE) * 0.3 * (1.0 - t)
	return _wav(s, false)


## A glitch: bit-crushed chirps, for glyphs and the frames tearing.
static func glitch() -> AudioStreamWAV:
	var s := _buf(0.5)
	var hold := 0.0
	for i in s.size():
		if i % 37 == 0:
			hold = randf_range(-0.6, 0.6) if randf() < 0.6 else 0.0
		s[i] = hold * (1.0 - float(i) / s.size())
	return _wav(s, false)


## A whisper: breath shaped like a word. Not a voice, just enough to make you turn.
static func whisper() -> AudioStreamWAV:
	var s := _buf(1.6)
	var lp := 0.0
	var hp := 0.0
	for i in s.size():
		var t := float(i) / RATE
		var n := randf() * 2.0 - 1.0
		lp += (n - lp) * 0.4
		hp = n - lp
		var env := 0.0
		if t < 0.45:
			env = sin(PI * t / 0.45)
		elif t > 0.55 and t < 1.3:
			env = sin(PI * (t - 0.55) / 0.75) * 0.8
		s[i] = (hp * 0.5 + lp * 0.3) * env * 0.7
	return _wav(s, false)


## A hover car going by: band-limited air.
static func car() -> AudioStreamWAV:
	var s := _buf(2.0)
	var lp := 0.0
	for i in s.size():
		var t := float(i) / RATE
		lp += ((randf() * 2.0 - 1.0) - lp) * 0.08
		s[i] = lp * 0.8 + sin(TAU * 180.0 * t) * 0.05
	var fade := 600
	for i in fade:
		var a := float(i) / fade
		s[i] = s[i] * a + s[s.size() - fade + i] * (1.0 - a)
	return _wav(s, true)


## A camp fire crackling.
static func fire() -> AudioStreamWAV:
	var s := _buf(3.0)
	var lp := 0.0
	for i in s.size():
		lp += ((randf() * 2.0 - 1.0) - lp) * 0.05
		var v := lp * 0.5
		if randf() < 0.0015:
			v += randf_range(-0.9, 0.9)
		s[i] = v
	return _wav(s, true)


static func _seam(s: PackedFloat32Array, fade := 600) -> void:
	for i in fade:
		var a := float(i) / fade
		s[i] = s[i] * a + s[s.size() - fade + i] * (1.0 - a)


## Flies over the eyes: a few buzzing tones that wander in pitch and loudness.
static func flies() -> AudioStreamWAV:
	var s := _buf(3.0)
	var ph := [0.0, 0.0, 0.0]
	var base := [190.0, 230.0, 270.0]
	for i in s.size():
		var t := float(i) / RATE
		var v := 0.0
		for k in 3:
			var f: float = base[k] + sin(t * (1.3 + k) + k) * 25.0 + sin(t * 9.0 + k * 2.0) * 8.0
			ph[k] = fmod(ph[k] + f / RATE, 1.0)
			var saw: float = ph[k] * 2.0 - 1.0
			var amp := 0.5 + 0.5 * sin(t * (0.7 + k * 0.45) * TAU / 3.0 * 3.0 + k)
			v += saw * amp * amp * 0.09
		s[i] = v
	_seam(s)
	return _wav(s, true)


## A dry stick snapping underfoot.
static func snap() -> AudioStreamWAV:
	var s := _buf(0.35)
	for i in s.size():
		var t := float(i) / RATE
		var v := (randf() * 2.0 - 1.0) * exp(-t * 60.0) * 0.9
		if t > 0.03 and t < 0.05:
			v += (randf() * 2.0 - 1.0) * 0.6
		v += sin(TAU * 900.0 * t) * exp(-t * 80.0) * 0.4
		s[i] = v
	return _wav(s, false)


## Something light hitting the top of your head.
static func tap() -> AudioStreamWAV:
	var s := _buf(0.2)
	for i in s.size():
		var t := float(i) / RATE
		s[i] = (sin(TAU * 420.0 * t) * 0.5 + (randf() - 0.5) * 0.4) * exp(-t * 45.0)
	return _wav(s, false)


## Psyon's soft ding. Friendly. Approved by committee.
static func ding() -> AudioStreamWAV:
	var s := _buf(1.4)
	for i in s.size():
		var t := float(i) / RATE
		var v := sin(TAU * 1318.5 * t) * exp(-t * 3.5) * 0.35 + sin(TAU * 1975.5 * t) * exp(-t * 5.0) * 0.15
		if t > 0.12:
			var u := t - 0.12
			v += sin(TAU * 1760.0 * u) * exp(-u * 3.5) * 0.3
		s[i] = v
	return _wav(s, false)


## Typing on a laptop keyboard.
static func keys() -> AudioStreamWAV:
	var s := _buf(1.6)
	var next := 0
	var age := 99999
	for i in s.size():
		if i >= next:
			age = 0
			next = i + int(RATE * randf_range(0.06, 0.16))
		var t := float(age) / RATE
		s[i] = (randf() * 2.0 - 1.0) * exp(-t * 300.0) * 0.5 + sin(TAU * 2400.0 * t) * exp(-t * 400.0) * 0.2
		age += 1
	return _wav(s, false)


## A laptop lid slammed shut.
static func slam() -> AudioStreamWAV:
	var s := _buf(0.5)
	var lp := 0.0
	for i in s.size():
		var t := float(i) / RATE
		lp += ((randf() * 2.0 - 1.0) - lp) * 0.3
		s[i] = (lp * 1.2 + sin(TAU * 110.0 * t) * 0.6) * exp(-t * 18.0)
	return _wav(s, false)


## A police car's whoop, two short rising sweeps.
static func siren() -> AudioStreamWAV:
	var s := _buf(1.6)
	var ph := 0.0
	for i in s.size():
		var t := float(i) / RATE
		var u := fmod(t, 0.8) / 0.8
		var f := lerpf(500.0, 1300.0, u * u)
		ph = fmod(ph + f / RATE, 1.0)
		var sq := 1.0 if ph < 0.5 else -1.0
		s[i] = (sq * 0.2 + sin(ph * TAU) * 0.2) * (1.0 - u * 0.6)
	return _wav(s, false)


## The company car's electric drive: a low whine and road rumble.
static func engine() -> AudioStreamWAV:
	var s := _buf(3.0)
	var lp := 0.0
	for i in s.size():
		var t := float(i) / RATE
		lp += ((randf() * 2.0 - 1.0) - lp) * 0.02
		s[i] = lp * 1.4 + sin(TAU * 330.0 * t) * 0.04 + sin(TAU * 41.0 * t) * 0.08
	_seam(s)
	return _wav(s, true)


## Desert wind on the edge of the climate control.
static func wind() -> AudioStreamWAV:
	var s := _buf(5.0)
	var lp := 0.0
	var lp2 := 0.0
	for i in s.size():
		var t := float(i) / RATE
		lp += ((randf() * 2.0 - 1.0) - lp) * 0.04
		lp2 += (lp - lp2) * 0.1
		s[i] = lp2 * (0.6 + 0.4 * sin(TAU * t / 5.0)) * 1.6
	_seam(s, 2000)
	return _wav(s, true)


## A crowd talking quietly: voices as formant buzz with no words.
static func murmur() -> AudioStreamWAV:
	var s := _buf(4.0)
	var voices := []
	for k in 6:
		voices.append({"f": randf_range(95.0, 230.0), "ph": 0.0, "rate": randf_range(2.0, 4.5), "off": randf() * TAU, "lp": 0.0})
	for i in s.size():
		var t := float(i) / RATE
		var v := 0.0
		for d in voices:
			var f: float = d.f * (1.0 + 0.08 * sin(t * 3.0 + d.off))
			d.ph = fmod(d.ph + f / RATE, 1.0)
			var src: float = d.ph * 2.0 - 1.0
			d.lp += (src - d.lp) * 0.12
			var env := maxf(0.0, sin(t * d.rate + d.off)) * maxf(0.0, sin(t * 0.7 + d.off * 2.0))
			v += d.lp * env * 0.12
		s[i] = v
	_seam(s, 3000)
	return _wav(s, true)


## "Welcome to Harmony Green - breathe easy, live smart!" The melody has
## gone off-key: every note slightly flat, and flatter as it goes.
static func jingle() -> AudioStreamWAV:
	var notes := [[523.25, 0.3], [659.25, 0.3], [783.99, 0.3], [1046.5, 0.5], [0.0, 0.15],
		[880.0, 0.25], [783.99, 0.25], [659.25, 0.25], [698.46, 0.6], [0.0, 0.2],
		[587.33, 0.25], [659.25, 0.25], [523.25, 0.9]]
	var total := 0.0
	for n in notes:
		total += n[1]
	var s := _buf(total + 0.6)
	var i := 0
	var k := 0
	for n in notes:
		var f: float = n[0] * pow(2.0, -(0.35 + k * 0.06) / 12.0)
		var nlen := int(n[1] * RATE)
		for j in nlen:
			if i >= s.size():
				break
			var t := float(j) / RATE
			var wob := 1.0 + 0.012 * sin(TAU * 5.0 * t)
			var v := 0.0
			if f > 0.0:
				var ph := fmod(t * f * wob, 1.0)
				v = (sin(ph * TAU) * 0.5 + (0.25 if ph < 0.25 else -0.08)) * minf(1.0, t * 40.0) * exp(-t * 2.0)
			s[i] = v * 0.5 + (randf() - 0.5) * 0.04
			i += 1
		k += 1
	return _wav(s, false)


## A dead speaker hissing on a drone pole.
static func static_hiss() -> AudioStreamWAV:
	var s := _buf(2.0)
	for i in s.size():
		var t := float(i) / RATE
		var crackle := randf_range(-0.8, 0.8) if randf() < 0.002 else 0.0
		s[i] = (randf() * 2.0 - 1.0) * (0.12 + 0.05 * sin(TAU * 0.5 * t)) + crackle
	_seam(s)
	return _wav(s, true)


## Seth's handheld vacuum.
static func vacuum() -> AudioStreamWAV:
	var s := _buf(2.0)
	var lp := 0.0
	for i in s.size():
		var t := float(i) / RATE
		lp += ((randf() * 2.0 - 1.0) - lp) * 0.25
		s[i] = lp * 0.35 + sin(TAU * 220.0 * t) * 0.12 + sin(TAU * 440.0 * t) * 0.05
	_seam(s)
	return _wav(s, true)


## "Like standing under a transmission tower and feeling your bones hum."
static func pressure() -> AudioStreamWAV:
	var s := _buf(6.0)
	for i in s.size():
		var t := float(i) / RATE
		var env := minf(1.0, t / 2.0) * minf(1.0, (6.0 - t) / 1.5)
		var v := sin(TAU * 50.0 * t) * 0.35 + sin(TAU * 100.3 * t) * 0.2 + sin(TAU * 31.0 * t) * 0.3
		v *= 0.7 + 0.3 * sin(TAU * 0.8 * t)
		s[i] = v * env
	return _wav(s, false)


## The frames taking a photo.
static func shutter() -> AudioStreamWAV:
	var s := _buf(0.18)
	for i in s.size():
		var t := float(i) / RATE
		var v := (randf() * 2.0 - 1.0) * (exp(-t * 90.0) + (exp(-(t - 0.07) * 90.0) if t > 0.07 else 0.0)) * 0.5
		s[i] = v
	return _wav(s, false)


## A door opening onto the street.
static func door() -> AudioStreamWAV:
	var s := _buf(0.9)
	var ph := 0.0
	for i in s.size():
		var t := float(i) / RATE
		var f := 300.0 + sin(t * 9.0) * 60.0
		ph = fmod(ph + f / RATE, 1.0)
		var creak := (ph * 2.0 - 1.0) * 0.12 * minf(1.0, t * 8.0) * exp(-t * 2.0)
		var thud := (randf() - 0.5) * exp(-(t - 0.75) * 30.0) * 0.8 if t > 0.75 else 0.0
		s[i] = creak + thud
	return _wav(s, false)


## A closed room on a hot day: the fridge, the air, nothing else.
static func room() -> AudioStreamWAV:
	var s := _buf(4.0)
	var lp := 0.0
	for i in s.size():
		var t := float(i) / RATE
		lp += ((randf() * 2.0 - 1.0) - lp) * 0.01
		s[i] = lp * 0.9 + sin(TAU * 60.0 * t) * 0.03 + sin(TAU * 120.0 * t) * 0.015
	_seam(s, 2000)
	return _wav(s, true)
