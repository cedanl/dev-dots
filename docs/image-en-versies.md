---
icon: lucide/package
---

# Image, versies en supply chain

## Image

Het image staat op `ghcr.io/cedanl/dev-dots:latest` en is gebouwd voor `amd64` en `arm64`.

`devcontainer.json` pint op `major.minor`, nu `:1.3`. Dat geldt ook voor `.devcontainer/firewall/devcontainer.json`. Zo krijgt iedereen dezelfde versie. Een release (`vX.Y.Z`) levert de tags `X.Y.Z` en `X.Y`. Verhoog na een nieuwe release de pin in beide `devcontainer.json`-bestanden.

### Controleer je versie

- De pin staat in `.devcontainer/devcontainer.json` (`"image": "ghcr.io/cedanl/dev-dots:…"`).
- De post-create stap schrijft de versies van alle geïnstalleerde tools naar `tool-versions.txt` (staat in `.gitignore`).
- Een losse tool controleer je met zijn eigen vlag, bijvoorbeeld `nvim --version`.

## Toolversies

Toolversies staan als `ARG` bovenaan de `Dockerfile`. Staat er een `# renovate: datasource=… depName=…`-regel boven, dan houdt Renovate ze bij (zodra de Renovate GitHub App op de repo staat). Voeg je een tool toe, kopieer dan de regel van een buur.

## Supply chain: wat is gepind en geverifieerd

- **Gepind en geverifieerd (sha256 tegen het checksum-bestand van de release):** Node.js, lazygit, ripgrep, csvlens, micromamba, kubectl, helm, sops, glab, flux en starship (`.devcontainer/verify.sh`). Een ontbrekende of foute hash laat de build falen. Dit vangt corrupte of verwisselde bestanden, geen gecompromitteerde release zelf.
- **Gepind, zonder checksum van de uitgever:** delta, azcopy, azd, zoxide, neovim en uv (het uv-installatiescript controleert zelf).
- **Gepind via het installatiescript:** Entire (`--version`, `ENTIRE_VERSION` in de Dockerfile; Renovate houdt het bij).
- **Niet pinbaar (`curl | bash`):** de installers van Claude Code en OpenCode, en het AWS CLI ("latest"). Ze worden bewust ongepind geïnstalleerd. Een rebuild haalt de dan actuele versie.
- **Skills:** de `skills`-CLI is gepind (`install-skills.sh`). De inhoud volgt `cedanl/.github` HEAD, omdat die repo geen tags heeft en `post-attach` bewust ververst.
- De apt-repo's van gh, azure-cli en eza zijn ondertekend. De sleutels worden bij de build opgehaald.

Meer over de maatregelen tegen misbruik staat bij [Beveiliging](beveiliging.md).

## Gedeelde basisinstructies

`global_claude.md` is de gedeelde baseline. Zie [AI-workflows](ai.md#gedeelde-basisinstructies-global_claudemd) voor waar die terechtkomt.
