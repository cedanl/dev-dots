---
icon: lucide/life-buoy
---

# Problemen oplossen

## Veelvoorkomende problemen

| Symptoom | Oorzaak | Oplossing |
|---|---|---|
| `onboard` meldt "Wizard script not found" | Het script `~/.onboard.sh` ontbreekt. Het zit in het image. | Controleer dat je het juiste, actuele image draait (pin in `devcontainer.json`) en bouw de container opnieuw. |
| Neovim-plugins laden niet na een rebuild | `~/.local/share/nvim` is na een rebuild leeg. | Start `nvim` één keer en wacht tot LazyVim klaar is. |
| Git-identiteit ontbreekt na een rebuild | `user.name` en `user.email` overleven een rebuild niet. | Draai `onboard` opnieuw. Commits zonder identiteit falen bewust (`user.useConfigOnly true`). |
| `gh auth` is verlopen | Token verlopen, of het volume `devdots-gh` is leeg. | Draai `gh auth login` of `onboard` opnieuw. |
| Het inlogscherm van `claude` opent niet | De shell-functie `claude` zet `--dangerously-skip-permissions` vóór het subcommando. | Gebruik `command claude auth login`. |
| `fd` werkt niet | Op Debian heet het commando `fdfind`. | Gebruik `fdfind`. |
| Het post-create script meldt `[MISSING]` bij een tool | De tool is niet geïnstalleerd in dit image. | Controleer de pin en bouw opnieuw. Blijft het zo, meld een issue. |
| Een domein is geblokkeerd (firewall-variant) | Het staat niet in de allowlist. | Zie [Egress-firewall](firewall.md#een-geblokkeerde-verbinding-onderzoeken). |

Wat een rebuild wel en niet overleeft, staat in [Welkom](index.md#wat-overleeft-een-container-rebuild).

## Veelgestelde vragen

**Waarom starten Claude Code en OpenCode met `--dangerously-skip-permissions`?**
De container is de sandbox: binnen de container is dit de bedoelde workflow. Zet de vlag buiten de container niet aan. Lees ook [Beveiliging](beveiliging.md).

**Hoe zet ik Entire uit?**
Per repo met `git config devdots.entire false`, of voor alle repo's met `export DEVDOTS_ENTIRE=0`. Zie [AI-workflows](ai.md#entire-ai-sessies-vastleggen).

**Welke versie van het image draai ik?**
Zie [Controleer je versie](image-en-versies.md#controleer-je-versie).

**Er mist een tool of er zit iets in de weg. Mag ik de container lokaal aanpassen?**
Liever niet: dan loopt jouw omgeving uit de pas met die van je collega's. Open een issue of pull request op [cedanl/dev-dots](https://github.com/cedanl/dev-dots/issues).

**Kan ik zonder Docker Desktop werken?**
Ja. De werkafspraak Devcontainer noemt Podman als alternatief.
