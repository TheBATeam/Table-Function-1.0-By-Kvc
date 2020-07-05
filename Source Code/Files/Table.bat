@Echo off
Setlocal Enabledelayedexpansion

REM Table Function v.1.0 By Kvc - To reduce the efforts of main programmer, without affecting the quality of the output.
REM This function is created by Kvc - at August 2016

REM Get More Extensions Like this @ www.thebateam.org - The BatchProgramming Blog

REM Setting-up version of the program
Set ver=1.0

Set Error=0
IF /i "%~1" == "-h" (goto :Help)
IF /i "%~1" == "Help" (goto :Help)
IF /i "%~1" == "/h" (goto :Help)
IF /i "%~1" == "/?" (goto :Help)
IF /i "%~1" == "ver" (Echo.%ver%&&Exit /b %error%)

REM checking if all the necessary variables are defined...
Set Error=1
IF /i "%~1" == "" (goto :Help)
IF /i "%~2" == "" (goto :Help)
IF /i "%~3" == "" (goto :Help)
IF /i "%~4" == "" (goto :Help)
IF /i "%~5" == "" (goto :Help)
IF /i "%~6" == "" (goto :Help)
IF /i "%~7" == "" (goto :Help)
IF /i "%~8" == "" (goto :Help)
IF /i "%~9" == "" (goto :Help)


REM Setting-up important variables...
Set _X=%~1
Set _Y=%~2
Set _Rows=%~3
Set _Columns=%~4
Set /a _Cell_width=%~5+1
Set /a _Cell_height=%~6+1
Set _Style=%~7
Set _Color=%~8
Set "_file=%~9"

If Not EXIST "!_file!" (Exit /b 404)

REM calculating and checking essencial parameters...
Set /a _table_width=((!_Columns!*!_Cell_width!) + 1) + !_X!
Set /a _table_height=((!_Rows!*!_Cell_height!) + 1) + !_Y!

REM Checking current console size...
For /f "Tokens=2" %%A in ('mode con ^| find "Lines:"') do (Set _Lines=%%A)
For /f "Tokens=2" %%A in ('mode con ^| find "Columns:"') do (Set _Columns=%%A)

REM Checking, if table can be fit in the current cmd console size...
Set _Change_Size=N
If !_Lines! LEQ !_table_height! (Set _Change_Size=Y)
If !_Columns! LEQ !_table_width! (Set _Change_Size=Y)

If /i "%_Change_Size%" == "Y" (
	Set /a _temp_Columns=%_table_width% + 3
	Set /a _temp_Rows=%_table_height% + 3
	mode !_temp_Columns!,!_temp_Rows!
	)

REM Setting-up Style variables...

Set _Hor_line=32
Set _Ver_line=32
Set _Top_sepr=32
Set _Bottom_sepr=32
Set _Left_sepr=32
Set _Right_sepr=32
Set _Centre=32
Set _Top_left=32
Set _Top_right=32
Set _Bottom_left=32
Set _Bottom_right=32


If /i "%_Style%" == "1" (
	Set _Hor_line=196
	Set _Ver_line=179
	Set _Top_sepr=194
	Set _Bottom_sepr=193
	Set _Left_sepr=195
	Set _Right_sepr=180
	Set _Centre=197
	Set _Top_left=218
	Set _Top_right=191
	Set _Bottom_left=192
	Set _Bottom_right=217
	)

If /i "%_Style%" == "2" (
	Set _Hor_line=205
	Set _Ver_line=186
	Set _Top_sepr=203
	Set _Bottom_sepr=202
	Set _Left_sepr=204
	Set _Right_sepr=185
	Set _Centre=206
	Set _Top_left=201
	Set _Top_right=187
	Set _Bottom_left=200
	Set _Bottom_right=188
	)

REM Setting-up refrence line, i.e. Horizontal line...
Set _Horizontal=
Set _Space_width=

Set /a _table_height-=2
Set /a _table_width-=2

Set /a _temp_table_width=!_table_width! - !_X!
Set /a _temp_table_height=!_table_height! - !_Y!
Set _temp_Cell_width=!_Cell_width!

For /l %%A in (1,1,!_temp_table_width!) do (
	If /i "%%A" == "!_temp_Cell_width!" (
		Set "_Horizontal=!_Horizontal!/a !_Top_sepr! "
		Set "_Space_width=!_Space_width!/a !_Ver_line! "
		Set /a _temp_Cell_width+=!_Cell_width!
		) ELSE (
		Set "_Horizontal=!_Horizontal!/a !_Hor_line! "
		Set "_Space_width=!_Space_width!/a 32 "
		)
	)

Set "_Final_0=/g !_X! !_Y! /a !_Top_left! !_Horizontal! /a !_Top_right!"
Set /a _Y+=1
Set _temp_Cell_height=!_Cell_height!

For %%A in (!_Top_sepr!) do (For %%B in (!_Centre!) do (set "_New_Horizontal=!_Horizontal:%%A=%%B!"))
For /l %%A in (1,1,!_temp_table_height!) do (
	If /i "%%A" == "!_temp_Cell_height!" (
		Set "_Final_%%A=/g !_X! !_Y! /a !_Left_sepr! !_New_Horizontal! /a !_Right_sepr!"
		Set /a _temp_Cell_height+=!_Cell_height!
		) ELSE (
		Set "_Final_%%A=/g !_X! !_Y! /a !_Ver_line! !_Space_width! /a !_Ver_line!"
		)
		Set /a _Y+=1
	)

Set /a _Last=!_table_height! + 1
For %%A in (!_Top_sepr!) do (For %%B in (!_Bottom_sepr!) do (set "_New_Horizontal=!_Horizontal:%%A=%%B!"))
Set "_Final_!_Last!=/g !_X! !_Y! /a !_Bottom_left! !_New_Horizontal! /a !_Bottom_right!"

batbox /c 0x!_Color!
Set _Offset=12
Set _Result=0
Set _Last_Result=0
:Loop
Set _Final=
IF !_Result! Lss !_Last! (
	Set /a _Result+=!_Offset!
	For /l %%A In (!_Last_Result!,1,!_Result!) do (Set "_Final=!_Final_%%A! !_Final!")
	Batbox !_Final!
	Set _Last_Result=!_Result!
	Goto :Loop
	)
batbox /c 0x07


REM Code to load Table file...

REM Finding the centre line of each cell...
Set /a _mid_cell_Y=(!_Cell_height! / 2) + %~2

REM Re-setting necessary variables...
Set /a _X=%~1 + 1
Set _temp_X=!_X!
Set _temp_Y=!_mid_cell_Y!
Set _Final=

Set /p _method=<"!_file!"

If /i "!_method!" == "Column" (
for /f "usebackq skip=1 eol=# tokens=*" %%A in ("!_file!") do (
Call Getlen "%%A"
Set /a _Extra_temp_X= !_Cell_width! - !Errorlevel!
Set /a _Mid_X=!_temp_X! + !_Extra_temp_X! / 2
Set "_Final=!_Final!/g !_Mid_X! !_temp_Y! /d "%%A" "
Set /a _temp_X+=!_Cell_width!

If !_temp_X! gtr !_table_width! (
Set _temp_X=!_X!
Set /a _temp_Y+=!_Cell_height!
)
)
)

If /i "!_method!" == "Row" (
for /f "usebackq skip=1 eol=# tokens=*" %%A in ("!_file!") do (
Call Getlen "%%A"
Set /a _Extra_temp_X= !_Cell_width! - !Errorlevel!
Set /a _Mid_X=!_temp_X! + !_Extra_temp_X! / 2
Set "_Final=!_Final!/g !_Mid_X! !_temp_Y! /d "%%A" "
Set /a _temp_Y+=!_Cell_height!

If !_temp_Y! gtr !_table_height! (
Set _temp_Y=!_mid_cell_Y!
Set /a _temp_X+=!_Cell_width!
)
)
)

batbox /c 0x!_Color! !_Final! /c 0x07
exit /b 0

:Help
Echo.
Echo. This function helps in Adding a little GUI effect into your batch program...
echo. It Prints simple Table on cmd console at specified Co-ordinates :]
Echo. You can also provide a Text File, Containing The Data of Table And The method
Echo. Of printing table on CMD console. [See Example @ Bottom]
Echo.
Echo. The Function uses the fastest possible algorithm to Read and print data with 
Echo. Proper Formatting at speciifed locations. If you find any error or Bug - It is
Echo. Requested to - please report it to www.thebateam.org. We'll try to fix it as 
Echo. soon as possible.
Echo. 
echo.
echo. Syntax: call Table [X] [Y] [Rows] [Cols] [CW] [CH] [Border] [Color] [_File]
echo. Syntax: call Table [help ^| /^? ^| -h ^| -help]
echo. Syntax: call Table ver
echo.
echo. Where:-
Echo. X 		= X Co-ordinate of Top-Left corner of the Table
Echo. Y 		= Y Ordinate of Top-Left corner of the Table
Echo. Rows 		= No. of Rows to show in the Table
Echo. Cols		= No. of Columns to show in the Table
Echo. CW 		= Width of One Cell in Characters 
Echo. CH 		= Height of One Cell in Characters
Echo. Border	= The Border type to select for the Table's display. [0,1,2]
Echo. Color		= Color of the Table [Hex Code: 0F,08,07 etc.]
Echo. File		= Table Database File for the function [Comments+Table Data]
Echo.		  File should have *.table ext.
echo. ver		= Version of Table function
Echo.
Echo.
Echo. Example:-
Echo. Call Table 15 5 3 3 10 1 1 07 TestFile.Table
Echo.
Echo. Where, TestFile.table - File should be as Follows:
Echo. -------------------------------------------------------------------------------
Echo. Column
Echo. 
Echo. # The first line, must contain the method of printing... it can be either 'Row'
Echo. # or 'Column' - Based on your requirement. [One word Method selection]
Echo. #
Echo. # All Lines, after '#' Are Comments...
Echo. 
Echo. Data 1
Echo. Data 2
Echo. Data 3
Echo. Data 4
Echo. Data 5
Echo. Data 6
Echo. Data 7
Echo. Data 8
Echo. Data 9
Echo. Data 10
Echo. # Quite simple... Isn't it?
Echo. -------------------------------------------------------------------------------
Echo. 
echo. This version %_Ver% of Table function contains much more GUI Capabilities.
echo. As it uses batbox.exe and calls it only once at the end of calculation...
Echo. For the most efficient output.
Echo.
echo. Created By "Karanveer Chouhan" aka 'Kvc'
echo. Visit www.thebateam.org for more...
echo. #TheBATeam
Exit /b %Error%