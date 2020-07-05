@Echo off
cls

Title Table 1.0 Demo File by TheBATeam - www.thebateam.org
Cd Files 2>nul >nul
Set "Path=%Path%;%cd%;%cd%\files"
Color 0a
mode 120,50

:Main
Cls
Echo.

batbox /c 0x0f /g 1 1 /d " This is Just a Example file...which will show the usage of TABLE function ver.1.0 to you..." /c 0x0d /g 1 3 /d "Displaying result for Test_1.table file... [Column-wise Data loading...]" /c 0x0e /g 1 25 /d "Displaying result for Test_2.table file... [Row-wise Data loading...]"

REM Calling two files individually...
Call table 40 5 5 4 10 2 1 0a test_1.table
Call table 40 28 5 4 10 2 1 0c test_2.table

pause >nul

exit