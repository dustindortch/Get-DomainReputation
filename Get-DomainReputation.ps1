[CmdletBinding()]
Param(
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [String[]]
    $Domain,

    [Parameter(ValueFromPipelineByPropertyName)]
    [ValidateNotNullOrEmpty()]
    [String]
    $DkimSelector
)

PROCESS {
    ForEach ($D in $Domain) {
        $DomainHash = [ordered]@{ }

        $Null = $DomainHash.Add('Domain', $D)

        $Mx = Resolve-DnsName $D -Type mx -ErrorAction SilentlyContinue

        If (@($Mx).Count -eq 0) {
            $MxValue = $False
            $Spf = $False
            $Dkim = $False
            $Dmarc = $False
        } Else {
            $MxValue = ($Mx | Select-Object -ExpandProperty NameExchange) -join ';'

            $Spf = Resolve-DnsName $D -Type txt -ErrorAction SilentlyContinue | Where-Object Strings -Like "*v=spf1*" | Select-Object Strings

            If (@($Spf).Count -eq 0) {
                $Spf = $False
            }

            $Dkim = Resolve-DnsName "${DkimSelector}._domainkey.${D}"  -Type txt -ErrorAction SilentlyContinue | Where-Object Strings -Like "*v=dkim1*" | Select-Object Strings

            If (@($Dkim).Count -eq 0) {
                $Dkim = $False
            }

            $Dmarc = Resolve-DnsName "_dmarc.${D}" -Type txt -ErrorAction SilentlyContinue | Where-Object Strings -Like "*v=dmarc1*" | Select-Object Strings

            If (@($Dmarc).Count -eq 0) {
                $Dmarc = $False
            }
        }
        
        $Null = $DomainHash.Add('MX', $MxValue)
        $Null = $DomainHash.Add('SPF', $Spf)
        $Null = $DomainHash.Add('DKIM', $Dkim)
        $Null = $DomainHash.Add('DMARC', $Dmarc)
        
        [PSCustomObject]$DomainHash
    }
}