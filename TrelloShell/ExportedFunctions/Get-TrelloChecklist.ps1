function Get-TrelloChecklist {
  param(
    [Parameter(Mandatory=$True,ValueFromPipeline=$True,ParameterSetName='ForBoard')]
    [TrelloNet.IBoardId]$board,

    [Parameter(Mandatory=$True,ValueFromPipeline=$True,ParameterSetName='ForCard')]
    [TrelloNet.ICardId]$card,

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
 
    Invoke-TrelloObjectMethod -Object $Trello.Checklists -Name $PSCmdlet.ParameterSetName -Parameters $PSBoundParameters | where -FilterScript $WhereScript
  }
}
Export-ModuleMember -Function Get-TrelloChecklist
