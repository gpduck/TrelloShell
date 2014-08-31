function New-TrelloCard {
    param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$Name,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [TrelloNet.IListId]$List
    )
    begin {
        $Trello = Get-Trello
    }
    process {
        $Trello.Cards.Add($Name, $List)
    }
}
Export-ModuleMember -Function New-TrelloCard