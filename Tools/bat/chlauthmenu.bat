:: ============================================================================
:: chlauthmenu.bat
:: 
:: Windows Batch file to switch between various CHLAUTH combinations in a QMgr
:: 
:: 
:: 
:: 
:: 
:: ============================================================================
:: 20161017 T.Rob    New script
:: 
:: 
:: ============================================================================


:: Arrange to discard command line history from the menu keystrokes
@echo off
if "%~1"==":historySafe" goto :historySafe
cmd /d /c "%~f0" :historySafe
exit /b

:historySafe

:: Main program begins
SETLOCAL ENABLEEXTENSIONS
SETLOCAL ENABLEDELAYEDEXPANSION
SETLOCAL

:: Test to see if user has WMQ admin privileges
set Response=
set isAdmin=
for /f "tokens=*" %%a in ('dspmqtrn 2^>^&1') do @set Response=%%a

set isAdmin=!Response:~0,7!

if NOT "%isAdmin%"=="AMQ7028" (
	echo. 
	echo %0: This script must be run from an account with WeSphere MQ adminstrator privileges.
	exit /B 2
)

echo Initializing test environment...
SET "OOPSMSG=   The '*' indicates the current setting."
SET TIMR=3 & SET "A= " & SET "B= " & SET "C= " & SET "D= " & SET "E= " & SET "F= " & SET "G= " & SET "H= " 
strmqm -z ASH & timeout /T !TIMR! 1>NUL 2>&1
2>NUL CALL :CASE_R

:MENU
cls
echo.
echo    CHLAUTH Testing Menu
echo.
echo      !A!1) USERSRC(CHL)
echo      !B!2) USERSRC(MAP)
echo.
echo      !C!3) USERSRC(NOACCESS) - CSP
echo      !D!4) USERSRC(NOACCESS) - CLNT
echo       Sets USERSRC(CHL) globally then overrides USERMAP
echo.
echo      !E!5) MCAUSER('*NOBODY')
echo      !F!6) MCAUSER(' ')
echo.
echo      !G!7) ADOPTCTX(YES)
echo      !H!8) ADOPTCTX(NO)
echo.
echo       R) Reset to intitial values
echo       X) Exit
echo.
IF DEFINED OOPSMSG (echo    !OOPSMSG!) ELSE echo.
set OOPSMSG=
echo.

SET /P "M=    Make a selection then press ENTER: "
IF /I "!M!"=="x" GOTO :EOF
2>NUL CALL :CASE_%M% # jump to :CASE_1, :CASE_2, etc.
IF ERRORLEVEL 1 CALL :OOPS # if label doesn't exist
GOTO MENU

:CASE_1
	echo SET CHLAUTH^('CHLAUTH.ADDRMAP'^) TYPE^(ADDRESSMAP^) ADDRESS^('127.0.0.1'^) USERSRC^(CHANNEL^) CHCKCLNT^(REQUIRED^)                   ACTION^(REPLACE^) | runmqsc ASH
	echo SET CHLAUTH^('CHLAUTH.PEERMAP'^) TYPE^(SSLPEERMAP^) SSLPEER^('CN=mqm'^)    USERSRC^(CHANNEL^) CHCKCLNT^(REQUIRED^)                   ACTION^(REPLACE^) | runmqsc ASH
	echo SET CHLAUTH^('CHLAUTH.USERMAP'^) TYPE^(USERMAP^)    CLNTUSER^('testuser'^) USERSRC^(CHANNEL^) CHCKCLNT^(REQUIRED^)                   ACTION^(REPLACE^) | runmqsc ASH
	echo SET CHLAUTH^('CHLAUTH.USERMAP'^) TYPE^(USERMAP^)    CLNTUSER^('T.Rob'^)    USERSRC^(CHANNEL^) CHCKCLNT^(REQUIRED^)                   ACTION^(REPLACE^) | runmqsc ASH

	echo SET CHLAUTH^('COMPAT.ADDRMAP'^)  TYPE^(ADDRESSMAP^) ADDRESS^('127.0.0.1'^) USERSRC^(CHANNEL^) CHCKCLNT^(REQUIRED^)                   ACTION^(REPLACE^) | runmqsc ASH
	echo SET CHLAUTH^('COMPAT.PEERMAP'^)  TYPE^(SSLPEERMAP^) SSLPEER^('CN=mqm'^)    USERSRC^(CHANNEL^) CHCKCLNT^(REQUIRED^)                   ACTION^(REPLACE^) | runmqsc ASH
	echo SET CHLAUTH^('COMPAT.USERMAP'^)  TYPE^(USERMAP^)    CLNTUSER^('testuser'^) USERSRC^(CHANNEL^) CHCKCLNT^(REQUIRED^)                   ACTION^(REPLACE^) | runmqsc ASH
	echo SET CHLAUTH^('COMPAT.USERMAP'^)  TYPE^(USERMAP^)    CLNTUSER^('T.Rob'^)    USERSRC^(CHANNEL^) CHCKCLNT^(REQUIRED^)                   ACTION^(REPLACE^) | runmqsc ASH
	SET "A=*" & SET "B= " & SET "C= " & SET "D= "
	timeout /T !TIMR! >nul
	GOTO END_CASE

:CASE_2
	echo SET CHLAUTH^('CHLAUTH.ADDRMAP'^) TYPE^(ADDRESSMAP^) ADDRESS^('127.0.0.1'^) MCAUSER^('addrmap1'^) USERSRC^(MAP^) CHCKCLNT^(REQUIRED^) ACTION^(REPLACE^) | runmqsc ASH
	echo SET CHLAUTH^('CHLAUTH.PEERMAP'^) TYPE^(SSLPEERMAP^) SSLPEER^('CN=mqm'^)    MCAUSER^('peermap1'^) USERSRC^(MAP^) CHCKCLNT^(REQUIRED^) ACTION^(REPLACE^) | runmqsc ASH
	echo SET CHLAUTH^('CHLAUTH.USERMAP'^) TYPE^(USERMAP^)    CLNTUSER^('testuser'^) MCAUSER^('usermap2'^) USERSRC^(MAP^) CHCKCLNT^(REQUIRED^) ACTION^(REPLACE^) | runmqsc ASH
	echo SET CHLAUTH^('CHLAUTH.USERMAP'^) TYPE^(USERMAP^)    CLNTUSER^('T.Rob'^)    MCAUSER^('usermap1'^) USERSRC^(MAP^) CHCKCLNT^(REQUIRED^) ACTION^(REPLACE^) | runmqsc ASH

	echo SET CHLAUTH^('COMPAT.ADDRMAP'^)  TYPE^(ADDRESSMAP^) ADDRESS^('127.0.0.1'^) MCAUSER^('addrmap1'^) USERSRC^(MAP^) CHCKCLNT^(REQUIRED^) ACTION^(REPLACE^) | runmqsc ASH
	echo SET CHLAUTH^('COMPAT.PEERMAP'^)  TYPE^(SSLPEERMAP^) SSLPEER^('CN=mqm'^)    MCAUSER^('peermap1'^) USERSRC^(MAP^) CHCKCLNT^(REQUIRED^) ACTION^(REPLACE^) | runmqsc ASH
	echo SET CHLAUTH^('COMPAT.USERMAP'^)  TYPE^(USERMAP^)    CLNTUSER^('testuser'^) MCAUSER^('usermap2'^) USERSRC^(MAP^) CHCKCLNT^(REQUIRED^) ACTION^(REPLACE^) | runmqsc ASH
	echo SET CHLAUTH^('COMPAT.USERMAP'^)  TYPE^(USERMAP^)    CLNTUSER^('T.Rob'^)    MCAUSER^('usermap1'^) USERSRC^(MAP^) CHCKCLNT^(REQUIRED^) ACTION^(REPLACE^) | runmqsc ASH
	SET "A= " & SET "B=*" & SET "C= " & SET "D= "
	timeout /T !TIMR! >nul
	GOTO END_CASE

:CASE_3
	echo SET CHLAUTH^('CHLAUTH.ADDRMAP'^) TYPE^(ADDRESSMAP^) ADDRESS^('127.0.0.1'^) USERSRC^(CHANNEL^)  CHCKCLNT^(REQUIRED^)                  ACTION^(REPLACE^) | runmqsc ASH
	echo SET CHLAUTH^('CHLAUTH.PEERMAP'^) TYPE^(SSLPEERMAP^) SSLPEER^('CN=mqm'^)    USERSRC^(CHANNEL^)  CHCKCLNT^(REQUIRED^)                  ACTION^(REPLACE^) | runmqsc ASH
	echo SET CHLAUTH^('CHLAUTH.USERMAP'^) TYPE^(USERMAP^)    CLNTUSER^('testuser'^) USERSRC^(CHANNEL^)  CHCKCLNT^(REQUIRED^)                  ACTION^(REPLACE^) | runmqsc ASH

	echo SET CHLAUTH^('COMPAT.ADDRMAP'^)  TYPE^(ADDRESSMAP^) ADDRESS^('127.0.0.1'^) USERSRC^(CHANNEL^)  CHCKCLNT^(REQUIRED^)                  ACTION^(REPLACE^) | runmqsc ASH
	echo SET CHLAUTH^('COMPAT.PEERMAP'^)  TYPE^(SSLPEERMAP^) SSLPEER^('CN=mqm'^)    USERSRC^(CHANNEL^)  CHCKCLNT^(REQUIRED^)                  ACTION^(REPLACE^) | runmqsc ASH
	echo SET CHLAUTH^('COMPAT.USERMAP'^)  TYPE^(USERMAP^)    CLNTUSER^('testuser'^) USERSRC^(CHANNEL^)  CHCKCLNT^(REQUIRED^)                  ACTION^(REPLACE^) | runmqsc ASH

	echo SET CHLAUTH^('CHLAUTH.USERMAP'^) TYPE^(USERMAP^)    CLNTUSER^('T.Rob'^)    USERSRC^(CHANNEL^) CHCKCLNT^(REQUIRED^)                   ACTION^(REPLACE^) | runmqsc ASH
	echo SET CHLAUTH^('COMPAT.USERMAP'^)  TYPE^(USERMAP^)    CLNTUSER^('T.Rob'^)    USERSRC^(CHANNEL^) CHCKCLNT^(REQUIRED^)                   ACTION^(REPLACE^) | runmqsc ASH

	echo SET CHLAUTH^('CHLAUTH.USERMAP'^) TYPE^(USERMAP^)    CLNTUSER^('testuser'^) USERSRC^(NOACCESS^) CHCKCLNT^(REQUIRED^)                  ACTION^(REPLACE^) | runmqsc ASH
	echo SET CHLAUTH^('COMPAT.USERMAP'^)  TYPE^(USERMAP^)    CLNTUSER^('testuser'^) USERSRC^(NOACCESS^) CHCKCLNT^(REQUIRED^)                  ACTION^(REPLACE^) | runmqsc ASH
	SET "A=*" & SET "B= " & SET "C=*" & SET "D= "
	timeout /T !TIMR! >nul
	GOTO END_CASE

:CASE_4
	echo SET CHLAUTH^('CHLAUTH.ADDRMAP'^) TYPE^(ADDRESSMAP^) ADDRESS^('127.0.0.1'^) USERSRC^(CHANNEL^)  CHCKCLNT^(REQUIRED^)                  ACTION^(REPLACE^) | runmqsc ASH
	echo SET CHLAUTH^('CHLAUTH.PEERMAP'^) TYPE^(SSLPEERMAP^) SSLPEER^('CN=mqm'^)    USERSRC^(CHANNEL^)  CHCKCLNT^(REQUIRED^)                  ACTION^(REPLACE^) | runmqsc ASH

	echo SET CHLAUTH^('COMPAT.ADDRMAP'^)  TYPE^(ADDRESSMAP^) ADDRESS^('127.0.0.1'^) USERSRC^(CHANNEL^)  CHCKCLNT^(REQUIRED^)                  ACTION^(REPLACE^) | runmqsc ASH
	echo SET CHLAUTH^('COMPAT.PEERMAP'^)  TYPE^(SSLPEERMAP^) SSLPEER^('CN=mqm'^)    USERSRC^(CHANNEL^)  CHCKCLNT^(REQUIRED^)                  ACTION^(REPLACE^) | runmqsc ASH

	echo SET CHLAUTH^('CHLAUTH.USERMAP'^) TYPE^(USERMAP^)    CLNTUSER^('testuser'^) USERSRC^(CHANNEL^) CHCKCLNT^(REQUIRED^)                   ACTION^(REPLACE^) | runmqsc ASH
	echo SET CHLAUTH^('COMPAT.USERMAP'^)  TYPE^(USERMAP^)    CLNTUSER^('testuser'^) USERSRC^(CHANNEL^) CHCKCLNT^(REQUIRED^)                   ACTION^(REPLACE^) | runmqsc ASH

	echo SET CHLAUTH^('CHLAUTH.USERMAP'^) TYPE^(USERMAP^)    CLNTUSER^('T.Rob'^)    USERSRC^(NOACCESS^) CHCKCLNT^(REQUIRED^)                  ACTION^(REPLACE^) | runmqsc ASH
	echo SET CHLAUTH^('COMPAT.USERMAP'^)  TYPE^(USERMAP^)    CLNTUSER^('T.Rob'^)    USERSRC^(NOACCESS^) CHCKCLNT^(REQUIRED^)                  ACTION^(REPLACE^) | runmqsc ASH
	SET "A=*" & SET "B= " & SET "C= " & SET "D=*"
	timeout /T !TIMR! >nul
	GOTO END_CASE

:CASE_5
	echo DEFINE CHANNEL^('CHLAUTH.ADDRMAP'^) CHLTYPE^(SVRCONN^) MCAUSER^('^*NOBODY'^) TRPTYPE^(TCP^)                                            REPLACE | runmqsc ASH
	echo DEFINE CHANNEL^('CHLAUTH.PEERMAP'^) CHLTYPE^(SVRCONN^) MCAUSER^('^*NOBODY'^) SSLCIPH^('TLS_RSA_WITH_3DES_EDE_CBC_SHA'^) TRPTYPE^(TCP^) REPLACE | runmqsc ASH
	echo DEFINE CHANNEL^('CHLAUTH.USERMAP'^) CHLTYPE^(SVRCONN^) MCAUSER^('^*NOBODY'^) TRPTYPE^(TCP^)                                            REPLACE | runmqsc ASH
	echo DEFINE CHANNEL^('COMPAT.ADDRMAP'^)  CHLTYPE^(SVRCONN^) MCAUSER^('^*NOBODY'^) TRPTYPE^(TCP^)                                            REPLACE | runmqsc ASH
	echo DEFINE CHANNEL^('COMPAT.PEERMAP'^)  CHLTYPE^(SVRCONN^) MCAUSER^('^*NOBODY'^) SSLCIPH^('TLS_RSA_WITH_3DES_EDE_CBC_SHA'^) TRPTYPE^(TCP^) REPLACE | runmqsc ASH
	echo DEFINE CHANNEL^('COMPAT.USERMAP'^)  CHLTYPE^(SVRCONN^) MCAUSER^('^*NOBODY'^) TRPTYPE^(TCP^)                                            REPLACE | runmqsc ASH
	SET "E=*" & SET "F= "
	timeout /T !TIMR! >nul
	GOTO END_CASE

:CASE_6
	echo DEFINE CHANNEL^('CHLAUTH.ADDRMAP'^) CHLTYPE^(SVRCONN^) MCAUSER^(' '^) TRPTYPE^(TCP^)                                                 REPLACE | runmqsc ASH
	echo DEFINE CHANNEL^('CHLAUTH.PEERMAP'^) CHLTYPE^(SVRCONN^) MCAUSER^(' '^) SSLCIPH^('TLS_RSA_WITH_3DES_EDE_CBC_SHA'^) TRPTYPE^(TCP^)      REPLACE | runmqsc ASH
	echo DEFINE CHANNEL^('CHLAUTH.USERMAP'^) CHLTYPE^(SVRCONN^) MCAUSER^(' '^) TRPTYPE^(TCP^)                                                 REPLACE | runmqsc ASH
	echo DEFINE CHANNEL^('COMPAT.ADDRMAP'^)  CHLTYPE^(SVRCONN^) MCAUSER^(' '^) TRPTYPE^(TCP^)                                                 REPLACE | runmqsc ASH
	echo DEFINE CHANNEL^('COMPAT.PEERMAP'^)  CHLTYPE^(SVRCONN^) MCAUSER^(' '^) SSLCIPH^('TLS_RSA_WITH_3DES_EDE_CBC_SHA'^) TRPTYPE^(TCP^)      REPLACE | runmqsc ASH
	echo DEFINE CHANNEL^('COMPAT.USERMAP'^)  CHLTYPE^(SVRCONN^) MCAUSER^(' '^) TRPTYPE^(TCP^)                                                 REPLACE | runmqsc ASH
	SET "E= " & SET "F=*"
	timeout /T !TIMR! >nul
	GOTO END_CASE

:CASE_7
	echo ALTER AUTHINFO^('SYSTEM.DEFAULT.AUTHINFO.IDPWOS'^) AUTHTYPE^(IDPWOS^) CHCKCLNT^(REQUIRED^) ADOPTCTX^(YES^) | runmqsc ASH
	echo REFRESH SECURITY TYPE^(CONNAUTH^) | runmqsc ASH
	SET "G=*" & SET "H= "
	timeout /T !TIMR! >nul
	GOTO END_CASE

:CASE_8
	echo ALTER AUTHINFO^('SYSTEM.DEFAULT.AUTHINFO.IDPWOS'^) AUTHTYPE^(IDPWOS^) CHCKCLNT^(REQUIRED^) ADOPTCTX^(NO^) | runmqsc ASH
	echo REFRESH SECURITY TYPE^(CONNAUTH^) | runmqsc ASH
	SE	T "G= " & SET "H=*"
	timeout /T !TIMR! >nul
	GOTO END_CASE
	
:CASE_R
:CASE_r
	echo ALTER QMGR AUTHOERV(ENABLED) CHLEV(ENABLED) SSLEV(ENABLED)                       | runmqsc ASH 1>NUL 2>&1
	echo SET CHLAUTH('CHLAUTH.*'^) TYPE(BLOCKUSER^) USERLIST('*NOBODY'^) ACTION(REPLACE^) | runmqsc ASH 1>NUL 2>&1
	echo SET CHLAUTH('COMPAT.*'^)  TYPE(BLOCKUSER^) USERLIST('*NOBODY'^) ACTION(REPLACE^) | runmqsc ASH 1>NUL 2>&1
	SET TIMR2=!TIMR!
	SET TIMR=0
	2>NUL CALL :CASE_1
	2>NUL CALL :CASE_5
	SET TIMR=!TIMR2!
	2>NUL CALL :CASE_8
	GOTO END_CASE

:OOPS
	set "OOPSMSG=   !M! is not a valid option."
	GOTO END_CASE
  
:END_CASE
	VER > NUL # reset ERRORLEVEL
	GOTO :EOF # return from CALL
