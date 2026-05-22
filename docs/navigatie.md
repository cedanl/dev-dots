# Terminal & tmux

tmux is de spil van elke werksessie. Het is een persistent proces: ook als je het VS Code-venster sluit of de verbinding wegvalt, blijft je tmux-sessie actief op de achtergrond. Je koppelt gewoon opnieuw aan en je bent precies waar je was.

```bash
tmux
```

De **prefix-toets** is `Ctrl+b` — die typ je vóór elke tmux-opdracht.

---

## Sessies

Een sessie is een werkruimte. Je kunt er meerdere hebben, elk voor een ander project.

| Toets | Actie |
|---|---|
| `Ctrl+b d` | Sessie loskoppelen (blijft actief op de achtergrond) |
| `Ctrl+b $` | Sessie hernoemen |

```bash
tmux ls              # toon alle actieve sessies
tmux attach          # koppel terug aan de laatste sessie
tmux attach -t naam  # koppel aan een specifieke sessie
```

---

## Vensters

Vensters zijn tabbladen binnen een sessie.

| Toets | Actie |
|---|---|
| `Ctrl+b c` | Nieuw venster |
| `Ctrl+b ,` | Venster hernoemen |
| `Ctrl+b n` | Volgend venster |
| `Ctrl+b p` | Vorig venster |
| `Ctrl+b 1–9` | Ga naar venster op nummer |
| `Ctrl+b &` | Venster sluiten |

---

## Panelen

Panelen verdelen een venster in meerdere terminals naast of onder elkaar.

| Toets | Actie |
|---|---|
| `Ctrl+b %` | Splits verticaal (naast elkaar) |
| `Ctrl+b "` | Splits horizontaal (boven/onder) |
| `Ctrl+b ←↑→↓` | Navigeer tussen panelen |
| `Ctrl+b z` | Zoom huidig paneel (toggle) |
| `Ctrl+b x` | Paneel sluiten |
| `Ctrl+b {` / `}` | Wissel panelen van positie |

---

## Kopiëren & klembord

tmux gebruikt vi-stijl selectie in kopieermodus. Kopiëren werkt via **OSC 52**: de gekopieerde tekst gaat direct naar het klembord van je machine, via VS Code's geïntegreerde terminal — zonder X11 of Wayland.

| Toets | Actie |
|---|---|
| `Ctrl+b [` | Kopieermodus starten |
| `v` | Begin selectie |
| `Ctrl+v` | Rechthoekselectie |
| `y` | Kopieer en verlaat |
| `q` of `Escape` | Verlaat kopieermodus zonder te kopiëren |

!!! tip "Klembord in de devcontainer"
    In VS Code's geïntegreerde terminal kun je tekst selecteren en kopiëren met de muis, of plakken met `Ctrl+Shift+V`. In tmux copy-mode gebruik je `y` — dat gaat via OSC 52 naar je host-klembord. Gewoon `Ctrl+C` in een lopend proces stuurt een interrupt-signaal, geen kopie.

---

## AI-layouts

Dit zijn de krachtigste commando's in dev-dots. Ze bouwen in één keer een complete werkomgeving op.

### `tdl` — editor + AI + terminal

```bash
tdl claude       # Neovim + Claude Code + vrije terminal
tdl opencode     # Neovim + OpenCode + vrije terminal
tdl claude opencode  # Neovim + twee AI-assistenten
```

Het venster ziet er zo uit:

```
┌────────────────────┬──────────┐
│                    │          │
│      nvim .        │  claude  │
│                    │          │
├────────────────────┴──────────┤
│         vrije terminal        │
└───────────────────────────────┘
```

### `tdlm` — één layout per submap

```bash
tdlm claude
```

Voor elke submap van de huidige directory opent `tdlm` een apart tmux-venster met de volledige `tdl`-layout. Handig voor monorepo's of wanneer je meerdere services tegelijk wilt bijwerken.

### `tsl` — parallelle zwerm

```bash
tsl 4 claude     # start Claude Code in 4 panelen tegelijk
tsl 3 opencode
```

Alle panelen krijgen hetzelfde commando. Gebruik dit om meerdere taken tegelijkertijd te laten draaien.

!!! tip
    Al deze commando's vereisen een actieve tmux-sessie. Start `tmux` voordat je ze aanroept.
