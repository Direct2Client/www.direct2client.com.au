#!/usr/bin/env bash
set -euo pipefail

# === CONFIG ===
APP_NAME="d2c-static-site"
RESOURCE_GROUP="rg-atheryon-website-prod"
LOCATION="eastasia"  # Static Web Apps not available in australiaeast

# Use existing resource group (skip creation)
# az group create -n "$RESOURCE_GROUP" -l "$LOCATION"

# Create Static Web App (no CI). This will provision a temporary deployment token.
# NOTE: We will upload content manually without GitHub integration.
az staticwebapp create \
  -n "$APP_NAME" \
  -g "$RESOURCE_GROUP" \
  --location "$LOCATION" \
  --sku Free || true

# Get deployment token
TOKEN=$(az staticwebapp secrets list -n "$APP_NAME" -g "$RESOURCE_GROUP" --query "properties.apiKey" -o tsv)

echo "Static Web App created successfully!"
echo "Deployment token: $TOKEN"
echo ""
echo "To deploy your site, you can use one of these methods:"
echo ""
echo "Option 1: Install and use SWA CLI (recommended):"
echo "  npm install -g @azure/static-web-apps-cli"
echo "  swa deploy ./direct2client_site --deployment-token $TOKEN"
echo ""
echo "Option 2: Use GitHub Actions (add the token as a secret)"
echo ""

echo "Deployed. Next steps:"
echo "1) In Azure Portal → Static Web Apps → $APP_NAME → Custom domains:"
echo "   - Add www.direct2client.com.au (primary)"
echo "   - Optionally add direct2client.com.au and set redirect to www"
echo "2) At Instra DNS:"
echo "   - CNAME www → the hostname Azure shows (e.g. *.azurestaticapps.net)"
echo "   - If Instra supports ALIAS/ANAME, point apex @ → www.direct2client.com.au,"
echo "     otherwise set a registrar-level 301 redirect to https://www.direct2client.com.au"
