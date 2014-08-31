function Get-Trello {
  if(!$Script:Trello) {
    Initialize-Trello
  }
  $Script:Trello
}
Export-ModuleMember -Function Get-Trello