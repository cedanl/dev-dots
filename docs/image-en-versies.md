---
icon: lucide/package
---

# Image, versies en supply chain

## Image

Het image staat op `ghcr.io/cedanl/dev-dots:latest` en is gebouwd voor `amd64` en `arm64`.

`devcontainer.json` pint op `major.minor` (de huidige pin staat in de tabel onder [Toolversies](#toolversies)). Dat geldt ook voor `.devcontainer/firewall/devcontainer.json`. Zo krijgt iedereen dezelfde versie. Een release (`vX.Y.Z`) levert de tags `X.Y.Z` en `X.Y`. Verhoog na een nieuwe release de pin in beide `devcontainer.json`-bestanden.

### Controleer je versie

- De pin staat in `.devcontainer/devcontainer.json` (`"image": "ghcr.io/cedanl/dev-dots:…"`) en bovenaan de tabel onder [Toolversies](#toolversies).
- De post-create stap schrijft de versies van alle geïnstalleerde tools naar `tool-versions.txt` (staat in `.gitignore`).
- Een losse tool controleer je met zijn eigen vlag, bijvoorbeeld `nvim --version`.

## Toolversies

Toolversies staan als `ARG` bovenaan de `Dockerfile`. Staat er een `# renovate: datasource=… depName=…`-regel boven, dan houdt Renovate ze bij (zodra de Renovate GitHub App op de repo staat). Voeg je een tool toe, kopieer dan de regel van een buur.

<!-- gen:versies:begin -->

Gepind image in `devcontainer.json`: `ghcr.io/cedanl/dev-dots:1.3`.

| Tool | Versie | Bron |
|---|---|---|
| lazygit | 0.60.0 | `jesseduffield/lazygit` |
| delta | 0.18.0 | `dandavison/delta` |
| ripgrep | 15.1.0 | `BurntSushi/ripgrep` |
| csvlens | 0.15.1 | `YS-L/csvlens` |
| neovim | 0.11.6 | `neovim/neovim` |
| starship | 1.24.2 | `starship/starship` |
| uv | 0.11.1 | `astral-sh/uv` |
| zoxide | 0.9.9 | `ajeetdsouza/zoxide` |
| micromamba | 2.8.1-0 | `mamba-org/micromamba-releases` |
| azcopy | 10.26.0 | `Azure/azure-storage-azcopy` |
| azd | 1.9.5 | `Azure/azure-dev` |
| glab | 1.58.0 | `gitlab-org/cli` |
| entire | 0.13.4 | `entireio/cli` |
| sops | 3.10.2 | `getsops/sops` |
| flux | 2.4.0 | `fluxcd/flux2` |
| kubectl | 1.31.14 | `kubernetes/kubernetes` |
| helm | 3.16.0 | `helm/helm` |
| node | 24.22.2 | `node` |

Deze tabel wordt gegenereerd door `scripts/gen_docs.py` uit de `ARG`'s in de Dockerfile.

<!-- gen:versies:end -->

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
