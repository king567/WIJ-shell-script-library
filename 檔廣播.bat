@echo OFF
color 0A
Rem �T�{�O�_���޲z���v��
call :IsAdmin
Rem ============================================
Echo �Y�N���}
pause
Exit
Rem ============================================
:IsAdmin
Reg.exe query "HKU\S-1-5-19\Environment"
If Not %ERRORLEVEL% EQU 0 (
 Cls & echo �v�������A�Шϥκ޲z���v�����s�}��
 Pause & Exit
)
Cls





:Start
SET choice=
echo ======================================
echo  1. �N�s���n���W��REDAgenthank.exe
echo  2. ��_��REDAgent.exe	
echo  3. ��ܤ����ϥΪ� 
echo  4. ������ܤ����ϥΪ� 
echo  0. ���}�{��			  
echo ======================================
Set /p Choice=�п�J�ﶵ?

if '%choice%'=='1' goto :C1
if '%choice%'=='2' goto :C2
if '%choice%'=='3' goto :C3
if '%choice%'=='4' goto :C4
if '%choice%'=='0' goto :C0

echo ��J���~�ﶵ 
Goto Start 

:C1
taskkill /f /im REDAgent.exe 2>nul
cd C:\CHYIOU\CHYI-IOU
if exist "C:\CHYIOU\CHYI-IOU\REDAgent.exe" goto A
Echo �ɮפ��s�b �Ϊ� �w�g��W���\
Goto Start �@�F

:A
Echo ���FREDAgent.exe
ren  REDAgent.exe REDAgenthank.exe
Echo ��W����
Goto Start �@�F���槹���^����

:C2
cd C:\CHYIOU\CHYI-IOU
ren  REDAgenthank.exe REDAgent.exe
Echo ��_����
Goto Start �@�F���槹���^����

:C3
REG ADD HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v HideFastUserSwitching /t REG_DWORD /d 0 /f
Goto Start �@�F���槹���^����

:C4
REG ADD HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v HideFastUserSwitching /t REG_DWORD /d 1 /f
Goto Start �@�F���槹���^����
:C0
Goto End 
:End