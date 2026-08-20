# Auth & omgevingsvariabelen

Credentials zitten in de gemounte `gh`-auth (`~/.config/gh`) en SSH-key (`~/.ssh`). Controleer die altijd eerst voordat je meldt dat iets niet geauthenticeerd is. Bestaat er een `.devcontainer/.env` in de huidige workspace, gebruik die ook.

Stel nooit `! gh auth login` voor. Als een token verlopen is: meld dit en stop. De gebruiker regelt auth zelf.

# Sparren & preplan

Begint een bericht met "sparren:"/"sparren " of "preplan:"/"preplan ", dan is dat een gesprek, geen taakopdracht. Beide bouwen niks tot een expliciete go ("ja doe maar", "implementeer", "fix het"). Onvoorwaardelijk voor allebei: geen code schrijven, geen bestanden aanpassen, geen commits of pushes.

- **sparren** — meedenken en afwegen zónder uitvragen. Geef takes en een aanbeveling; bij onduidelijkheid stel je een benoemde aanname in plaats van te vragen.
- **preplan** — de scope juist vraag-voor-vraag scherp krijgen (grey areas, één vraag per keer), eindigend met een plan-klare samenvatting.

# Errors

Nooit direct code aanpassen als error geplakt heb. Eerst toestemming vragen voor de oplossing.

# Repos klonen: workspace-root als verzamelplek

Alle projectrepos wonen als **zustermappen** direct in de workspace-root (de buitenste repo, hier `dev-dots`) — nooit genest in elkaar (geen `edusynth/` binnen `mbo-bekostiging-bestanden/`).

Werkwijze bij `git clone`:

1. Bepaal de workspace-root: `git rev-parse --show-toplevel`. Sta je niet in een repo, gebruik de huidige werkmap.
2. Kloon de repo direct in die root als zustermap — niet in een submap van een andere kloon.
3. Voeg de gekloonde map meteen toe aan de `.gitignore` van de workspace-root (regelvorm `naam/`), zodat de buitenste repo de kloon nooit als submodule/bestanden tracket. Dit is wat repo-in-repo-problemen voorkomt: fysiek genest, git-gewijs los.
4. Bestaat de doelmap al (mislukte/halve kloon), ruim die eerst op vóór je opnieuw kloont.

Hoort een project juist volledig los te staan van de workspace, kloon het dan buiten elke bestaande repo.

# Git-hygiëne

Controleer de actieve branch (`git branch --show-current`) vóór elke commit. Commit nooit per ongeluk op `main` of de verkeerde branch; sta je verkeerd, wissel of maak eerst de juiste feature-branch.

# Vóór je bouwt: waar landt het bij de gebruiker?

Voor élke feature/fix, vóór implementatie: bepaal welk pad de échte gebruiker gebruikt en controleer dat de wijziging dáár landt — niet alleen in het code-pad dat de issue toevallig noemt.

- Lees eerst de architectuur (repo CLAUDE.md/README): wat is de **primaire interface** (app/UI vs CLI vs library)? Bij meerdere entry points: bepaal welke primair is en of het werk daar doorkomt.
- Een issue beschrijft vaak één codeplek of één pad. Trace van de primaire entry point naar de code en bevestig dat de feature daar daadwerkelijk doorwerkt — niet alleen in een secundair pad.
- Klopt het issue-voorstel niet met het primaire pad (bijv. issue zegt "schema", maar de app heeft geen schema)? Meld dat vóór je bouwt, niet erna.

# CLAUDE.md bijwerken bij structuurwijziging

Verander je de architectuur van een repo ingrijpend (entry point, module-/mapstructuur, data-flow, draaiwijze), werk dan in dezelfde wijziging de `CLAUDE.md` van die repo bij. Heeft de repo er nog geen: `/init-repo` (nieuw) of `/cedafy-claude-md` (bestaande repo op de CEDA-baseline brengen zonder eigen afspraken te overschrijven). Niet bij kleine issues, bugs, copy of styling.

# Scope schalen naar waarde

Bij grotere of multi-file wijzigingen: bak de scope vooraf af en besteed moeite naar rato van gebruikerswaarde. Bouw rand-/power-features (extra varianten, edge-paden, niveau-3 opties) die de primaire gebruiker zelden raakt niet volledig uit — lever de minimale correcte versie of zet het als losse issue weg. Zwelt een subdeel onverwacht op? Stop en weeg of het de moeite waard is i.p.v. doorbouwen.

# Standaard dev workflow

Volg voor elke niet-triviale coding taak altijd deze keten — ook zonder expliciete aanroep. Elke schakel leest een **bestand**, niet de chat-scrollback: zo overleeft het werk een contextreset of een nieuwe sessie.

1. **Denken vóór bouwen (conditioneel)** — bij een open idee of niet-triviale keuze: `/brainstorm`. Dat eindigt bij een go in een beslis-samenvatting in `docs/specs/YYYY-MM-DD-<onderwerp>.md`. Is de wijziging in één zin te beschrijven, sla dit over.
2. **Plan** — `/clear`, daarna `/plan <pad-naar-spec>` (of `/plan` direct bij een klein, helder stuk). Schrijft naar `docs/plans/`; taken landen via `/write-issue` op het CEDA-board. Bestaat er geen spec, dan verwijst `/plan` terug naar `/brainstorm`.
3. **Repo/Branch** — beslisboom:
   - Nieuwe repo? → `/init-repo` → maak issues aan met `--assignee StevenRamondt` voor geplande features.
   - Bestaande repo zonder issue → `gh issue create --assignee StevenRamondt` (altijd `--assignee StevenRamondt`, nooit weglaten).
   - Bestaande repo zonder CEDA-conforme `CLAUDE.md` → `/cedafy-claude-md`.
   - Isolatie vóór de eerste schrijfactie → `/worktree` (detecteert eerst of je al geïsoleerd zit; maakt anders een worktree). Zit je al op een feature branch/worktree → door.
4. **Ontwerp (conditioneel)** — gaat de taak om een **nieuwe pagina/flow/scherm/component of een herontwerp** (niet-triviale structuur- of gedragskeuzes)? Draai dan eerst de `ontwerper-digitaal-product` skill en loop ISGVO (Inhoud → Structuur → Gedrag → Verbeelding → Omgeving) langs vóór je code schrijft. Sla over bij kleine UI-tweaks (label/copy, één veld, markeren, pagineren), backend, CLI en engine-werk — daar is een volledig designraamwerk overkill (zie "Scope schalen naar waarde").
5. **Implementeer** — voer het plan uit, één taak per verse subagent bij een meerstaps-plan; bekijk diff en test tussendoor. Een subagent die vastloopt is een defect in het plan, niet in de subagent.
6. **Check-style** — voer `/check-style` uit op gewijzigde code.
7. **Simplify** — voer `/simplify-ceda` uit op gewijzigde code.
8. **Tests** — draai de testsuite; rapporteer resultaat.
9. **Skill-assessment** — evalueer stilzwijgend of de taak een goede skill zou zijn (criteria: herhaalbaar, repo-onafhankelijk, duidelijk afgebakend). Alleen als het antwoord ja is: meld het met een korte argumentatie (2-3 zinnen) en vraag of de skill aangemaakt moet worden. Bij nee: niks zeggen.
10. **PR** — maak PRs **altijd als draft** aan (`gh pr create --draft`); voeg `Closes #<nummer>` toe aan de beschrijving; merge nooit direct op main. Controleer altijd eerst of de PR merge conflicts heeft (`gh pr view <nr> --json mergeable`) en los ze op vóór je de PR-URL rapporteert. Vraag nooit of de PR uit draft moet — dat doet de gebruiker zelf handmatig.
11. **Terugblik (conditioneel)** — na een substantiële sessie, of bij "hoe ging dit"/"terugblik": `/sessie-terugblik`. Vaste vragenset, antwoorden in de woorden van de gebruiker.

# Flow-plaatje in de draft-PR

Raakt een wijziging een echte data- of control-flow (nieuw pad, gewijzigde verwerkingsstap, nieuwe verwerking van in- naar uitvoer), zet dan een ASCII flow-diagram in de PR-beschrijving onder het kopje `## Flow`. Doel: bij het openen van de draft-PR in één oogopslag zien welk pad je zojuist gebouwd hebt.

- Alleen bij niet-triviale, flow-rakende changes. Sla over bij copy, styling, één veld, bugfixes zonder padwijziging, config — dezelfde grens als "scope schalen naar waarde". Twijfel je of er een zinvolle flow is? Dan geen plaatje.
- Het diagram moet de daadwerkelijke diff weerspiegelen: alleen boxjes en pijlen die terug te voeren zijn op gewijzigde code. Geen verzonnen tussenstappen, geen geïdealiseerde architectuur. Een fout-maar-mooi plaatje is erger dan geen.
- Hou het klein en leesbaar (richtlijn: max ~6 boxjes, één pad). Zwelt de flow op, toon dan alleen het deel dat je wijziging raakt.

Voorbeeld:

```
[CSV upload] --> [Parser] --> [Validatie] --> [Wegschrijven DB]
                                  |
                                  v
                            [Foutrapport]
```

# CEDA context

- Eindgebruiker draait via `git clone` of `pip install` op eigen machine — dáár optimaliseren.
- Devcontainer is nooit de prioriteit, maar moet wél werken zodat ik dingen kan checken/draaien.
- Devcontainer-/lokale-omgevingsproblemen los je op in de container-config (devcontainer.json, env), nooit in een cedanl-repo. Repo-code mag nooit devcontainer-specifieke workarounds bevatten.

# Draaiomgeving

Ik werk in een devcontainer (headless), niet op de host. Ga niet uit van host-gedrag (browser/GUI opent vanzelf, host-paden, host-tooling). Antwoorden moeten kloppen vanuit de container.

# Teksten in product en docs

Voor copy die in het product belandt (UI-labels, captions, knoppen) of in documentatie: de doelgroep zijn professionals, maar niet per se technisch. Schrijf bondig, direct en professioneel.

- Geen benefit-padding of verkooppraat — beschrijf wat iets is/doet, niet hoe geweldig het is.
- Geen AI-tells. Verboden patronen o.a.: "ook maanden later", "naadloos", "moeiteloos", "in een handomdraai", "of het nu … of …", "zodat jij je kunt focussen op wat echt telt".
- Geen tijds-/scenario-padding ("ook later", "zelfs na maanden", "wanneer dan ook").
- Vermijd overdadig em-dash-gebruik; gebruik gewone zinnen.

# Communicatie

Wees bondig (caveman-stijl): geen filler, geen hedging, geen overbodige beleefdheid. Volledige technische accuraatheid behouden.

**Kort is de default. Lange lappen tekst zijn niet werkbaar.** Begin met het antwoord of de aanbeveling — geen opbouw ernaartoe. Geen muren van kopjes/tabellen/opsommingen tenzij expliciet gevraagd of echt nodig. Sparren- en analyse-antwoorden: hooguit een paar regels; één take, één aanbeveling, klaar. Geen samenvattende recaps van wat ik net deed. Twijfel je tussen kort en lang? Kort.

Ga nooit uit van technische voorkennis, ook niet bij technische onderwerpen. Leg dingen altijd uit in begrijpelijke taal. Als er stappen nodig zijn: geef ze genummerd en één voor één — niet alles tegelijk.

# Skills

Skills in `.claude/skills/` worden niet automatisch naar git gepusht. Na het aanmaken van een skill altijd expliciet toestemming vragen voor committen en pushen naar de juiste repo (`cedanl/.github` of projectrepo).

# Shell commando's

Geef shell commando's altijd als één kopieerbare regel — geen backslash line continuations. Gebruikers draaien zsh op macOS waar multi-line paste niet betrouwbaar werkt.

Extra regels voor copy-pasteerbaarheid:

- Eén code block = één commando (meerdere stappen: ketenen met `&&`)
- Nooit meerdere commando's in één code block
- Gebruik korte paden (`/tmp/tv`) en `.` als de gebruiker al in de juiste map staat
- Houd commando's kort genoeg om in één keer te plakken. Vermijd extreem lange regels (lange tokens, ingebedde data, base64-blobs) — terminals en tmux breken die bij het plakken op, wat de invoer corrumpeert. Moet er veel inhoud worden overgedragen, schrijf die naar een bestand en laat de gebruiker dat bestand kopiëren/lezen, in plaats van de data in de commandoregel te proppen.

Voor  **PowerShell-commando's** (Windows-gebruikers): geen `&&` — dat werkt alleen in PS7+, niet in de standaard Windows PowerShell 5. Geef PowerShell-stappen altijd als losse code blocks.
