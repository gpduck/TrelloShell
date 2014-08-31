function Get-TrelloNotification {
  [CmdletBinding(DefaultParameterSetName="ForMe")]
  param(
    [Parameter(Mandatory=$False,ValueFromPipeline=$False,ParameterSetName='ForMe')]
    [TrelloNet.NotificationType[]]$types,

    [Parameter(Mandatory=$False,ValueFromPipeline=$False,ParameterSetName='ForMe')]
    [TrelloNet.Internal.ReadFilter]$readFilter
  )
  $Trello = Get-Trello
 
  Invoke-TrelloObjectMethod -Object $Trello.Notifications -Name $PSCmdlet.ParameterSetName -Parameters $PSBoundParameters
}
Export-ModuleMember -Function Get-TrelloNotification
