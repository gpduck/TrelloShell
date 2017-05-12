function Get-TrelloList {
  param(
    [String]$Name,

    [Parameter(ValueFromPipeline=$true)]
    [Manatee.Trello.Board]$Board
  )
  begin {
    Initialize-Trello
  }
  process {
    if($Board) {
      $Lists = $Board.Lists
    } else {
      $Lists = [Manatee.Trello.Me]::Me.Lists
    }
    $Lists | ?{
      if($Name) {
        $_.Name -like $Name
      } else {
        $true
      }
    }
  }
}
