function Get-TrelloOrganization {
  [CmdletBinding()]
  param(
    [String]$Name
  )
  if($Name) {
    Invoke-TrelloSearch -Query $Name -Type Organization | %{ $_.Organizations }
  } else {
    [Manatee.Trello.Me]::Me.Organizations
  }
}