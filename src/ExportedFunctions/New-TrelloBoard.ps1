function New-TrelloBoard {
  param(
    $Name,
    $Organization
  )
  if(!$Organization) {
    $Organization = [Manatee.Trello.Me]::Me
  }
  $NewBoard = $Organization.Boards.Add($Name)
  $NewBoard.
}