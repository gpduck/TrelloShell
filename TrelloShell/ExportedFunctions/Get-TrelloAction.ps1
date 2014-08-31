function Get-TrelloAction {
  param(
    [Parameter(Mandatory=$True,ValueFromPipeline=$True,ParameterSetName='ForBoard')]
    [TrelloNet.IBoardId]$board,

    [Parameter(Mandatory=$True,ValueFromPipeline=$True,ParameterSetName='ForCard')]
    [TrelloNet.ICardId]$card,

    [Parameter(Mandatory=$True,ValueFromPipeline=$True,ParameterSetName='ForList')]
    [TrelloNet.IListId]$list,

    [Parameter(Mandatory=$True,ValueFromPipeline=$True,ParameterSetName='ForMember')]
    [TrelloNet.IMemberId]$member,

    [Parameter(Mandatory=$True,ValueFromPipeline=$True,ParameterSetName='ForOrganization')]
    [TrelloNet.IOrganizationId]$organization,

    [Parameter(Mandatory=$False,ValueFromPipeline=$False,ParameterSetName='ForCard')]
    [Parameter(Mandatory=$False,ValueFromPipeline=$False,ParameterSetName='ForList')]
    [Parameter(Mandatory=$False,ValueFromPipeline=$False,ParameterSetName='ForMember')]
    [Parameter(Mandatory=$False,ValueFromPipeline=$True,ParameterSetName='ForMe')]
    [Parameter(Mandatory=$False,ValueFromPipeline=$False,ParameterSetName='ForOrganization')]
    [Parameter(Mandatory=$False,ValueFromPipeline=$False,ParameterSetName='ForBoard')]
    [TrelloNet.ActionType[]]$filter
  )
  begin {
    $Trello = Get-Trello
  }
  process {
    Invoke-TrelloObjectMethod -Object $Trello.Actions -Name $PSCmdlet.ParameterSetName -Parameters $PSBoundParameters
  }
}
Export-ModuleMember -Function Get-TrelloAction
