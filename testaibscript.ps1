#region - Test File Creation
mkdir C:\AIB
echo AIB Works > C:\AIB\aibproof.txt
#endregion

#region Download Application
(New-Object System.Net.WebClient).DownloadFile("https://aibmedia.blob.core.windows.net/media/7Zip.exe?sp=r&st=2019-04-05T10:41:52Z&se=2020-01-01T19:41:52Z&spr=https&sv=2018-03-28&sig=OvkE7gcfH118wtdZ%2F2kBzLdPSU%2ByHjwiuQgSl1%2BV1Gs%3D&sr=b", "C:\AIB\7Zip.exe")
#endregion

Start-Sleep -Seconds 120

#region - INstall App
C:\AIB\7Zip.exe /S
#endregion