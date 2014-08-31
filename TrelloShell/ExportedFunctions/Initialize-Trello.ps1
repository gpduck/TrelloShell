function Initialize-Trello {
  $AppKey = Get-TrelloApplicationKey
  if(!$AppKey) {
    Write-Error "Application key not found, please call Set-TrelloApplicationKey"
  } else {
    if(!$Script:Trello) {
      $Script:Trello = New-Object TrelloNet.Trello($AppKey.Key)
    }
  }
}
Export-ModuleMember -Function Initialize-Trello