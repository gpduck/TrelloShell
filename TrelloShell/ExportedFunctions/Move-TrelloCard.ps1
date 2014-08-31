function Move-TrelloCard {
    param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [TrelloNet.ICardId]$Card,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [TrelloNet.IListId]$List,

        [switch]$PassThru
    )
    begin {
        $Trello = Get-Trello
    }
    process {
        $Card.IdList = $List.Id
        $Trello.Cards.Move($Card, $List)
        if($PassThru) {
            $Card
        }
    }
}
Export-ModuleMember -Function Move-TrelloCard