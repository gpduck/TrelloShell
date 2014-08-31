function Set-TrelloCard {
    param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [TrelloNet.ICardId]$Card,

        [switch]$Closed,

        [String]$Description,

        [Object]$Due,

        [string]$Name,

        [double]$Position,

        [Switch]$PassThru
    )
    begin {
        $Trello = Get-Trello
        $PropertyMap = @{
            Closed = "Closed"
            Description = "desc"
            Due = "Due"
            Name = "Name"
            Position = "pos"
        }
    }
    process {
        "Card", "PassThru" | %{
            $PSBoundParameters.Remove($_) > $null
        }
        $PSBoundParameters.Keys | %{
            $PropertyName = $PropertyMap[$_]
            if($PropertyName -eq "Due") {
              #There appears to be a bug in the library, Update doesn't work with $null for due
              $Trello.Cards.ChangeDueDate($Card, $Due)
              #But if you don't update the object too, Update sets the value back
              $Card.set_due($Due)
            } else {
              $Card."$PropertyName" = $PSBoundParameters[$_]
            }
        }
        $Trello.Cards.Update($Card)
        if($PassThru) {
            $Card
        }
    }
}
Export-ModuleMember -Function Set-TrelloCard