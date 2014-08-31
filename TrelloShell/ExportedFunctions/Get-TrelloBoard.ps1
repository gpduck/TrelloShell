function Get-TrelloBoard {
  [CmdletBinding(DefaultParameterSetName="ForMe")]
  param(
    [Parameter(Mandatory=$True,ValueFromPipeline=$True,ParameterSetName='ForCard')]
    [TrelloNet.ICardId]$card,

    [Parameter(Mandatory=$True,ValueFromPipeline=$True,ParameterSetName='ForChecklist')]
    [TrelloNet.IChecklistId]$checklist,

    [Parameter(Mandatory=$True,ValueFromPipeline=$True,ParameterSetName='ForList')]
    [TrelloNet.IListId]$list,

    [Parameter(Mandatory=$True,ValueFromPipeline=$True,ParameterSetName='ForMember')]
    [TrelloNet.IMemberId]$member,

    [Parameter(Mandatory=$True,ValueFromPipeline=$True,ParameterSetName='ForOrganization')]
    [TrelloNet.IOrganizationId]$organization,

    [Parameter(Mandatory=$False,ValueFromPipeline=$False,ParameterSetName='ForMember')]
    [Parameter(Mandatory=$False,ValueFromPipeline=$True,ParameterSetName='ForMe')]
    [Parameter(Mandatory=$False,ValueFromPipeline=$False,ParameterSetName='ForOrganization')]
    [TrelloNet.BoardFilter]$filter,

    [String]$Name
  )
  begin {
    $Trello = Get-Trello
  }
  process {
    $WhereScript = {
      if($Name) {
        $_.Name -eq $Name
      } else {
        $True
      }
    }
 
    Invoke-TrelloObjectMethod -Object $Trello.Boards -Name $PSCmdlet.ParameterSetName -Parameters $PSBoundParameters | where -FilterScript $WhereScript
  }
}
Export-ModuleMember -Function Get-TrelloBoard