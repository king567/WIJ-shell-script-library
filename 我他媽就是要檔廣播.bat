@echo OFF
color 0A
Rem 確認是否為管理員權限
call :IsAdmin
Rem ============================================
Echo 即將離開
pause
Exit
Rem ============================================
:IsAdmin
Reg.exe query "HKU\S-1-5-19\Environment"
If Not %ERRORLEVEL% EQU 0 (
 Cls & echo 權限不足，請使用管理員權限重新開啟
 Pause & Exit
)
Cls





:Start
SET choice=
echo ======================================
echo  1. 將廣播軟體改名為REDAgenthank.exe
echo  2. 恢復為REDAgent.exe	
echo  3. 顯示切換使用者 
echo  4. 關閉顯示切換使用者 
echo  0. 離開程式			  
echo ======================================
Set /p Choice=請輸入選項?

if '%choice%'=='1' goto :C1
if '%choice%'=='2' goto :C2
if '%choice%'=='3' goto :C3
if '%choice%'=='4' goto :C4
if '%choice%'=='0' goto :C0

echo 輸入錯誤選項 
Goto Start 

:C1
taskkill /f /im REDAgent.exe 2>nul
cd C:\CHYIOU\CHYI-IOU
if exist "C:\CHYIOU\CHYI-IOU\REDAgent.exe" goto A
Echo 檔案不存在 或者 已經更名成功
Goto Start 　；

:A
Echo 找到了REDAgent.exe
ren  REDAgent.exe REDAgenthank.exe
Echo 更名完畢
Goto Start 　；執行完畢回到選單

:C2
cd C:\CHYIOU\CHYI-IOU
ren  REDAgenthank.exe REDAgent.exe
Echo 恢復完成
Goto Start 　；執行完畢回到選單

:C3
REG ADD HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v HideFastUserSwitching /t REG_DWORD /d 0 /f
Goto Start 　；執行完畢回到選單

:C4
REG ADD HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v HideFastUserSwitching /t REG_DWORD /d 1 /f
Goto Start 　；執行完畢回到選單
:C0
Goto End 
:End