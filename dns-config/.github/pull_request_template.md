# Summary

- Purpose of this change and high-level context.
- Linked issue(s): #

# Changes

- Brief list of resource/record changes.

# Impact

- Zones/records affected and expected external impact (if any).

# What-If Output

Paste the output from `make what-if` here to validate changes.

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

# Post-Deploy Verification (optional)

- Run `make ns` and `make verify`. Paste outputs if relevant.
