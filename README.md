# WindowsFileHandlerEnumeration
Leverages the built-in assoc command and a public powershell file handler script to map file types to handler on Windows

# Purpose
If you're looking for targets to hunt for security vulnerabilities, eg. fuzzing then this is script can do the basics for enumerating attack surface by producing a mapping of which applications have default associations with which file types. All credit for original code goes to the folks on [Stackoverflow](https://stackoverflow.com/a/60972216).

# Usage

```
C:\> assoc > assoc.txt

(then replace =.* with nothing to create a .ext file or modify the script to do this stuff)

C:\> .\AssocQueryString.ps1
...
.hlp :: C:\Windows\winhlp32.exe
.hta :: C:\Windows\SysWOW64\mshta.exe
.htm :: C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe
.html :: C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe
.icc :: C:\Windows\system32\colorcpl.exe
.icm :: C:\Windows\system32\colorcpl.exe
.imesx :: C:\Windows\system32\IME\SHARED\imesearch.exe
.img :: C:\Windows\Explorer.exe
.inf :: C:\Windows\system32\NOTEPAD.EXE
.ini :: C:\Windows\system32\NOTEPAD.EXE
.iso :: C:\Windows\Explorer.exe
```
