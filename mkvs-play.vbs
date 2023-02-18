Dim oPlayer 
Set oPlayer = CreateObject("WMPlayer.OCX") 
 
' Play audio 
oPlayer.URL = "C:\Windows\Media\Windows Notify Calendar.wav" 
oPlayer.controls.play 
While oPlayer.playState <> 1 ' 1 = Stopped 
WScript.Sleep 100 
Wend 
 
' Release the audio file 
oPlayer.close 
