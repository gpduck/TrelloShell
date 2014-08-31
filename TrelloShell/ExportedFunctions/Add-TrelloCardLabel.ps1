function Add-TrelloCardLabel {
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
        $Trello.Cards.AddLabel($Card, $Color)
    }
}
Export-ModuleMember -Function Add-TrelloCardLabel