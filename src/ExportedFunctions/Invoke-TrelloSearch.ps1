function Invoke-TrelloSearch {
  param(
    $Query,
    [ValidateRange(1,1000)]
    [int32]$Limit = 1000,
    [Manatee.Trello.SearchModelType]$Type = "All",
    [Manatee.Trello.Contracts.IQueryable[]]$Context
  )

  $Search = New-Object Manatee.Trello.Search($Query, $Limit, $Type, $Context)
  
  $Search
}