# DISTACCO

A third-person/first-person narrative survival game prototype set in 2065, thirty-two years after the Distacco.

This repository now contains the beginning of the **real Godot 4 project**, not the earlier browser mock-up.

## Current playable vertical slice

The first build is a first-person rainy forest prototype containing:

- a larger explorable 3D woodland;
- dynamic objectives with distance/direction guidance;
- an abandoned camp, signal tower, stream/bridge, Casa 14, Direttorato checkpoint, blue-flower field and Pale Anomaly;
- flashlight and environmental fog/rain;
- Saturnino as a floating companion who follows the player and reacts to world state;
- Kengan as a physical companion who follows the player;
- a persistent Kengan relationship system with trust, romantic tension and romance progression;
- optional exploration interactions;
- persistent inventory/flags and a quest manager.

## Run it

1. Install **Godot 4.x**.
2. Clone/download this repository.
3. Open `project.godot` in Godot.
4. Press **F6/F5** to run.

### Controls

- `WASD` — move
- Mouse — look
- `E` — interact
- `F` — flashlight
- `T` — talk to Saturnino
- `R` — talk to Kengan / relationship choices
- `Esc` — release/capture mouse

## Design direction

DISTACCO should feel lonely, wet, grounded and uncanny rather than like a conventional monster shooter. The Biota should often be beautiful before it becomes threatening. Exploration and relationships should carry as much weight as combat.

Kengan's romance is optional and slow-burn. It is driven by accumulated trust and tension rather than a visible love meter or instant flirting.

Saturnino is currently implemented as a local companion system. A later milestone will connect the companion brain to an AI service through a safe game backend so that conversation and decisions can be genuinely dynamic instead of pre-written.

See `docs/GAME_DESIGN.md` and `docs/ROADMAP.md` for the working plan.
