# fise/ TODO

Running list of known gaps and cleanup items in the scripts behind the FISE
book. Add to this as you go rather than fixing everything at once.

## Figure export has no consistent, safe convention

This is the big one. Right now there are at least three different patterns
for how a script produces a figure, and none of them are safe to run
casually:

- 12 scripts (the ones using `fiseBookPath`) write a PNG straight into
  `FISE-2025-Quarto/chapters/images/...` **unconditionally**, every time
  they run — including just running them to check they still work, or to
  regenerate their HTML tutorial page.
- `fise_opticsMTF.m` and `fise_humanConePSF.m` each define their own local,
  differently-named `figsave` boolean, hardcoded per script. `fise_opticsMTF.m`'s
  doesn't even go through `fiseBookPath` — it writes a bare relative-path PNG
  wherever MATLAB's current folder happens to be, not into the book at all.
- Most other figure-producing scripts have no flag whatsoever.

**Concrete incident:** republishing `fise_oiAperture.m`'s HTML tutorial page
(2025-08-26) silently re-executed the script and overwrote two already-committed
book figures (`pinhole-shape-rectangle.png`, `pinhole-shape-rectangle-img.png`),
changing them materially (153KB→100KB, 92KB→81KB) as an undisclosed side effect
of what looked like a harmless "regenerate the HTML" task.

**Fix needed:** one shared, named flag (e.g. a `fiseUpdateFigures` preference
or an explicit function argument every figure-exporting script checks),
defaulting to **off**, so:
- running or publishing a script never touches committed book assets by
  accident;
- there's one deliberate way to say "yes, regenerate all the book figures
  now" when that's actually the intent.

## Known bugs

- `fise_humanLSF.m` — `sceneCreate('lineee', imSize)`: `'lineee'` looks like
  a typo for `'line'`, and `imSize` is a scalar (512) where `sceneLine`
  expects a 2-vector (`sz(2)` fails). Currently publishes with the MATLAB
  error embedded in the HTML instead of the real figures.
- `fise_opticsMTF.m` has a permanently dead `%{ ... %}` block (lines ~54-77)
  calling an undefined `copy_contents_fallback` for a figure-tiling step.
  Either delete it or actually implement the tiling — a block of inert
  commented-out code isn't a real fix, just a deferred one.
- `fise_opticsCountingPhotons.m` logs a non-fatal publish warning about a
  missing equation-rendering PNG (`..._eq...png not found`). Cosmetic, not
  investigated.

## Movie embedding

`iePublish` only embeds a movie in the HTML if the script writes it with the
`% iePublishVideo: <filename>.mp4` marker comment (see isetcam's
`publishing-tutorials-examples` skill). `fise_harmonicsLine.m` wrote its
movie via plain `VideoWriter` with no marker, so it silently never appeared
in the published page — fixed 2025-08-26. Worth a one-time sweep of any
other movie-producing script for the same gap before adding new ones.

## Unresolved duplicate

`fise/03Sensor/fise_photonsElectrons.m` and `fise/03Sensor/s_photonsElectrons.m`
are near-duplicates (same Poisson photon/electron topic, similar length),
sitting side by side. Decide which is canonical and retire the other.

## Scripts not wired into the book yet

No chapter currently references these — either finish and link them in, or
move them to `deprecated/`:

- `02Optics/fise_aspherics.m`
- `02Optics/fise_thinLensCombination.m`
- `02Optics/fise_wavefronts.m`
- `03Sensor/fise_cameraLightField.m`
- `03Sensor/fise_sensorCFA.m`
- `04Human/fise_gaborMTF.m`

## Linking scope beyond isetfise

With the current organization, book chapters might end up linking directly
to isetcam's own `tutorials/`/`examples/` HTML (via the same
`htmlpreview.github.io` pattern used for isetfise), not only to scripts
under `fise/`. Worth keeping in mind when deciding what belongs in `fise/`
versus what a chapter can just point at directly in isetcam.

## Parked ideas (not now)

- Tracking each script's role (figure-export vs. HTML-link-target vs. both)
  in a manifest — real gaps exist (7 scripts do both jobs), but Brian wants
  to wait until there's less active churn in the scripts before adding a
  manifest that needs constant upkeep.
- Automated regression coverage (`ieExampleTest`-style smoke testing) so a
  future isetcam API change doesn't silently break a script until the next
  manual republish. Would require standard `t_*`/`s_*` naming to plug into
  isetcam's shared test engine — a bigger naming/organization decision,
  deliberately deferred.

## Stale cross-repo docs (from the psych221 → isetfise rename)

- isetcam's own `matlab-evaluation` skill still documents `psych221` and
  `psych221RootPath` and the old flat root-level script layout — needs
  updating for `isetfise`'s `class_tutorials/`/`fise/` structure.
- `isetfise/README.md` still says "Psych 221... homework scripts" with the
  old `github.com/iset/psych221.git` clone URL.
- `isetfise/class_tutorials/isetfiseRootPath.m` — the file was renamed but
  the function defined inside it is still literally named
  `psych221RootPath`.
