# isetfise AI Instructions

Use this file as shared startup guidance for Copilot, Claude, Codex, Gemini,
and other AI coding assistants working in this repository. It covers only
what is specific to isetfise. Task-specific workflows live as skills in
`.github/skills/`, each with its own trigger conditions — load the matching
skill when its topic applies rather than searching for detail here.

## Identity

This repository serves two purposes that share the same MATLAB/ISETCam
foundation:

1. Course material for Image Systems Engineering (Psych 221):
   `class_tutorials/`, `class_slides/`, `projects/`, `trainingdata/`.
2. `fise/` — the MATLAB scripts backing the "Foundations of Image Systems
   Engineering" (FISE) Quarto book, a sibling repository
   (`FISE-2025-Quarto`). See the `fise-book-integration` skill for how the
   two connect.

## Hard dependency: ISETCam must be on the MATLAB path

Nothing in this repository runs standalone. Every script here assumes
`ieInit` and the ISETCam object pipeline (scene/oi/sensor/ip/display) are
already available. Before running, evaluating, or reasoning about behavior
in this repository:

1. Read and follow **`isetcam/.github/copilot-instructions.md`** as the base
   guidance — it covers MATLAB conventions, the ISETCam repository layout,
   coding style, and test runners. This file only adds what is specific to
   isetfise on top of that; it does not repeat isetcam's guidance.
2. Confirm ISETCam is actually on the path (e.g. `which ieInit`) before
   assuming a script will run. If it is not, see isetcam's
   `matlab-environment-setup` skill.

## Skills

isetfise's own skills live in `.github/skills/<name>/SKILL.md`, discovered
by Claude Code via the `.claude/skills -> ../.github/skills` symlink in
*this* repository. That symlink only exposes isetfise's own skills
(currently just `fise-book-integration`) — it does not, by itself, expose
isetcam's skills.

For general MATLAB tutorial/example authoring, running, and `iePublish`
publishing mechanics, use isetcam's own skills rather than re-deriving that
guidance here:

- `authoring-tutorials-examples` — where a new script belongs, `t_*`/`s_*`/
  `data_*` naming, the `% SkipFile` marker.
- `publishing-tutorials-examples` — `iePublish`, inline image embedding,
  embedded movies.
- `matlab-evaluation` / `matlab-environment-setup` — locating MATLAB,
  path setup, running scripts non-interactively.
- `testing-workflow` / `test-runner-architecture` — smoke tests for
  tutorials and examples.

**These are only discoverable through the Skill tool if isetcam is also
open as a working directory in the current session** (its own
`.claude/skills -> ../.github/skills` symlink is what surfaces them, and
that only works from inside isetcam itself). If isetcam isn't part of the
session, read the skill directly instead of assuming it will surface on
its own: `isetcam/.github/skills/<name>/SKILL.md`.

For how `fise/` scripts relate to the FISE book — chapter mapping, the
figure-export path dependency, and how to link a published script into a
book chapter — see the local **`fise-book-integration`** skill.

## Repository layout

- `class_tutorials/`, `class_slides/` — Psych 221 course material, using
  the course's own `Topic_NN_Description.m` naming (distinct from `fise/`).
- `fise/` — scripts backing the FISE book, `fise_*` naming, organized by
  book-chapter-numbered subfolder (`01Lightfields/`, `02Optics/`, ...).
- `projects/`, `trainingdata/` — course project material and small data-prep
  scripts.
- `local/` — untracked, generated, or scratch output (gitignored).
