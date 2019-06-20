# Get-DomainReputation

## SYNOPSIS
Retrieves DNS records for sender authentication details: MX, SPF, DKIM, and DMARC.

## SYNTAX
```
Get-DomainReputation.ps1 [-Domain] <String[]> [-DkimSelector <String>]
```

## DESCRIPTION
Retrieves DNS records for sender authentication details: MX, SPF, DKIM, and DMARC.  Most records are generic, like an @ TXT record for the domain name, but DKIM does not work this way.  The generic example for a DKIM selector is "selector1" which is the default used within the script.

It can take numerous inputs from the pipeline and easily exported to other formats, like CSV.

## Examples

### Example 1
```
PS C:\> Get-DomainReputation.ps1 -Domain example.com -DkimSelector alternate3

Domain: example.com
MX: mx1.email-provider.com;mx2.email-provider.com
SPF: v=spf1 -all
DKIM: False
DMARC: v=DMARC1; p=none; rua=mailto:not.valid@example.com;
```

### Example 2
```
Domain,DkimSelector
example1.com,selector2
example2.com,selector3
```

Above is an example CSV file to use as input.

```
PS C:\> $Domains = Import-Csv .\example.csv

PS C:\> $Domains | Get-DomainReputation.ps1

Domain: example1.com
MX: mx1.email-provider.com;mx2.email-provider.com
SPF: v=spf1 -all
DKIM: False
DMARC: v=DMARC1; p=none; rua=mailto:not.valid@example1.com;

Domain: example2.com
MX: mx1.email-provider.com;mx2.email-provider.com
SPF: v=spf1 -all
DKIM: False
DMARC: v=DMARC1; p=none; rua=mailto:not.valid@example2.com;
```
