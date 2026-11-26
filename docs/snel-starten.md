---
icon: lucide/rocket
---

# Voor wie en snel starten

## Voor wie is dev-dots?

dev-dots is de standaard devcontainer van CEDA. De [werkafspraak Devcontainer](https://cedanl.github.io/.github/werkafspraken/devcontainer/) noemt hem de default voor wie bij CEDA ontwikkelt. Je krijgt dezelfde tools en versies als je collega's, inclusief de AI-assistenten en de org-skills uit `cedanl/.github`.

Het is gemaakt voor ontwikkelaars die dagelijks in de terminal werken. Ben je nieuw met agentic coding? Dan kan de hoeveelheid tools overweldigend zijn. Je hebt maar een handvol commando's nodig om te beginnen: `onboard`, `nvim .` en `claude`.

## Wat heb je nodig?

- Een editor of omgeving die devcontainers aankan. De werkafspraak noemt VS Code, Positron, de terminal en GitHub Codespaces.
- Een containerruntime op je machine: Docker, of Podman als je geen Docker Desktop wilt of mag draaien.
- Een GitHub-account. `onboard` logt je daarmee in.
- Een processor met `amd64` of `arm64`: het image bestaat voor beide.

## Stap voor stap

1. Open de repository in VS Code en kies **Dev Containers: Reopen in Container**. Kies je de variant met egress-firewall? Zie [Egress-firewall](firewall.md).
2. Wacht tot de post-create stap klaar is. Die meldt welke tools beschikbaar zijn en schrijft een lijst met versies naar `tool-versions.txt`.
3. Voer `onboard` uit. Dit zet GitHub, OpenCode en Claude klaar en stelt je git-identiteit in. Zie [AI-workflows](ai.md#eerste-keer-instellen).
4. Start je werk met `nvim .` of `claude`.

Loopt er iets mis? Kijk bij [Problemen oplossen](problemen-oplossen.md).

## Zonder devcontainer-extensie

Met de CLI van devcontainers kan het ook:

```bash
devcontainer up --workspace-folder .
devcontainer exec --workspace-folder . bash
```
