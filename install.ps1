<#
    The PanDev CLI installer has moved. Everything public about the CLI now
    lives in one repository: https://github.com/pandev-metriks/pandev-cli
    New URL:
      iwr https://raw.githubusercontent.com/pandev-metriks/pandev-cli/main/install.ps1 -UseBasicParsing | iex
#>
Write-Host "The PanDev CLI installer moved to https://github.com/pandev-metriks/pandev-cli - redirecting..."
Invoke-WebRequest https://raw.githubusercontent.com/pandev-metriks/pandev-cli/main/install.ps1 -UseBasicParsing | Invoke-Expression
