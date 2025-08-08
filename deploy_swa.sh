#!/usr/bin/env bash
set -euo pipefail

# === CONFIG ===
APP_NAME="d2c-static-site"
RESOURCE_GROUP="rg-atheryon-website-prod"
LOCATION="australiaeast"

# Use existing resource group (skip creation)
# az group create -n "$RESOURCE_GROUP" -l "$LOCATION"

# Create Static Web App (no CI). This will provision a temporary deployment token.
# NOTE: If prompted for GitHub, press Enter to skip. We will upload content manually.
az staticwebapp create   -n "$APP_NAME"   -g "$RESOURCE_GROUP"   --location "$LOCATION"   --sku Free   --login-with-github false || true

# Get deployment token
TOKEN=$(az staticwebapp secrets list -n "$APP_NAME" -g "$RESOURCE_GROUP" --query "properties.apiKey" -o tsv)

# Upload site files from ./direct2client_site
az staticwebapp upload   -n "$APP_NAME"   -g "$RESOURCE_GROUP"   --deployment-token "$TOKEN"   --source "./direct2client_site"

echo "Deployed. Next steps:"
echo "1) In Azure Portal → Static Web Apps → $APP_NAME → Custom domains:"
echo "   - Add www.direct2client.com.au (primary)"
echo "   - Optionally add direct2client.com.au and set redirect to www"
echo "2) At Instra DNS:"
echo "   - CNAME www → the hostname Azure shows (e.g. *.azurestaticapps.net)"
echo "   - If Instra supports ALIAS/ANAME, point apex @ → www.direct2client.com.au,"
echo "     otherwise set a registrar-level 301 redirect to https://www.direct2client.com.au"
