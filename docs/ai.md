# AI-workflows

dev-dots is gebouwd rond AI-ondersteund ontwikkelen. Twee CLI-assistenten staan klaar: **Claude Code** (Anthropic) en **OpenCode** (OpenAI-compatible). Beide starten met `--dangerously-skip-permissions` — binnen de devcontainer de bedoelde workflow. Claude Code is daarnaast uitgebreid met automatische Entire-integratie voor sessie-opslag.

---

## Eerste keer instellen

Voer `onboard` uit voor een begeleide setup:

```bash
onboard
```

Dit authenticeert in drie stappen:

1. **gh auth login** — GitHub CLI (en stelt je git-identiteit in via `gh api user`)
2. **opencode auth login** — GitHub Copilot in OpenCode
3. **claude auth login** — Claude Code CLI (subscription)

---

## Claude Code

```bash
claude           # start Claude Code in de huidige map (skip-permissions alias)
```

Claude Code werkt als een autonome agent die bestanden leest, aanpast en commando's uitvoert. Geef een taak in gewone taal.

Authenticatie verloopt via subscription: `claude auth login` (browser / device-code flow).

> De shell-alias zet `claude` om in `claude --dangerously-skip-permissions`. Een subcommando zoals `auth login` gaat dan óók door die alias: in zeldzame gevallen kan een leading flag een subcommando overschaduwen. Gebruik `command claude auth login` om de alias expliciet te omzeilen als het login-scherm niet opent.

---

## OpenCode

```bash
opencode         # start OpenCode in de huidige map (skip-permissions alias)
```

OpenCode werkt op dezelfde manier maar is compatible met verschillende providers. Authenticeer via:

```bash
opencode auth login
```

De globale config staat in `~/.config/opencode/opencode.json` met `permission: "allow"` — naast de skip-permissions alias.

---

## Entire — AI-sessies vastleggen

Entire legt AI-sessies (prompts, tool calls, file changes, transcripts) vast naast je commits, zodat je elke wijziging kunt herleiden naar de prompt die hem veroorzaakte.

**Automatische activatie:** de `claude`-functie detecteert of je in een `cedanl/`-repo zit en schakelt Entire automatisch in bij de eerste aanroep — je hoeft niks handmatig te doen.

```bash
claude   # activeert entire automatisch als origin cedanl/ is
```

Alle checkpoints worden gesynchroniseerd naar de centrale private repo **`cedanl/entire-checkpoints`** bij elke `git push`. Alleen repos met `cedanl/` als origin participeren — persoonlijke repos en andere organisaties worden overgeslagen.

```bash
entire status                      # toon huidige configuratie
entire checkpoint list             # bekijk alle checkpoints in deze repo
entire checkpoint explain          # leg uit waarom code veranderd is
entire why <bestand>               # welke prompt heeft deze regel veroorzaakt?
entire session resume <branch>     # hervat een eerdere sessie
entire dispatch                    # markdown samenvatting van recent AI-werk
```

---

## Git-identiteit per user

`onboard` leidt na `gh auth login` je git-identiteit af (`user.name` / `user.email`) en zet `user.useConfigOnly true`. Commits zonder ingestelde identiteit falen met een duidelijke fout — zo wordt misattributie tussen collega's voorkomen.
