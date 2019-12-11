#include <FileConstants.au3>
#include <MsgBoxConstants.au3>
#include <WinAPIFiles.au3>

Example()

Func Example()
    Local $fileOpen = FileOpen(@ScriptDir & "\category.ini")
	Local $fileWrite = FileOpen(@ScriptDir & "\new.ini")
	Local $sFileRead = FileReadLine($fileOpen, 1)
	Local $string = ""
	Local $stringBig = ""
	Local $count = 0
	;MsgBox(0,'',$sFileRead)
	ConsoleWrite(@CRLF)
	Local $arr = StringSplit($sFileRead,"|")
	For $i = 1 To $arr[0] Step 1
		If StringLeft($arr[$i], 1) = "*" Then
			$stringBig &= $arr
		Else
			$count += 1
			$string &= '<option value="' & $count & '">' & $arr[$i] & '</option>' & @CRLF
		EndIf
	Next
	;MsgBox(0,'',$string)
	;ConsoleWrite($string)
	FileWrite($fileWrite, $string)
	FileClose($fileOpen)
	FileClose($fileWrite)

EndFunc   ;==>Example