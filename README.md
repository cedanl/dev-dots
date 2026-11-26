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

> Claude Code en OpenCode starten met `--dangerously-skip-permissions` (ingebakken: `claude` is een shell-functie, `opencode` een alias).
> Git gebruikt per user een expliciete identiteit (ingesteld door `onboard`) en `user.useConfigOnly true`.

## Documentatie

Alles over gebruik, sneltoetsen, automatisering, de egress-firewall, versies en supply chain staat op de site: <https://cedanl.github.io/dev-dots/>.

| Onderwerp | Pagina |
|---|---|
| Voor wie, wat je nodig hebt | [Voor wie en snel starten](https://cedanl.github.io/dev-dots/snel-starten/) |
| Screenshots, GIF's en video met Playwright en ffmpeg | [Automatisering](https://cedanl.github.io/dev-dots/automatisering/) |
| Image, tags, pin-beleid, toolversies, supply chain | [Image, versies en supply chain](https://cedanl.github.io/dev-dots/image-en-versies/) |
| Egress-firewall | [Egress-firewall](https://cedanl.github.io/dev-dots/firewall/) |
| Het doet iets niet | [Problemen oplossen](https://cedanl.github.io/dev-dots/problemen-oplossen/) |
