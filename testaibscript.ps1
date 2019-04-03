#region - Test File Creation
mkdir C:\AIB
echo AIB Works > C:\AIB\aibproof.txt
#endregion

#region Download Application
$Web = New-Object System.Net.WebClient
$Web.DownloadFile("https://aibmedia.blob.core.windows.net/media/7Zip.exe", "C:\AIB\7Zip.exe")
#endregion

Start-Sleep -Seconds 120

#region - INstall App
C:\AIB\7Zip.exe /Silent
#endregion