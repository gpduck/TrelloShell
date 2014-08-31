function Remove-TrelloCardLabel {
    param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [TrelloNet.ICardId]$Card,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [TrelloNet.Color]$Color
    )
    begin {
        $Trello = Get-Trello
    }
    process {
        $Trello.Cards.RemoveLabel($Card, $Color)
    }
}
Export-ModuleMember -Function Remove-TrelloCardLabel