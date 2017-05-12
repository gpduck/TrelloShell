function Set-TrelloApplicationKey {
  param(
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]$Key,

    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]$Secret
  )
  $AppDataPath = Join-Path -Path ([Environment]::GetFolderPath([Environment+SpecialFolder]::ApplicationData)) -ChildPath "TrelloShell\ApplicationKey.json"
  if(!(Test-Path (Split-Path $AppDataPath -Parent))) {
    mkdir (Split-Path $AppDataPath -Parent) > $null
  }

  [PSCustomObject]@{
    Key = $Key
    Secret = $Secret
  } | ConvertTo-Json | Set-Content -Path $AppDataPath
}