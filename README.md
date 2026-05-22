# dev-dots

Devcontainer voor dagelijks ontwikkelwerk — AI-first, reproduceerbaar, direct bruikbaar.

## Inhoud

- **Base**: Debian bookworm-slim, `amd64` + `arm64`
- **Shell**: bash, starship, zoxide, eza, fzf, bat, fd, ripgrep, jq
- **Editor**: Neovim + LazyVim
- **Git**: lazygit, gh, delta
- **Data**: csvlens
- **AI**: claude, opencode, org-skills via `cedanl/.github`
- **Python**: uv
- **Node**: LTS

## Snel starten

1. Open in VS Code → `Dev Containers: Reopen in Container`
2. Wacht op post-create
3. Voer `gh auth login` eenmalig uit
4. Aan de slag met `nvim .` of `tdl claude`

## tmux-layouts

```
tdl <ai> [tweede_ai]   # editor + AI-venster(s) + terminal
tdlm <ai> [tweede_ai]  # één venster per submap
tsl <n> <commando>     # commando parallel over n vensters
```

## Image

Gepubliceerd op `ghcr.io/cedanl/dev-dots:latest` — gebouwd voor `amd64` en `arm64`.

> Uitgebreide documentatie en sneltoetsen: zie de [projectdocumentatie](https://cedanl.github.io/dev-dots).
