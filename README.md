# dev-dots

Een devcontainer voor ontwikkelaars: snelle opstarttijd, sterke terminal-ergonomie, AI-gerichte workflows en reproduceerbare tooling.

Deze repository combineert dotfiles, container-setupscripts en werkruimteautomatisering zodat elk project kan opstarten in een consistente, overzichtelijke ontwikkelomgeving.

## Visie

`dev-dots` is een eigenzinnige, productieklare devcontainer gebouwd voor het volledige dagelijkse ontwikkelwerk — Python, data, content en meer — in één container:

- Reproduceerbare CLI-toolchain
- Uitstekende shell-ervaring direct uit de doos
- AI-ondersteunde tmux-layouts voor snelle codesessies
- Minimale installatie vereist op de hostmachine

## Wat je krijgt

### Containerbasis

Gedefinieerd in `.devcontainer/Dockerfile`:

- Debian bookworm-slim basisimage met multi-architectuur ondersteuning (`amd64` en `arm64`)
- Kerntools: `git`, `curl`, `tmux`, `htop`, `jq`, `wget`, `fd-find`, `bat`, `openssh-client`, `build-essential`
- Zoek- en datatools: `ripgrep`, `fzf`, `csvlens`
- Moderne shell-tools: `eza` (vervanging voor `ls`)
- Node.js LTS (voor npm en Node-gebaseerde tools)
- Nieuwste Neovim-installatie
- Niet-root `dev`-gebruiker met workspace-rechten
- CLI-installaties voor `opencode`, `claude`, `uv`, `starship` en `zoxide`
- Dotfiles voorgeladen: `.bashrc`, bash-helpers, starship-config, tmux-config en tmux-layoutscripts
- LazyVim-starterconfiguratie vooraf gekloond naar `~/.config/nvim` (plugins worden geladen bij eerste `nvim`-start)
- **Git-tooling**: `lazygit` (TUI git-client), `gh` (GitHub CLI), `delta` (syntaxgemarkeerde diffs)
- Systeem-level git-pager geconfigureerd met `delta` (gebruiker `~/.gitconfig` heeft voorrang)

### Post-create provisioning

Gedefinieerd in `.devcontainer/post-create.sh`:

- Verificatie van beschikbaarheid van CLIs (nvim, opencode, claude, uv, starship, zoxide, node, npm, csvlens)
- Samenvatting van git-tooling bij opstarten
- Nuttige tips bij opstarten

### Git-workflow direct beschikbaar

Hostcredentials worden via `devcontainer.json` bind mounts (readonly) doorgegeven aan de container:

- `~/.gitconfig` → `/home/dev/.gitconfig`
- `~/.ssh/` → `/home/dev/.ssh/`

Git-operaties (`git push`, `git pull`, SSH-klonen) werken in de container zonder extra configuratie.

Beschikbare git-tools:

| Tool | Commando | Toelichting |
|------|----------|-------------|
| lazygit | `lazygit` | Volledige TUI git-client; integreert met LazyVim |
| GitHub CLI | `gh` | Ingebouwd; voer `gh auth login` eenmalig uit voor authenticatie |
| delta | automatisch | Syntaxgemarkeerde diffs voor elke `git diff` / `git log -p` |

### Shell- en promptervaring

Vanuit `bash/` en `starship/`:

- Modulaire bash-config (`aliases`, `functions`, `rc`)
- Productiviteitshelpers (`fzf`-zoeken in geschiedenis, compressiehelpers, apt-helpers)
- `zoxide`-aangedreven directorynavigatie
- Starship-prompt met compacte git-bewuste status

### AI + tmux-workflows

De tmux-layouthelpers zijn ontworpen voor coderen met één of meerdere AI-assistenten tegelijkertijd:

- `tdl <ai> [second_ai]`: editor + AI-venster(s) + terminal
- `tdlm <ai> [second_ai]`: één ontwikkelvenster per submap
- `tsl <pane_count> <command>`: commando's parallel uitvoeren over meerdere vensters

Deze commando's komen uit `~/.tmux-dev-layouts.sh`, dat vooraf is geïnstalleerd in de image en automatisch wordt geladen door `.bashrc`.

## Mappenstructuur

```text
.
├── .devcontainer/
│   ├── Dockerfile
│   ├── devcontainer.json
│   ├── post-create.sh
│   ├── tmux.conf
│   └── tmux-dev-layouts.sh
├── bash/
│   ├── .bashrc
│   └── .config/bash/
│       ├── aliases
│       ├── functions
│       └── rc
├── starship/
│   └── .config/starship.toml
└── README.md
```

## Snel starten

1. Open deze repository in VS Code.
2. Voer `Dev Containers: Reopen in Container` uit.
3. Wacht tot de post-create setup klaar is.
4. Begin met werken via `nvim .`, `tmux` of je eigen workflow.
5. *(Optioneel)* Voer `gh auth login` eenmalig uit om `gh` te activeren met je GitHub-account.

## Doelstelling

`dev-dots` blijft één goed onderhouden multipurpose container die actueel blijft met toolingupdates en eenvoudig uitbreidbaar is voor elk projecttype. De focus ligt op diepgang en kwaliteit, niet op een breed aanbod van profielen:

- Shell- en editordefaults blijven overdraagbaar en eenvoudig overschrijfbaar
- Elke sessie is standaard AI-samenwerkingsvriendelijk
- Reproduceerbaarheid met minimale handmatige machinesetup

## Slidev

Om een presentatie vanuit de container te geven:

```bash
npm run dev -- --remote
```

Dit stelt de Slidev dev-server beschikbaar buiten de container. Poort `3030` wordt standaard doorgestuurd via `devcontainer.json`.
