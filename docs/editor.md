# Editor — Neovim

De editor is Neovim met [LazyVim](https://www.lazyvim.org/) als startconfiguratie. LazyVim laadt plugins slim en geeft je meteen een volwaardige IDE-ervaring. Bij de eerste `nvim`-start worden plugins gedownload.

```bash
nvim .       # open de huidige map als project
nvim bestand.py
```

De **leader-toets** is `Spatiebalk`.

---

## Bestanden & navigatie

| Toets | Actie |
|---|---|
| `Space f f` | Zoek bestanden (fuzzy) |
| `Space f g` | Zoek in bestandsinhoud (live grep) |
| `Space f r` | Recente bestanden |
| `Space f b` | Open buffers |
| `Space e` | Bestandsverkenner (neo-tree) |

---

## Buffers & vensters

| Toets | Actie |
|---|---|
| `Space b d` | Sluit buffer |
| `Space b o` | Sluit alle andere buffers |
| `[b` / `]b` | Vorige / volgende buffer |
| `Ctrl+w s` | Splits venster horizontaal |
| `Ctrl+w v` | Splits venster verticaal |
| `Ctrl+h/j/k/l` | Navigeer tussen vensters |

---

## Code bewerken

| Toets | Actie |
|---|---|
| `g d` | Ga naar definitie |
| `g r` | Toon referenties |
| `g I` | Ga naar implementatie |
| `K` | Hover documentatie |
| `Space c r` | Hernoem symbool |
| `Space c a` | Code actions |
| `Space c f` | Formatteer bestand |
| `gcc` | Toggle comment (normale modus) |
| `gc` | Toggle comment (visuele selectie) |

---

## Diagnostics & fouten

| Toets | Actie |
|---|---|
| `]d` / `[d` | Volgende / vorige diagnostic |
| `Space x x` | Diagnostics-paneel |
| `Space x l` | Locatielijst |

---

## Git in de editor

| Toets | Actie |
|---|---|
| `Space g g` | Open lazygit in Neovim |
| `]h` / `[h` | Volgende / vorige git-hunk |
| `Space g h s` | Stage hunk |
| `Space g h r` | Reset hunk |
| `Space g h p` | Preview hunk |

---

## Pluginbeheer

| Toets | Actie |
|---|---|
| `Space l` | Open Lazy (plugin manager) |

Voer `:Lazy update` uit om alle plugins bij te werken.

!!! tip "LazyVim-extras"
    LazyVim heeft uitbreidingen voor talen als Python, TypeScript, Go en meer. Bekijk `lazyvim.json` in `~/.config/nvim/` voor wat er actief is, of voeg extras toe via `:LazyExtras`.
