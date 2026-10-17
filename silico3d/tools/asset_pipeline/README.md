# Asset pipeline (free, CPU-only)

Turns free sources into PS1-budget GLB props for `assets/kit/`. Everything
runs headless on a 4-core CPU with no GPU and no paid service. Review the
result in game with `level=PropKit`.

Three routes, best first:

1. **CC0 scans (Poly Haven).** `ph_get.py <id>...` downloads the 1k glTF;
   `ph_clean.py` decimates to a triangle budget, flat-shades, shrinks textures
   to 256 px, rescales to the real size from Poly Haven's metadata and writes a
   GLB plus four turntable frames. Batch: see the list in this thread's
   `ph_batch.sh` pattern (`id tris` per line).
2. **Photo box (the PS1 trick).** For anything boxy (vending machines, ATMs,
   server racks, arcade cabinets, fuse panels): generate a *straight-on front
   elevation* image with `gen_ref.py`, then `photobox.py` builds a box of the
   real size with that image on the front face and a metal body on the rest.
   12 triangles, sharp, consistent with the street signage.
3. **Image to 3D (TripoSR).** `gen_ref.py` makes a reference, TripoSR (CPU,
   patched for scikit-image marching cubes and new transformers key names)
   makes a vertex-coloured mesh, `clean.py` repairs and decimates it. Blobby:
   use only for small or distant things (drones overhead). Thin parts (rotor
   blades, legs) break up.

Reference prompts: one object, plain light grey background, even light, no
text; append the style suffix in `gen_ref.py`. For photo boxes ask for a
"straight-on front orthographic view ... filling the frame, flat front
elevation, no perspective".

Tools used: SDXL-Turbo (Stability AI Community Licence, free under $1M yearly
revenue), TripoSR (MIT), Blender 4.2 (`blender -b -P script.py -- args`),
Godot 4.3 headless for the import check. Asset sources and licences are in
`assets/kit/LICENSE.txt`.

Paths in the scripts point at `./work/`; run them from a scratch folder.
