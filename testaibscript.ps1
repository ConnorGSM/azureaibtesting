#region - Test File Creation
mkdir C:\AIB
echo AIB Works > C:\AIB\aibproof.txt
#endregion

#region Download Application
(New-Object System.Net.WebClient).DownloadFile("https://aibmedia.blob.core.windows.net/media/7Zip.exe?sv=2018-03-28&ss=b&srt=sco&sp=rl&se=2020-01-11T20:20:39Z&st=2019-04-08T11:20:39Z&spr=https&sig=3xY%2BF0S5yZdpGzXdTj7vQhsZchOdhabNo2Vix562V0U%3D", "C:\AIB\7Zip.exe")
#endregion

Start-Sleep -Seconds 120

#region - INstall App
C:\AIB\7Zip.exe /S
#endregion