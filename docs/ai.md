# AI-workflows

dev-dots is gebouwd rond AI-ondersteund ontwikkelen. Twee CLI-assistenten staan klaar: **Claude Code** (Anthropic) en **OpenCode** (OpenAI-compatible). De tmux-layouts zijn ontworpen om ze naadloos naast je editor te laten draaien.

---

## Eerste keer instellen

Voer `onboard` uit voor een begeleide setup:

```bash
onboard
```

Of stel Claude Code handmatig in:

```bash
claude-setup     # opent ~/.claude/secrets.sh in Neovim
```

Vul hier je `ANTHROPIC_FOUNDRY_API_KEY` en `ANTHROPIC_FOUNDRY_RESOURCE` in. De secrets worden automatisch geladen bij elke sessie.

---

## Claude Code

```bash
claude           # start Claude Code in de huidige map
```

Claude Code werkt als een autonome agent die bestanden leest, aanpast en commando's uitvoert. Geef een taak in gewone taal.

---

## OpenCode

```bash
opencode         # start OpenCode in de huidige map
```

OpenCode werkt op dezelfde manier maar is compatible met verschillende providers. Authenticeer via:

```bash
opencode auth
```

---

## tmux-layouts

De layouts zijn de snelste manier om te werken. Ze openen Neovim, een AI en een vrije terminal in één venster.

### `tdl` — standaard layout

```bash
tdl claude           # editor + Claude + terminal
tdl opencode         # editor + OpenCode + terminal
tdl claude opencode  # editor + Claude + OpenCode (geen losse terminal)
```

Het venster ziet er zo uit:

```
┌────────────────────┬──────────┐
│                    │          │
│      nvim .        │  claude  │
│                    │          │
├────────────────────┴──────────┤
│         vrije terminal        │
└───────────────────────────────┘
```

### `tdlm` — multi-project layout

```bash
tdlm claude
```

Voer dit uit in een map met meerdere submappen. Voor elke submap komt er een tmux-venster met een volledige `tdl`-layout. Handig voor monorepo's of wanneer je meerdere services tegelijk wilt bijwerken.

### `tsl` — parallelle zwerm

```bash
tsl 4 claude         # vier Claude-sessies naast elkaar
tsl 3 opencode       # drie OpenCode-sessies
```

Alle panelen starten hetzelfde commando, elk in de huidige map. Gebruik dit om taken parallel te laten draaien — bijvoorbeeld dezelfde prompt op meerdere subdirectories loslaten.

---

!!! warning "tmux vereist"
    `tdl`, `tdlm` en `tsl` werken alleen binnen een tmux-sessie. Start `tmux` voordat je ze aanroept.
