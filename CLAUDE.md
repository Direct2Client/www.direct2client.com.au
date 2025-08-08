# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a static website for Direct2Client (D2C), the parent company of Atheryon. It's a simple HTML/CSS site deployed to Azure Static Web Apps.

## Architecture

- **index.html**: Single-page website with sections for company information, services, and contact
- **styles.css**: Minimal styling with CSS custom properties for theming
- **deploy_swa.sh**: Azure Static Web Apps deployment script

## Deployment

Deploy to Azure Static Web Apps:
```bash
./deploy_swa.sh
```

The script:
1. Uses existing resource group `rg-atheryon-website-prod` in `australiaeast`
2. Creates Static Web App `d2c-static-site`
3. Uploads content from `./direct2client_site` directory
4. Outputs DNS configuration instructions for custom domain setup

## Key Details

- **Form handling**: Contact form uses Netlify Forms (`data-netlify="true"`)
- **Domain**: Configured for www.direct2client.com.au
- **Assets**: Logo (Atheryon_Logo_Light.png), favicon, and social preview image included
- **External link**: Links to Atheryon website at https://www.atheryon.com.au