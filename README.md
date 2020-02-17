# UDSignature
Signature component for UniversalDashboard

## What is it?
This component allows you to get your end-user to actually sign for something. It has two built in buttons with the component
which is the **Save** and **Clear** buttons. 

## How do I use it?
It is as simple as installing the module, then using the following command:-
```
New-UDSignature -Id "Signature"
```
You will instantly have a canvas you can sign on, pretty simple to use

## Parameters
* BackgroundColor this will set the background colour of the canvas being used this accepts a string
* Height will set the height of the canvas this accepts an integer
* Width will set the width of the canvas this accepts an integer
* PenColor will set the colour of the pen on the canvas being used this accepts as string

## How do I save what is being signed?
So I initially built this in October 2019 without support for automatically encoding to base64 string. I have now further
developed this component, so that when the save button is pressed this will set the **trimmedDataUrl** in the **state**
to hold the current signature in a base64 string. As I binded this component to UniversalDashboard on this second attempt
you can actually read the value of the base64 string then convert it back to an image and save it. So using this method also 
prevents the user from saving the end signature in the wrong directory/location. The only downfall is you will have to use another
button to read this information, as I saw it, I would be using this on a form which would have it's own submit button anyway.

```
   New-UDButton -Id "SigButton" -Text "Info" -OnClick {
                    (Get-UDElement -Id "Signature").Attributes.trimmedDataURL | Out-File C:\UD\sig.txt
                    (get-content C:\UD\sig.txt) -replace 'data:image/png;base64,', '' | Set-Content C:\UD\sig.txt
                    $base64String = (get-content C:\UD\sig.txt)
                    #Convert Base64 to Image
                    $imageBytes = [Convert]::FromBase64String($base64String)
                    $ms = New-Object IO.MemoryStream($imageBytes, 0, $imageBytes.Length)
                    $ms.Write($imageBytes, 0, $imageBytes.Length);
                    $image = [System.Drawing.Image]::FromStream($ms, $true)
                    $image.Save("C:\UD\signature.png")
                }
```

## Complete Demo

```
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
```
