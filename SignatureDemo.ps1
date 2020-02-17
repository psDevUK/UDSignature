Import-Module -Name UniversalDashboard.Community -RequiredVersion 2.8.1
Import-Module -Name UniversalDashboard.UDSignature
Get-UDDashboard | Stop-UDDashboard
$init = New-UDEndpointInitialization -Module @("UniversalDashboard.UDSignature")
Start-UDDashboard -Port 10005 -Dashboard (
    New-UDDashboard -Title "Powershell UniversalDashboard" -Content {
        New-UDRow -Columns {
            New-UDColumn -size 6 -Endpoint {
                New-UDSignature -Id "Signature" -background '#fff' -height 150 -width 300
                New-UDButton -Id "SigButton" -Text "Info" -OnClick {
                    (Get-UDElement -Id "Signature").Attributes.trimmedDataURL | Out-File C:\ud\sig.txt
                    (get-content C:\UD\sig.txt) -replace 'data:image/png;base64,', '' | Set-Content C:\UD\sig.txt
                    $base64String = (get-content C:\UD\sig.txt)
                    #Convert Base64 to Image
                    $imageBytes = [Convert]::FromBase64String($base64String)
                    $ms = New-Object IO.MemoryStream($imageBytes, 0, $imageBytes.Length)
                    $ms.Write($imageBytes, 0, $imageBytes.Length);
                    $image = [System.Drawing.Image]::FromStream($ms, $true)
                    $image.Save("C:\UD\another.png")
                }
            }
        }
    } -EndpointInitialization $init
)
