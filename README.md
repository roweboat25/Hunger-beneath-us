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

- Scene 1, the Dufredy apartment (Chapter 1 of the book): examine the debris, the eyes, the sticks, the ceiling eye, then open the laptop and talk to Psyon before bagging it as evidence.
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
