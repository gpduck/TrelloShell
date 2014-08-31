function Get-TrelloCard {
  param(
    [Parameter(Mandatory=$True,ValueFromPipeline=$True,ParameterSetName='ForBoard')]
    [TrelloNet.IBoardId]$board,

    [Parameter(Mandatory=$True,ValueFromPipeline=$True,ParameterSetName='ForList')]
    [TrelloNet.IListId]$list,

    [Parameter(Mandatory=$True,ValueFromPipeline=$True,ParameterSetName='ForMember')]
    [TrelloNet.IMemberId]$member,

    
    [Parameter(Mandatory=$True,ValueFromPipeline=$True,ParameterSetName='ForChecklist')]
    [TrelloNet.IChecklistId]$checklist,

    [Parameter(Mandatory=$False,ValueFromPipeline=$False,ParameterSetName='ForList')]
    [Parameter(Mandatory=$False,ValueFromPipeline=$False,ParameterSetName='ForMember')]
    [Parameter(Mandatory=$False,ValueFromPipeline=$True,ParameterSetName='ForMe')]
    [Parameter(Mandatory=$False,ValueFromPipeline=$False,ParameterSetName='ForChecklist')]
    [TrelloNet.CardFilter]$filter,

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
    Invoke-TrelloObjectMethod -Object $Trello.Cards -Name $PSCmdlet.ParameterSetName -Parameters $PSBoundParameters | where -FilterScript $WhereScript
  }
}
Export-ModuleMember -Function Get-TrelloCard