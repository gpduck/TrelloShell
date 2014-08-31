function Get-TrelloList {
  param(
    [Parameter(Mandatory=$True,ValueFromPipeline=$True,ParameterSetName='ForCard')]
    [TrelloNet.ICardId]$card,

    [Parameter(Mandatory=$True,ValueFromPipeline=$True,ParameterSetName='ForBoard')]
    [TrelloNet.IBoardId]$board,

    [Parameter(Mandatory=$False,ValueFromPipeline=$False,ParameterSetName='ForBoard')]
    [TrelloNet.ListFilter]$filter,

    [String]$Name
  )
  begin {
    $Trello = Get-Trello
  }
  process {
    $WhereScript = {
      if($Name) {
        $_.Name -like $Name
      } else {
        $True
      }
    }
 
    Invoke-TrelloObjectMethod -Object $Trello.Lists -Name $PSCmdlet.ParameterSetName -Parameters $PSBoundParameters | where -FilterScript $WhereScript
  }
}
Export-ModuleMember -Function Get-TrelloList
