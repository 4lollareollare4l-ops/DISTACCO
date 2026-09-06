# DISTACCO — Working Game Design

## Core fantasy

The player crosses a post-Distacco region where abandoned human infrastructure and the Biota Emergente overlap. The world should feel inhabited by consequences rather than packed with content.

The central experience is:

1. travel through hostile but believable spaces;
2. notice environmental details;
3. make choices with incomplete information;
4. build or damage relationships;
5. discover what the Distacco actually changed.

## Tone

- wet, cold, grounded;
- long silences interrupted by specific human dialogue;
- beauty and threat coexist;
- no constant jumpscares;
- horror should often begin as uncertainty;
- avoid generic post-apocalyptic debris spam.

## Player

The current prototype uses first person for speed of development. Final camera can remain first person or move to close third person after animation tests.

Core verbs planned:

- walk / run / crouch;
- inspect;
- use flashlight;
- collect / combine simple tools;
- speak to companions and NPCs;
- hide / evade;
- later: melee combat, limited firearms, environmental traversal.

## Saturnino

Saturnino is a small floating companion represented visually as a pale sphere with a ring.

Long-term goal: Saturnino is not a dialogue dispenser. It should have:

- its own perception radius;
- partial information different from the player's;
- memory of visited places and past decisions;
- callable actions such as follow, scout, inspect, return, warn, illuminate;
- dynamic conversation through an AI-backed companion service;
- ability to disagree with the player without blocking play.

## Kengan

Kengan is a normal physical companion, not an AI mascot. His romance route is optional.

Relationship state tracks three hidden values:

- **Trust** — whether he believes the player will act with him rather than around him;
- **Tension** — emotional/romantic charge, including conflict;
- **Romance** — willingness to act on the attraction.

The player never sees numeric meters. Dialogue and behavior communicate the state.

Stages currently implemented:

- guarded;
- close;
- charged;
- mutual;
- committed.

Romance should not overwrite Kengan's priorities or personality. He can disagree, leave a conversation, refuse a reckless request, or protect someone else without it being treated as a romance failure.

## First region: Bosco Occidentale

Current prototype landmarks:

- old road;
- abandoned camp;
- signal tower;
- stream and improvised bridge;
- Casa 14;
- Direttorato checkpoint;
- Pale Anomaly;
- blue-flower field.

Future additions:

- flooded village;
- closed rail station;
- Fanidian ruins;
- Biota growth zone;
- underground containment rooms beneath Casa 14.

## Quest philosophy

Objectives must tell the player what to do and where to go without turning the world into a checklist.

The HUD may show:

- current objective sentence;
- approximate distance;
- directional arrow;
- current region name.

Exploration discoveries remain optional unless the story gives them a concrete reason to matter.

## Narrative systems

Persistent state is divided into:

- inventory;
- world flags;
- quest state;
- relationships;
- later: faction reputation and companion memory.

Choices should change later scenes whenever possible rather than merely changing one immediate reply.
