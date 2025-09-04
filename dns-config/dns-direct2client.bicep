// dns-direct2client.bicep
@description('Resource group must already exist (rg-dns-zones)')
param zoneName string = 'direct2client.com.au'

@description('Root A record target (web/Front Door/origin)')
param rootIPv4 string = '13.107.246.31'

@description('CNAME target for www (Front Door endpoint)')
param wwwTarget string = 'atheryon-e0eteegvahafd3e7.z03.azurefd.net'

@description('M365 MX hostname')
param mxHost string = 'direct2client-com-au.mail.protection.outlook.com'

@description('SPF string')
param spf string = 'v=spf1 include:spf.protection.outlook.com -all'

@description('MS verification TXT for M365 domain verification')
param msVerify string = 'MS=ms51081858'

@description('DMARC policy')
param dmarc string = 'v=DMARC1; p=reject; rua=mailto:postmaster@direct2client.com.au'

@description('DKIM selector 1 CNAME target')
param dkimSel1Target string = 'selector1-direct2client-com-au._domainkey.y.netorgft1876138.q-v1.dkim.mail.microsoft.com'

@description('DKIM selector 2 CNAME target')
param dkimSel2Target string = 'selector2-direct2client-com-au._domainkey.y.netorgft1876138.q-v1.dkim.mail.microsoft.com'

@description('Default TTL in seconds')
param ttl int = 3600

resource zone 'Microsoft.Network/dnsZones@2018-05-01' = {
  name: zoneName
  location: 'global'
}

resource aRoot 'Microsoft.Network/dnsZones/A@2018-05-01' = {
  name: '@'
  parent: zone
  properties: {
    TTL: ttl
    ARecords: [
      { ipv4Address: rootIPv4 }
    ]
  }
}

resource cnameWww 'Microsoft.Network/dnsZones/CNAME@2018-05-01' = {
  name: 'www'
  parent: zone
  properties: {
    TTL: ttl
    CNAMERecord: {
      cname: wwwTarget
    }
  }
}

resource mxRoot 'Microsoft.Network/dnsZones/MX@2018-05-01' = {
  name: '@'
  parent: zone
  properties: {
    TTL: ttl
    MXRecords: [
      {
        preference: 0
        exchange: mxHost
      }
    ]
  }
}

resource txtRoot 'Microsoft.Network/dnsZones/TXT@2018-05-01' = {
  name: '@'
  parent: zone
  properties: {
    TTL: ttl
    TXTRecords: [
      { value: [ spf ] }
      { value: [ msVerify ] }
    ]
  }
}

resource txtDmarc 'Microsoft.Network/dnsZones/TXT@2018-05-01' = {
  name: '_dmarc'
  parent: zone
  properties: {
    TTL: ttl
    TXTRecords: [
      { value: [ dmarc ] }
    ]
  }
}

resource cnameAutodiscover 'Microsoft.Network/dnsZones/CNAME@2018-05-01' = {
  name: 'autodiscover'
  parent: zone
  properties: {
    TTL: ttl
    CNAMERecord: {
      cname: 'autodiscover.outlook.com'
    }
  }
}

resource cnameDkimSel1 'Microsoft.Network/dnsZones/CNAME@2018-05-01' = {
  name: 'selector1._domainkey'
  parent: zone
  properties: {
    TTL: ttl
    CNAMERecord: {
      cname: dkimSel1Target
    }
  }
}

resource cnameDkimSel2 'Microsoft.Network/dnsZones/CNAME@2018-05-01' = {
  name: 'selector2._domainkey'
  parent: zone
  properties: {
    TTL: ttl
    CNAMERecord: {
      cname: dkimSel2Target
    }
  }
}

output nameServers array = zone.properties.nameServers
