function Get-TrelloOrganization {
  [CmdletBinding(DefaultParameterSetName="ForMe")]
  param(
    [Parameter(Mandatory=$True,ValueFromPipeline=$True,ParameterSetName='ForBoard')]
    [TrelloNet.IBoardId]$board,

    [Parameter(Mandatory=$True,ValueFromPipeline=$True,ParameterSetName='ForMember')]
    [TrelloNet.IMemberId]$member,

    [Parameter(Mandatory=$False,ValueFromPipeline=$False,ParameterSetName='ForMember')]
    [Parameter(Mandatory=$False,ValueFromPipeline=$True,ParameterSetName='ForMe')]
    [TrelloNet.OrganizationFilter]$filter,

    [String]$Name,

    [String]$DisplayName
  )
  begin {
    $Trello = Get-Trello
  }
  process {
    $WhereScript = {
      if($Name) {
        $NameFilter = $_.Name -like $Name
      } else {
        $NameFilter = $True
      }
      if($DisplayName) {
        $DisplayNameFilter = $_.DisplayName -like $DisplayName
      } else {
        $DisplayNameFilter = $True
      }
      $NameFilter -and $DisplayNameFilter
    }
 
    Invoke-TrelloObjectMethod -Object $Trello.Organizations -Name $PSCmdlet.ParameterSetName -Parameters $PSBoundParameters | where -FilterScript $WhereScript
  }
}
Export-ModuleMember -Function Get-TrelloOrganization