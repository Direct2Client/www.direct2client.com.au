# Repository Guidelines

## Project Structure & Module Organization
- Root contains infrastructure-as-code for Azure DNS:
  - `dns-direct2client.bicep`: main template for DNS zones/records.
  - `dns-direct2client.parameters.json`: parameter values (copy per env).
  - `install-bicep-az.sh`: helper to install Azure CLI + Bicep.
  - `CNAME`: DNS alias for GitHub Pages (do not modify unless required).

## Build, Test, and Development Commands
- Install tooling: `bash ./install-bicep-az.sh` (or ensure `az` and `bicep` are on PATH).
- Login/subscription: `az login` then `az account set -s <subscription-id>`.
- Validate compile: `bicep build dns-direct2client.bicep` (checks syntax/lint).
- What‑if (preview changes):
  - `az deployment group what-if -g <rg> -f dns-direct2client.bicep -p @dns-direct2client.parameters.json`
- Deploy:
  - `az deployment group create -g <rg> -f dns-direct2client.bicep -p @dns-direct2client.parameters.json`

## Coding Style & Naming Conventions
- Indentation: 2 spaces; UTF-8; LF line endings.
- Bicep style: `camelCase` for `param`/`var`, `snake_case` not used.
- Files: `lower-kebab-case.bicep`, `name.environment.parameters.json` (e.g., `dns.prod.parameters.json`).
- Comments: use `//` for single-line, keep rationales near resources/records.

## Testing Guidelines
- Prefer `what-if` before every PR and deploy; paste summary in PR.
- Keep parameter files minimal; one per environment. Validate with `bicep build`.
- Avoid live changes outside IaC; if needed, capture drift back into Bicep.

## Commit & Pull Request Guidelines
- Commits: Conventional style (`feat:`, `fix:`, `refactor:`, `chore:`). Scope by area (e.g., `feat(dns): add MX for support`).
- PRs must include:
  - Purpose and impact (zones/records affected).
  - Command output from `what-if` (sanitized) and target resource group.
  - Linked issue or change ticket. Screenshots optional for portals.

### What-If Example (paste in PR)
```
az deployment group what-if -g rg-dns-zones -f dns-direct2client.bicep -p @dns-direct2client.parameters.json
Note: The result may contain false positive predictions (noise).
You can help us improve the accuracy of the result by opening an issue here: https://aka.ms/WhatIfIssues

Resource and property changes are indicated with this symbol:
  = Nochange

The deployment will update the following scope:

Scope: /subscriptions/34b8f36d-a89f-4848-8249-c4175ce5533e/resourceGroups/rg-dns-zones

  = Microsoft.Network/dnsZones/direct2client.com.au [2018-05-01]
  = Microsoft.Network/dnsZones/direct2client.com.au/A/@ [2018-05-01]
  = Microsoft.Network/dnsZones/direct2client.com.au/CNAME/autodiscover [2018-05-01]
  = Microsoft.Network/dnsZones/direct2client.com.au/CNAME/selector1._domainkey [2018-05-01]
  = Microsoft.Network/dnsZones/direct2client.com.au/CNAME/selector2._domainkey [2018-05-01]
  = Microsoft.Network/dnsZones/direct2client.com.au/CNAME/www [2018-05-01]
  = Microsoft.Network/dnsZones/direct2client.com.au/MX/@ [2018-05-01]
  = Microsoft.Network/dnsZones/direct2client.com.au/TXT/@ [2018-05-01]
  = Microsoft.Network/dnsZones/direct2client.com.au/TXT/_dmarc [2018-05-01]

Resource changes: 9 no change.
```

## Security & Configuration Tips
- Do not commit secrets or credentials; use Key Vault and `az login` locally.
- Parameter files may contain hostnames but no secrets; prefer per‑env copies ignored by default if sensitive.
- Set explicit subscription and resource group to avoid accidental deploys.

## Deploy (Quick Start)
```
az login
az account set -s "MCPP Subscription"
make what-if
make deploy
make ns
make verify
```
