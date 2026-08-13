# dev-dots

Devcontainer voor dagelijks ontwikkelwerk — AI-first, reproduceerbaar, direct bruikbaar.

## Inhoud

- **Base**: Debian bookworm-slim, `amd64` + `arm64`
- **Shell**: bash, starship, zoxide, eza, fzf, bat, fd, ripgrep, jq
- **Editor**: Neovim + LazyVim
- **Git**: lazygit, gh, glab, delta
- **Data**: csvlens
- **AI**: claude, opencode, entire, org-skills via `cedanl/.github` — met `--dangerously-skip-permissions`
- **Python**: uv
- **Node**: LTS
- **Cloud**: az, azcopy, azd, aws, kubectl, helm, flux, sops
- **Media & automatisering**: ffmpeg, Playwright headless Chromium

## Snel starten

1. Open in VS Code → `Dev Containers: Reopen in Container`
2. Wacht op post-create
3. Voer `onboard` uit — begeleide authenticatie (gh, opencode, claude) + git-identiteit
4. Aan de slag met `nvim .` of `claude`

> Claude Code en OpenCode starten met `--dangerously-skip-permissions` (ingebakken als shell-alias).
> Git gebruikt per user een expliciete identiteit (ingesteld door `onboard`) en `user.useConfigOnly true`.

## Screenshots en GIFs automatiseren

De container bevat `ffmpeg` en de systeembibliotheken voor Playwright headless Chromium, zodat je zonder displayserver screenshots en animaties kunt genereren.

### Screenshots met Playwright (Python)

```python
from playwright.sync_api import sync_playwright

with sync_playwright() as p:
    browser = p.chromium.launch()
    page = browser.new_page()
    page.goto("https://example.com")
    page.screenshot(path="screenshot.png", full_page=True)
    browser.close()
```

Installeer de Playwright-bibliotheek en de Chromium-binary:

```bash
uv add playwright
playwright install chromium
```

> De vereiste systeembibliotheken zijn al ingebakken in het image — `playwright install-deps` is niet nodig.

### Meerdere pagina's naar PDF

```python
page.pdf(path="rapport.pdf", format="A4")
```

### Screenshots omzetten naar GIF met ffmpeg

```bash
# Reeks PNG-screenshots → geanimeerde GIF
ffmpeg -framerate 2 -pattern_type glob -i 'screenshot_*.png' \
       -vf "scale=1280:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" \
       demo.gif
```

### Schermopname van een webpagina als GIF (volledig voorbeeld)

```python
import subprocess
from pathlib import Path
from playwright.sync_api import sync_playwright

out = Path("frames")
out.mkdir(exist_ok=True)

with sync_playwright() as p:
    browser = p.chromium.launch()
    page = browser.new_page(viewport={"width": 1280, "height": 720})
    page.goto("https://example.com")

    for i in range(10):
        page.screenshot(path=out / f"frame_{i:03d}.png")
        page.evaluate("window.scrollBy(0, 200)")

    browser.close()

subprocess.run([
    "ffmpeg", "-y", "-framerate", "5",
    "-pattern_type", "glob", "-i", "frames/frame_*.png",
    "-vf", "scale=1280:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse",
    "demo.gif"
], check=True)
```

### Video opnemen met ffmpeg

```bash
# MP4 van een reeks frames
ffmpeg -framerate 24 -pattern_type glob -i 'frames/frame_*.png' \
       -c:v libx264 -pix_fmt yuv420p output.mp4
```

## Image

Gepubliceerd op `ghcr.io/cedanl/dev-dots:latest` — gebouwd voor `amd64` en `arm64`.

> Uitgebreide documentatie en sneltoetsen: zie de [projectdocumentatie](https://cedanl.github.io/dev-dots).
