---
icon: lucide/shield-check
---

# Beveiliging

Agents draaien hier met `--dangerously-skip-permissions`. Dat is de bedoelde workflow, maar het betekent dat een prompt injection (of een kwaadaardige dependency) alles kan doen wat jouw gebruiker in de container kan, inclusief je tokens versturen naar een willekeurige host. Deze pagina beschrijft de maatregelen en hun grenzen.

## Egress-firewall (opt-in)

Standaard is het netwerk open. Wil je dat uitgaand verkeer alleen naar een allowlist kan, gebruik dan de firewall-variant van de devcontainer. De pagina [Egress-firewall](firewall.md) beschrijft kiezen, starten, aanpassen, debuggen en de grenzen.

## Tokens met beperkte rechten

- Gebruik een **fine-grained token** met alleen de repo's en rechten die je nodig hebt, en met een korte looptijd, in plaats van een token met brede `repo`-scope.
- Laat cloud-CLI's (`az`, `aws`, `kubectl`, `flux`) alleen ingelogd staan als de taak het vraagt; log uit als je klaar bent. Een aparte "ops"-variant zonder deze credentials is een mogelijk vervolg.

## Sessiebewaking (Entire)

Zie [AI-workflows](ai.md) voor wat er wordt bewaard en hoe je uitzet.

## Supply chain

Zie [Image, versies en supply chain](image-en-versies.md#supply-chain-wat-is-gepind-en-geverifieerd) voor wat is gepind en geverifieerd.
