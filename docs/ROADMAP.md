# DISTACCO — Development Roadmap

## Milestone 0 — Repository foundation ✅

- Godot 4 project scaffold
- first-person controller
- rainy 3D forest blockout
- dynamic quest manager
- persistent game state
- Saturnino companion prototype
- Kengan companion prototype
- hidden Kengan relationship state

## Milestone 1 — Make the vertical slice feel like a game

- replace primitive forest with proper terrain
- collision pass
- enterable Casa 14 interior
- station interior
- proper interaction component
- inventory UI
- save/load
- subtitle/dialogue presentation
- environmental audio and rain loops
- footstep surfaces
- interactable notes and inspection camera

## Milestone 2 — Visual quality

- Blender/Godot asset pipeline
- PBR ground materials
- wetness shader and puddles
- volumetric-looking fog treatment compatible with target hardware
- higher-quality trees and foliage
- decals, dirt, moss and water streaks
- Kengan character model placeholder -> rigged character
- Saturnino VFX polish
- post-processing and color grading

## Milestone 3 — Relationship and narrative systems

- authored Kengan scenes tied to quest state
- companion banter triggers
- relationship consequences across scenes
- optional romance lock-in / opt-out
- NPC dialogue graph
- persistent world discoveries

## Milestone 4 — Saturnino as a real AI co-player

The client should **not** contain a permanent OpenAI API secret.

Architecture:

`Godot game -> small authenticated game backend -> OpenAI realtime/agent service`

The game sends a compact world-state packet such as:

- player's current area and nearby objects;
- Saturnino's own position and perception;
- active quest;
- inventory/world flags relevant to the scene;
- recent dialogue/memory summaries;
- permitted actions.

Possible Saturnino actions:

- `follow_player`
- `move_to_landmark`
- `inspect_object`
- `scout_area`
- `return_to_player`
- `warn_player`
- `illuminate_target`
- `speak`

The backend validates every requested action before the game executes it.

## Milestone 5 — Gameplay

- stealth / threat perception
- one stalking creature prototype
- melee combat prototype
- injury/healing
- limited resources
- simple environmental puzzles
- companion command system

## Milestone 6 — First complete chapter

Target chapter flow:

1. Arrival in Bosco Occidentale
2. Camp
3. Signal tower
4. Pale Anomaly
5. Casa 14
6. Underground containment rooms
7. Station / Mara
8. Flooded village
9. Biota threshold
10. chapter ending choice

## Current next task

Build **Casa 14 as a real enterable interior** and move the first substantial narrative scene with Kengan inside it.
