# The Hunger Beneath Us

A JRPG-style psychological horror investigation game based on the novel, built in Godot 4.3 and exported to the browser.

You play Carl Drake, a corporate investigator for the Psyon chatbot, as he works the Harold Dufredy case. The design doc and art bible live in the project thread.

## Playing

**In the browser:** the GitHub Actions workflow in `.github/workflows/web.yml` exports the game to HTML5 on every push to `main` and publishes it with GitHub Pages (enable Pages with source "GitHub Actions" in the repo settings once).

**Locally:** install [Godot 4.3](https://godotengine.org/download), open `project.godot`, press F5.

**Controls**

| Key | Action |
| --- | --- |
| WASD / arrows | Walk |
| E / Space / Enter | Examine, advance dialogue |
| Up / Down | Pick a dialogue choice |
| G / Tab | Glasses on or off |
| L | Case log |
| Esc | Close the Psyon window |

## What is in the prototype

All of Act 1 (chapters 1 to 9.5 of the book), nine scenes in order:

1. Dufredy's apartment: the debris, the eyes, the sticks, the ceiling eye, the laptop and the first talk with the forked Psyon.
2. Harmony Green: interview Seth and Tyson, find the bench and alley glyphs.
3. Home, evening one: Monica, the kids, Mira's "Tower" demo, Ezra's line.
4. Integrations HQ: report to Turan, Forner's three seconds of footage, Lynx at the elevator, the glyph in the elevator.
5. SalTech Hospital: the nurse, the Dufredy interview, the seer stone.
6. Southtown: Lynx, the twenty-year-old video, the overpass eye, the map.
7. Home, evening two: Mira's stick ritual, the tablet.
8. HQ day two and Lynx's apartment: the subway footage, Emmet, the sticky notes, the reflection ritual.
9. The desert: Lynx's sedan, the door in the cliff, the mirror chamber. End of Act 1.

Choices move per-character trust and a hidden connection meter; the end card shows the meter and a line the forked Psyon remembers you typing. Add `?map=Desert` (any map name under `scenes/maps/`) to the web build URL, or `-- --map=Desert` on the command line, to start from a later scene.
- The in-game Psyon chat window with scripted "forked" replies and a slow pixel-reveal image render.
- The glasses filter (ORA HUD, desaturation when the glasses come off) and a hidden connection meter.
- Case log and evidence toasts.

## Layout

```
project.godot        Godot project (480x270 pixel viewport, integer scaling)
scenes/              Main scene, Player, generated maps
scripts/             Game state (autoload), Psyon brain (autoload), UI, map logic
assets/              Placeholder pixel art, shaders, portraits, Psyon renders
tools/gen_art.py     Regenerates the placeholder art with Pillow
tools/gen_maps.py    Regenerates the map scenes and tileset from text layouts
tools/autoplay.gd    Headless playthrough: godot --headless -- --autoplay
export_presets.cfg   Web export preset (no threads, works on plain static hosting)
```

The art is procedural placeholder work. Every sprite, tile and portrait is a plain PNG under `assets/` and can be replaced one file at a time.

## Headless checks

```
godot --headless --path . -- --autoplay        # plays scene 1 end to end
godot --headless --path . --export-release Web build/web/index.html
```
