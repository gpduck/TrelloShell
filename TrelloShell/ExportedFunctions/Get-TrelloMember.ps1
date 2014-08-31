function Get-TrelloMember {
  param(
    [Parameter(Mandatory=$True,ValueFromPipeline=$True,ParameterSetName='ForBoard')]
    [TrelloNet.IBoardId]$board,

    [Parameter(Mandatory=$True,ValueFromPipeline=$True,ParameterSetName='ForCard')]
    [TrelloNet.ICardId]$card,

    [Parameter(Mandatory=$True,ValueFromPipeline=$True,ParameterSetName='ForOrganization')]
    [TrelloNet.IOrganizationId]$organization,

    [Parameter(Mandatory=$False,ValueFromPipeline=$False,ParameterSetName='ForBoard')]
    [Parameter(Mandatory=$False,ValueFromPipeline=$False,ParameterSetName='ForOrganization')]
    [TrelloNet.MemberFilter]$filter,

    [Parameter(Mandatory=$True,ValueFromPipeline=$True,ParameterSetName='ForToken')]
    [System.String]$token,

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
 
    Invoke-TrelloObjectMethod -Object $Trello.Members -Name $PSCmdlet.ParameterSetName -Parameters $PSBoundParameters | where -FilterScript $WhereScript
  }
}
Export-ModuleMember -Function Get-TrelloMember