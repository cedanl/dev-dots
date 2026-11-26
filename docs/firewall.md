---
icon: lucide/brick-wall
---

# Egress-firewall

Standaard is het netwerk van de container open. De **firewall-variant** laat uitgaand verkeer alleen toe naar een allowlist. Zo kan een prompt injection of een kwaadaardige dependency je tokens niet naar een willekeurige host sturen. Zie [Beveiliging](beveiliging.md) voor het grotere plaatje.

!!! warning "Experimenteel"
    De firewall is geschreven en op logica getest met een dry-run, maar nog niet op een echte podman/docker-host met `NET_ADMIN` doorgemeten. Gebruik hem als extra laag, niet als enige verdediging, en meld wat er stukgaat.

## Wanneer kies je de firewall-variant?

- Je laat een agent met `--dangerously-skip-permissions` werken in een repo of met dependencies die je niet volledig vertrouwt.
- Je wilt dat een agent niet naar willekeurige hosts kan uploaden.

Heb je veel verschillende externe diensten nodig? Dan moet je ze één voor één toevoegen (zie hieronder). De standaardvariant is dan praktischer.

## Starten

```bash
# VS Code: kies bij "Reopen in Container" de configuratie "dev (egress-firewall)"
# CLI:
devcontainer up --config .devcontainer/firewall/devcontainer.json --workspace-folder .
devcontainer exec --config .devcontainer/firewall/devcontainer.json --workspace-folder . bash
```

De variant voegt `--cap-add=NET_ADMIN --cap-add=NET_RAW` toe en draait bij elke start `sudo /usr/local/sbin/init-firewall.sh`. Als de firewall niet geactiveerd kan worden, of `example.com` nog bereikbaar is, meldt de `postStartCommand` een fout. De container blijft wel draaien: je merkt dat je zonder bescherming zit, maar je wordt er niet door geblokkeerd.

## Wat is toegestaan?

- GitHub (via de gepubliceerde IP-bereiken van `api.github.com/meta`), Anthropic, npm, PyPI, `gitlab.com`, `git.sdp.surf.nl` (SURF GitLab), `git.ia.surf.nl` (oude SURF GitLab, gearchiveerd), OpenCode en Entire. De lijst staat als `CORE_DOMAINS` in `.devcontainer/init-firewall.sh`.
- DNS naar de resolvers uit `/etc/resolv.conf`, loopback en antwoorden op inkomende verbindingen (forwarded ports).
- IPv6 naar buiten is geblokkeerd.

## Extra hosts toevoegen

Bijvoorbeeld SURF Object Store, Azure of clusters:

```bash
export DEVDOTS_FIREWALL_EXTRA="objectstore.surf.nl login.microsoftonline.com"   # op je host, vóór devcontainer up
```

Dit gaat bewust via de omgeving van de container (alleen PID 1 wordt gelezen) en niet via een bestand in je workspace. Wat een agent kan schrijven, kan een aanvaller ook aan de allowlist toevoegen. Na het wijzigen van de lijst herstart je de container. Spaties en komma's scheiden de domeinen; ongeldige namen worden genegeerd met een melding.

## Een geblokkeerde verbinding onderzoeken

Het script meldt alles met het voorvoegsel `[firewall]`. Draai het opnieuw om de uitvoer te zien:

```bash
sudo /usr/local/sbin/init-firewall.sh
```

| Melding | Betekenis | Wat doe je |
|---|---|---|
| `WARNING: <host> did not resolve` | De naam kon niet worden opgelost, dus er is geen adres toegevoegd aan de allowlist. | Controleer de spelling in `DEVDOTS_FIREWALL_EXTRA`. |
| `could not fetch https://api.github.com/meta` | De GitHub-bereiken ontbreken. | Controleer je netwerk en draai het script opnieuw. |
| `iptables is not usable` | De container heeft niet de rechten voor een firewall. | Start de firewall-variant, die `NET_ADMIN` toevoegt. |
| `FAIL: https://example.com is still reachable` | De firewall dwingt niets af. | Meld het als issue, met je runtime (Docker of Podman). |
| `FAIL: https://api.github.com is not reachable` | Allowlist of DNS werkt niet. | Controleer DNS in `/etc/resolv.conf`. |

Zonder root kun je zien welke regels het script zou zetten:

```bash
FIREWALL_DRY_RUN=1 bash .devcontainer/init-firewall.sh
```

Het IP-adres van CDN-hosts kan veranderen. Draai het script opnieuw om ze te verversen.

## Wat de agent niet kan

De agent kan de firewall niet uitzetten. De sudo-regel staat precies dit script toe, zonder argumenten, en het script is eigendom van root. Je kunt de firewall dus opnieuw toepassen, maar niet uitzetten of verruimen vanuit de container.

## Grenzen en risico's

- Allowlisten op IP is grof: andere sites achter dezelfde CDN-/GitHub-bereiken blijven bereikbaar.
- DNS naar de resolver staat open, dus DNS-tunneling is mogelijk.
- Dit stopt geen exfiltratie naar een *toegestane* host, bijvoorbeeld pushen naar een GitHub-repo waar je token schrijfrechten op heeft. Gebruik daarvoor een [token met beperkte rechten](beveiliging.md#tokens-met-beperkte-rechten).
