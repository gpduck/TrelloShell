function Initialize-Trello {
  $AppKey = Get-TrelloApplicationKey
  if(!$AppKey) {
    Write-Error "Application key not found, please call Set-TrelloApplicationKey"
  } else {
    if(!$Script:Trello) {
      $TrelloConfiguration = [Manatee.Trello.TrelloConfiguration]
      $Serializer = New-Object Manatee.Trello.ManateeJson.ManateeSerializer
      $TrelloConfiguration::Serializer = $Serializer
      $TrelloConfiguration::Deserializer = $Serializer
      $TrelloConfiguration::JsonFactory = New-Object Manatee.Trello.ManateeJson.ManateeFactory
      $TrelloConfiguration::RestClientProvider = New-Object Manatee.Trello.WebApi.WebApiClientProvider
      
      $TrelloAuthorization = [Manatee.Trello.TrelloAuthorization]
      $TrelloAuthorization::Default.AppKey = $AppKey.Key
    }
  }
}