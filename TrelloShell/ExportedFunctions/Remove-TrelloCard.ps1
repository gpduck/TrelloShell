function Remove-TrelloCard {
    [CmdletBinding(SupportsShouldProcess=$True,ConfirmImpact="High")]
    param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [TrelloNet.ICardId]$Card
    )
    begin {
        $Trello = Get-Trello
    }
    process {
        if($PSCmdlet.ShouldProcess($Card.Name, "Delete card")) {
            $Trello.Cards.Delete($Card)
        }
    }
}
Export-ModuleMember -Function Remove-TrelloCard