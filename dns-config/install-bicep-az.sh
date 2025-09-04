#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SUBSCRIPTION="MCPP Subscription"
RG="rg-dns-zones"
LOCATION="australiaeast"
ZONE="direct2client.com.au"
BICEP="dns-direct2client.bicep"
PARAMS="dns-direct2client.parameters.json"

# sanity checks
[[ -n "$SUBSCRIPTION" && -n "$RG" && -n "$ZONE" && -f "$BICEP" && -f "$PARAMS" ]] || {
  echo "One or more required vars/files are missing. Check SUBSCRIPTION/RG/ZONE and $BICEP/$PARAMS"; exit 1; }

# ensure user is logged in
if ! az account show >/dev/null 2>&1; then
  echo "Please run az login"
  exit 1
fi

# select subscription
az account set --subscription "$SUBSCRIPTION"

# ensure RG exists (idempotent)
az group create -n "$RG" -l "$LOCATION" >/dev/null

# deploy bicep
az deployment group create \
  --resource-group "$RG" \
  --template-file "$BICEP" \
  --parameters @"$PARAMS"

# print Azure name servers
az network dns zone show -g "$RG" -n "$ZONE" --query nameServers -o tsv

# sanity tests (optional; do not fail if dig missing)
NS=$(az network dns zone show -g "$RG" -n "$ZONE" --query nameServers[0] -o tsv || true)
command -v dig >/dev/null 2>&1 && {
  dig @"$NS" "$ZONE" MX +short || true
  dig @"$NS" www."$ZONE" CNAME +short || true
  dig @"$NS" "$ZONE" TXT +short || true
}
