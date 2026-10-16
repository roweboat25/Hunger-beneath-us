# Silico 3D: the Spine (first-person test slice)

A separate Godot 4.3 project (open `silico3d/project.godot` on its own; the
`.gdignore` keeps the 2D game from importing it). Everything is generated in
code at startup: geometry, textures and sound, so every placeholder can be
swapped for real art and audio later.

Play: walk the Spine toward the Psyonic tower at night. G puts the frames on;
E reads the two-ring glyphs (each decodes a line of the chant and raises the
connection). At 25 the power goes and the crowd starts watching you. At 50 the
tower opens its eye. Walk the garden path to the tower to end the slice.

Controls: mouse or arrow keys look, WASD walk, Shift hurry, E examine/talk,
G frames, F scan (frames on), P Psyon, Esc frees the mouse.

Dev arguments (after `--` on the command line, or `?key=value` in the URL):
`conn=N frames=1 at=x,y,z yaw=deg pitch=deg eye=1 outage=1 scan=1`, and for
headless checks `shot=path.png wait=frames` or `selftest=1`:

    xvfb-run -a godot --path silico3d --rendering-driver opengl3 -- --selftest=1

Browser note: the web renderer went blank past roughly a thousand separate
objects, so `City._batch` merges static scenery per material and per 40 m.
Emission textures also don't render there, so lit windows are an additive layer.

Scripts: `Main.gd` (flow, interactions, set pieces), `City.gd` (the street and
the tower), `Crowd.gd` (people), `Traffic.gd` (hover cars, drones),
`Player.gd`, `UI.gd` (frames overlay, dialogue, phone), `Synth.gd` (sounds),
`Tex.gd` (textures).
