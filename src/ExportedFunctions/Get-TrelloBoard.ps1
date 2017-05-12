function Get-TrelloBoard {
  [CmdletBinding()]
  param(
    $Name,

    [Manatee.Trello.Contracts.IQueryable[]]$Context
  )
  if($Name) {
    Invoke-TrelloSearch -Query $Name -Type Boards | ForEach-Object {
      $_.Boards
    }
  } else {
    [Manatee.Trello.Me]::Me.Boards
  }
}