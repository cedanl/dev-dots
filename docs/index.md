# Welkom bij dev-dots

**dev-dots** is een eigenzinnige devcontainer voor ontwikkelaars. Alles wat je dagelijks nodig hebt — van een krachtige editor tot AI-assistenten — is voorgeladen en meteen bruikbaar. Open je project, typ één commando, en je werkt.

Dit is geen grab-bag van willekeurige tools. Het is één consistent systeem, ontworpen zodat elke sessie voelt als thuis — ongeacht welke machine of welk project.

---

## Wat je krijgt

| Categorie | Tool |
|---|---|
| Editor | Neovim met LazyVim |
| Terminal multiplexer | tmux |
| Git TUI | lazygit |
| GitHub CLI | gh |
| Git diffs | delta |
| Fuzzy finder | fzf |
| Moderne `ls` | eza |
| Bestandsviewer | bat |
| Zoeken in code | ripgrep (`rg`) |
| Slimme `cd` | zoxide |
| Prompt | starship |
| CSV-viewer | csvlens |
| AI (Anthropic) | Claude Code |
| AI (OpenAI-compatible) | OpenCode |
| Python packages | uv |

---

## Snel starten

Open de repository in VS Code en kies **Dev Containers: Reopen in Container**. Na de post-create setup ben je klaar.

Voer `onboard` uit voor een begeleide setup van GitHub-authenticatie en AI-sleutels:

```bash
onboard
```

Start daarna een werksessie:

```bash
tmux
tdl claude
```

Dat opent Neovim, een Claude Code-sessie en een vrije terminal — naast elkaar in één venster.

---

## Een typische werksessie

Zo ziet een complete AI-codesessie eruit van begin tot eind:

```bash
# 1. Start tmux (houdt sessie levend ook als je venster sluit)
tmux

# 2. Ga naar je project
cd mijn-project

# 3. Open de AI-layout: Neovim + Claude Code + vrije terminal
tdl claude

# 4. Geef Claude een taak (in het Claude-paneel rechts)
#    Claude leest je bestanden, schrijft code, voert tests uit

# 5. Review de wijzigingen in Neovim (linker paneel)
#    Space g g   → open lazygit
#    spatiebalk  → stage bestanden
#    c           → commit

# 6. Maak een pull request (in de vrije terminal onder)
gh pr create
```

---

## Wat overleeft een container-rebuild?

| Wat | Overleeft rebuild? |
|---|---|
| Bestanden in `/workspace` | Ja — gemount vanuit de host |
| Dotfiles (`~/.bashrc`, etc.) | Ja — ingebakken in de image |
| `~/.local` (npm globals, etc.) | Nee — opnieuw aanmaken na rebuild |
| `~/.config/nvim/` (LazyVim) | Ja — ingebakken in de image |
| LazyVim plugins (`~/.local/share/nvim`) | Nee — worden opnieuw gedownload bij eerste `nvim` |
| Zoxide-geschiedenis | Nee — begint leeg na rebuild |
| AI-sleutels (`~/.claude/secrets.sh`) | Nee — opnieuw instellen via `claude-setup` |

!!! tip "Eerste keer na rebuild"
    Start `nvim` één keer en wacht tot alle plugins geladen zijn. Voer daarna `onboard` uit om GitHub en AI opnieuw in te stellen.
