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

Start een werksessie met tmux en open meteen je editor:

```bash
tmux
nvim .
```

Of gebruik een van de AI-layouts om direct met een assistent te werken:

```bash
tmux
tdl claude
```

Dat opent Neovim, een Claude Code-sessie en een vrije terminal — naast elkaar in één venster.

---

## Eerste keer opstarten

Voer `onboard` uit voor een begeleide setup van GitHub-authenticatie en AI-sleutels:

```bash
onboard
```

!!! tip "GitHub CLI"
    Voer `gh auth login` eenmalig uit zodat `gh`, `lazygit` en `gclone` toegang hebben tot je repositories.
