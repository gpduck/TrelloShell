function Get-TrelloApplicationKey {
  $AppDataPath = Join-Path -Path ([Environment]::GetFolderPath([Environment+SpecialFolder]::ApplicationData)) -ChildPath "TrelloShell\ApplicationKey.json"
  if(Test-Path $AppDataPath) {
    ConvertFrom-Json (Get-Content -Raw -Path $AppDataPath)
  }
}
Export-ModuleMember -Function Get-TrelloApplicationKey