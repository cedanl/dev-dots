# Shell

De shell is Bash met een laag productiviteitstools. Alles is geladen via `~/.bashrc` en de bestanden in `~/.config/bash/`.

---

## Navigatie

### zoxide — slimme cd

`cd` is vervangen door zoxide. Het onthoudt mappen die je eerder hebt bezocht en springt er snel naartoe.

```bash
cd project       # ga naar de map als die bestaat, anders zoekt zoxide
cd               # ga naar home
```

Na een paar sessies kun je typen:

```bash
cd dots          # springt naar ~/projects/dev-dots als dat de beste match is
```

### Directory-shortcuts

```bash
..               # cd ..
...              # cd ../..
....             # cd ../../..
```

---

## Bestandsbeheer

### ls met eza

```bash
ls               # mooie lijst met iconen
lsa              # inclusief verborgen bestanden
lt               # boomstructuur (2 niveaus)
lta              # boomstructuur inclusief verborgen
```

### Bestanden bekijken

```bash
bat bestand.py   # syntaxgemarkeerde bestandsweergave
```

---

## Zoeken

### fzf — fuzzy finder

```bash
ff               # zoek een bestand met preview (bat)
```

**In de shell-geschiedenis:** druk op `Ctrl+r` voor een fuzzy zoekbalk door alle eerdere commando's. Selecteer met `Enter` om het commando terug te laden.

### ripgrep

```bash
rg patroon           # zoek recursief in de huidige map
rg patroon src/      # zoek in een specifieke map
rg -t py patroon     # zoek alleen in Python-bestanden
```

---

## Archivering

```bash
compress map/        # maakt map.tar.gz
decompress bestand.tar.gz
```

---

## Pakketten

Zoek en installeer apt-pakketten via een fuzzy picker:

```bash
apt-fzf              # bladeren en installeren
apt-fzf-purge        # bladeren en verwijderen
```

Geïnstalleerde pakketten worden gemarkeerd met een `*`.

---

## Prompt — starship

De prompt toont de huidige map en git-status compact:

```
~/project/src main ↑1 ✎ ➜
```

| Symbool | Betekenis |
|---|---|
| `↑n` | n commits vóór op remote |
| `↓n` | n commits achter op remote |
| `✎` | Gewijzigde bestanden |
| `◌` | Untracked bestanden |
| `⦿` | Gestagede wijzigingen |
| `✖` | Verwijderde bestanden |
| `✓` | Alles up-to-date |
