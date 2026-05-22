# Extra tools

---

## csvlens — CSV-viewer

Bekijk en verken CSV-bestanden interactief in de terminal.

```bash
csvlens bestand.csv      # open een specifiek bestand
csvlens                  # kies een CSV-bestand via fuzzy-picker
```

Navigeer met de pijltjestoetsen. Zoek met `/`. Sluit af met `q`.

---

## uv — Python-pakketbeheer

`uv` is een snelle Python package en project manager.

```bash
uv init                  # nieuw Python-project
uv add requests          # voeg een pakket toe
uv run script.py         # voer een script uit in de projectomgeving
uv sync                  # installeer alle dependencies
uv pip install pakket    # pip-compatible installatie
```

---

## Node & npm

Node.js LTS is voorgeïnstalleerd voor npm-gebaseerde tools.

```bash
node --version
npm install
npm run dev
```

---

## onefetch & tokei

`onefetch` toont een compacte repo-samenvatting met statistieken, `tokei` telt regels per programmeertaal.

```bash
onefetch     # overzicht van de huidige git-repo
tokei        # taalstatistieken
```

`gclone` roept deze tools automatisch aan na het klonen van een repo.

---

## fd — snelle bestandszoeker

`fd` is een gebruiksvriendelijk alternatief voor `find`.

```bash
fd patroon               # zoek bestanden op naam
fd -e py                 # zoek op extensie
fd -t d                  # zoek alleen mappen
```

`fzf` en `csvlens` gebruiken `fd` intern voor snelle bestandssuggesties.

---

## jq — JSON-verwerking

```bash
cat data.json | jq '.items[]'
curl -s api/endpoint | jq '.data.name'
```

---

## Media-conversie

Beschikbaar als shell-functies voor snel mediawerk.

```bash
transcode-video-1080p video.mp4      # hercoderen naar 1080p H.264
transcode-video-4K video.mp4         # hercoderen naar 4K H.265
img2jpg foto.png                     # converteren naar JPG
img2jpg-small foto.png               # converteren + schalen naar max 1080px breed
img2png foto.jpg                     # converteren naar geoptimaliseerde PNG
```

---

## Schijfhulpmiddelen

```bash
iso2sd image.iso /dev/sda            # schrijf ISO naar SD-kaart
format-drive /dev/sda "Naam"         # formatteer schijf als exFAT
```

!!! warning
    `iso2sd` en `format-drive` wissen alle data op het opgegeven apparaat. Controleer altijd het device-pad eerst met `lsblk`.
