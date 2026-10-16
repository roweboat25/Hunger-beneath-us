# Silico 3D: first-person proof of concept

A separate Godot 4.3 project (open `silico3d/project.godot` on its own; the
`.gdignore` keeps the 2D game from importing it). Everything is generated in
code at startup: geometry, textures and sound, so every placeholder can be
swapped for real art and audio later.

The title menu offers two things:

1. **Chapters 1 and 2** (book ch.1-2), played straight through:
   - *Dufredy's apartment*: the smell, the eyes on the carpet, the stick
     formation on the ceiling, the bloody laptop and Psyon's two pictures, the
     door, the officer.
   - *The drive*: the self-driving company car across Silico by day (broken
     signal, outage block, the billboard, the dash that says "Welcome, dreamer").
   - *Harmony Green*: photograph the scene, ORA's reconstruction of the run,
     the officer, Agata Greenwood, Seth McCarren, Tyson Clerif past the
     retaining wall, the masked figure. Ends on a case card, then the Spine.
2. **The Spine at night**, the first slice: glyphs, outage at 25, the tower's
   eye at 50.

Controls: mouse or arrow keys look, WASD walk, Shift hurry, E examine/talk,
G frames, F scan (frames on), P Psyon, M menu, Esc frees the mouse.

Dev arguments (after `--` on the command line, or `?key=value` in the URL):
`level=Dufredy|Drive|Park|Spine flags=a,b conn=N frames=1 at=x,y,z yaw=deg
pitch=deg crouch=m scan=1 noui=1`; Spine `eye=1 outage=1`; Dufredy
`showlaptop=1|2 reveal=1`; Drive `carz=-300`; Park `masked=1 ghost=1 photo=1`.
For headless checks `shot=path.png wait=frames` or `selftest=1` (all levels,
or just `level=X`):

    xvfb-run -a godot --path silico3d --rendering-driver opengl3 -- --selftest=1

Browser note: the web renderer went blank past roughly a thousand separate
objects, so `Level._batch` merges static scenery per material and per chunk.
Emission textures also don't render there, so lit windows are an additive layer.

Renderers: the browser build uses Compatibility (WebGL 2); the desktop/Windows
build uses Forward+ (`rendering_method` in `project.godot`). When a
RenderingDevice exists, `Main._apply_hifi()` turns on SSAO, SSIL, SSR, SDFGI,
volumetric fog, ACES tonemapping and softer 4-split sun shadows, then calls each
level's `hifi(env, sun)` hook for scene tweaks (lamp shadows in Dufredy's flat,
wetter streets on the Spine). Headless Forward+ shots work through lavapipe:
`--rendering-driver vulkan` with mesa-vulkan-drivers installed.

Materials: `assets/pbr/` holds photographed CC0 PBR sets from ambientCG
(asphalt, paving, concrete, grass, bark, wood floor, carpet, plaster, fabric,
rust; ids in `LICENSE.txt`), loaded with `Level.pbr(name, scale, triplanar,
tint, rough_mul)`. Their `.import` files are committed on purpose: normal maps
need `compress/normal_map=1` and everything needs mipmaps.

Painted facades, shop interiors and the leaf cards come from
`tools/gen_facades.py` (numpy + Pillow) into `assets/facades/`: six 10.5 m
wall tiles (albedo, lit-window emission, normal, roughness), four shop rooms,
one leaf cluster. Rerun it after editing; the `.import` files are committed.

Art style: `Retro.gd` is a CanvasLayer under the UI with one screen-space
shader: the frame at 427x240, 15-bit colour with Bayer dither, a neon haze
blur, violet shadows and a lifted curve at night, grain, vignette, colour
fringing and scanlines. `Main.load_level` calls `retro.tune(level.kit_day)`
for the lighter day grade; `style=0` turns the layer off, `res=W,H` changes
the resolution.

Scripts: `Main.gd` (level loading, input, interactions, self-test),
`Level.gd` (base class: build helpers, glyphs, power, the city kit with
`cyber_block`/`cyber_dress`/`kit_shop`/`tree`), `Body.gd` (people: lofted
bodies with painted faces and clothes, one mesh each for clothes and head;
`figure()` in Level calls it), `Car.gd` (swept car bodies: ground, hover,
van), `levels/` (`Dufredy.gd`, `Drive.gd`, `Park.gd`, `Spine.gd`, `Lineup.gd`
for checking people and cars), `Crowd.gd`, `Traffic.gd`, `Player.gd`,
`UI.gd` (frames overlay, dialogue, laptop, pictures, phone), `Synth.gd`
(sounds), `Tex.gd` (small procedural textures).
