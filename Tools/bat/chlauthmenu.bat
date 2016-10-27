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
:: 20161017 T.Rob    	New script
:: 20161026 fjbsaper	made elevated privilege independant of MQ
::                      changed testuser to %testuser%
:: 20161026 T.Rob       Changed to use logged-in user as the MQCD User ID
::                      Tested that USERNAME is set and != testuser
::                      Restored USERSRC(NOACCESS) rules for logged-in user
::                      Moved listener definition to the initialization subroutine
::                      Added comments for each subroutine
::                      
:: ============================================================================


@echo off
:: Make sure user name environment variable is set
:: Is this ever *not* set in Windows?
if "a%USERNAME%a" == "aa" (
	echo Environment variable USERNAME not set!
	goto usage
)

:: check parameters
set testuser=%1
if "a%testuser%a" == "aa" (
	goto usage
)
if "a%testuser%a" == "aa%USERNAME%a" (
	goto usage
)


:: Arrange to discard command line history from the menu keystrokes
if "%~2"==":historySafe" goto :historySafe
cmd /d /c "%~f0" %1 :historySafe
exit /b

:historySafe
echo testuser=%testuser%

:: Main program begins
SETLOCAL ENABLEEXTENSIONS
SETLOCAL ENABLEDELAYEDEXPANSION
SETLOCAL


:: Test to see if user has elevated WMQ admin privileges
:: we are running strmqm which does require elevated privileges in windows
:: set Response=
:: for /f "tokens=*" %%a in ('dspmqtrn 2^>^&1') do @set Response=%%a
:: set isAdmin=!Response:~0,7!
:: if NOT "%isAdmin%"=="AMQ7028" (

net session > nul 2>&1
set /a isAdmin=%errorlevel%
if %isAdmin% gtr 0 (
	echo. 
	echo %0: This script must be run from an account with elevated adminstrator privileges ^(run as administrator^).
	exit /B 2
)

echo Initializing test environment...
SET "OOPSMSG=   The '*' indicates the current setting."
SET /a TIMR=3 & SET "A= " & SET "B= " & SET "C= " & SET "D= " & SET "E= " & SET "F= " & SET "G= " & SET "H= " 
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
echo      !C!3) USERSRC(NOACCESS) - Password User
echo      !D!4) USERSRC(NOACCESS) - Process ID User
echo       Sets USERSRC(CHL) globally then overrides USERMAP
echo.
echo      !E!5) MCAUSER('nobody')
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
2>NUL CALL :CASE_%M%       # jump to :CASE_1, :CASE_2, etc.
IF ERRORLEVEL 1 CALL :OOPS # if label doesn't exist
GOTO MENU


:: In the test cases below, %testuser% is a user ID *other* than the one running the script and for which the password is provided.
:: The %USERNAME% is the name of the user running the script and running MQ Explorer and will be the ID in the MQCD for Compat Mode connections.

:: Set up USERSRC(CHANNEL)
:CASE_1
	echo SET CHLAUTH^('CHLAUTH.ADDRMAP'^) TYPE^(ADDRESSMAP^) ADDRESS^('127.0.0.1'^)   USERSRC^(CHANNEL^) CHCKCLNT^(REQUIRED^)                   ACTION^(REPLACE^) | runmqsc ASH
	echo SET CHLAUTH^('CHLAUTH.PEERMAP'^) TYPE^(SSLPEERMAP^) SSLPEER^('CN=mqm'^)      USERSRC^(CHANNEL^) CHCKCLNT^(REQUIRED^)                   ACTION^(REPLACE^) | runmqsc ASH
	echo SET CHLAUTH^('CHLAUTH.USERMAP'^) TYPE^(USERMAP^)    CLNTUSER^('%testuser%'^) USERSRC^(CHANNEL^) CHCKCLNT^(REQUIRED^)                   ACTION^(REPLACE^) | runmqsc ASH
	echo SET CHLAUTH^('CHLAUTH.USERMAP'^) TYPE^(USERMAP^)    CLNTUSER^('%USERNAME%'^) USERSRC^(CHANNEL^) CHCKCLNT^(REQUIRED^)                   ACTION^(REPLACE^) | runmqsc ASH

	echo SET CHLAUTH^('COMPAT.ADDRMAP'^)  TYPE^(ADDRESSMAP^) ADDRESS^('127.0.0.1'^)   USERSRC^(CHANNEL^) CHCKCLNT^(REQUIRED^)                   ACTION^(REPLACE^) | runmqsc ASH
	echo SET CHLAUTH^('COMPAT.PEERMAP'^)  TYPE^(SSLPEERMAP^) SSLPEER^('CN=mqm'^)      USERSRC^(CHANNEL^) CHCKCLNT^(REQUIRED^)                   ACTION^(REPLACE^) | runmqsc ASH
	echo SET CHLAUTH^('COMPAT.USERMAP'^)  TYPE^(USERMAP^)    CLNTUSER^('%testuser%'^) USERSRC^(CHANNEL^) CHCKCLNT^(REQUIRED^)                   ACTION^(REPLACE^) | runmqsc ASH
	echo SET CHLAUTH^('COMPAT.USERMAP'^)  TYPE^(USERMAP^)    CLNTUSER^('%USERNAME%'^) USERSRC^(CHANNEL^) CHCKCLNT^(REQUIRED^)                   ACTION^(REPLACE^) | runmqsc ASH
	SET "A=*" & SET "B= " & SET "C= " & SET "D= "
	timeout /T !TIMR! >nul
	GOTO END_CASE

:: Set up USERSRC(MAP)
:: To validate that the connections work, the IDs addrmap1, peermap1, usermap1, and usermap2 must be authorized to connect and inquire, preferably as members of the local mqm group.
:CASE_2
	echo SET CHLAUTH^('CHLAUTH.ADDRMAP'^) TYPE^(ADDRESSMAP^) ADDRESS^('127.0.0.1'^)   MCAUSER^('addrmap1'^) USERSRC^(MAP^)      CHCKCLNT^(REQUIRED^) ACTION^(REPLACE^) | runmqsc ASH
	echo SET CHLAUTH^('CHLAUTH.PEERMAP'^) TYPE^(SSLPEERMAP^) SSLPEER^('CN=mqm'^)      MCAUSER^('peermap1'^) USERSRC^(MAP^)      CHCKCLNT^(REQUIRED^) ACTION^(REPLACE^) | runmqsc ASH
	echo SET CHLAUTH^('CHLAUTH.USERMAP'^) TYPE^(USERMAP^)    CLNTUSER^('%USERNAME%'^) MCAUSER^('usermap1'^) USERSRC^(MAP^)      CHCKCLNT^(REQUIRED^) ACTION^(REPLACE^) | runmqsc ASH
	echo SET CHLAUTH^('CHLAUTH.USERMAP'^) TYPE^(USERMAP^)    CLNTUSER^('%testuser%'^) MCAUSER^('usermap2'^) USERSRC^(MAP^)      CHCKCLNT^(REQUIRED^) ACTION^(REPLACE^) | runmqsc ASH

	echo SET CHLAUTH^('COMPAT.ADDRMAP'^)  TYPE^(ADDRESSMAP^) ADDRESS^('127.0.0.1'^)   MCAUSER^('addrmap1'^) USERSRC^(MAP^)      CHCKCLNT^(REQUIRED^) ACTION^(REPLACE^) | runmqsc ASH
	echo SET CHLAUTH^('COMPAT.PEERMAP'^)  TYPE^(SSLPEERMAP^) SSLPEER^('CN=mqm'^)      MCAUSER^('peermap1'^) USERSRC^(MAP^)      CHCKCLNT^(REQUIRED^) ACTION^(REPLACE^) | runmqsc ASH
	echo SET CHLAUTH^('COMPAT.USERMAP'^)  TYPE^(USERMAP^)    CLNTUSER^('%USERNAME%'^) MCAUSER^('usermap1'^) USERSRC^(MAP^)      CHCKCLNT^(REQUIRED^) ACTION^(REPLACE^) | runmqsc ASH
	echo SET CHLAUTH^('COMPAT.USERMAP'^)  TYPE^(USERMAP^)    CLNTUSER^('%testuser%'^) MCAUSER^('usermap2'^) USERSRC^(MAP^)      CHCKCLNT^(REQUIRED^) ACTION^(REPLACE^) | runmqsc ASH
	SET "A= " & SET "B=*" & SET "C= " & SET "D= "
	timeout /T !TIMR! >nul
	GOTO END_CASE

:: Set up USERSRC(NOACCESS) on the ID associated with the password 
:CASE_3
	echo SET CHLAUTH^('CHLAUTH.ADDRMAP'^) TYPE^(ADDRESSMAP^) ADDRESS^('127.0.0.1'^)                         USERSRC^(CHANNEL^)  CHCKCLNT^(REQUIRED^) ACTION^(REPLACE^) | runmqsc ASH
	echo SET CHLAUTH^('CHLAUTH.PEERMAP'^) TYPE^(SSLPEERMAP^) SSLPEER^('CN=mqm'^)                            USERSRC^(CHANNEL^)  CHCKCLNT^(REQUIRED^) ACTION^(REPLACE^) | runmqsc ASH
	echo SET CHLAUTH^('CHLAUTH.USERMAP'^) TYPE^(USERMAP^)    CLNTUSER^('%testuser%'^)                       USERSRC^(CHANNEL^)  CHCKCLNT^(REQUIRED^) ACTION^(REPLACE^) | runmqsc ASH

	echo SET CHLAUTH^('COMPAT.ADDRMAP'^)  TYPE^(ADDRESSMAP^) ADDRESS^('127.0.0.1'^)                         USERSRC^(CHANNEL^)  CHCKCLNT^(REQUIRED^) ACTION^(REPLACE^) | runmqsc ASH
	echo SET CHLAUTH^('COMPAT.PEERMAP'^)  TYPE^(SSLPEERMAP^) SSLPEER^('CN=mqm'^)                            USERSRC^(CHANNEL^)  CHCKCLNT^(REQUIRED^) ACTION^(REPLACE^) | runmqsc ASH
	echo SET CHLAUTH^('COMPAT.USERMAP'^)  TYPE^(USERMAP^)    CLNTUSER^('%testuser%'^)                       USERSRC^(CHANNEL^)  CHCKCLNT^(REQUIRED^) ACTION^(REPLACE^) | runmqsc ASH

	echo SET CHLAUTH^('CHLAUTH.USERMAP'^) TYPE^(USERMAP^)    CLNTUSER^('%testuser%'^)                       USERSRC^(NOACCESS^) CHCKCLNT^(REQUIRED^) ACTION^(REPLACE^) | runmqsc ASH
	echo SET CHLAUTH^('COMPAT.USERMAP'^)  TYPE^(USERMAP^)    CLNTUSER^('%testuser%'^)                       USERSRC^(NOACCESS^) CHCKCLNT^(REQUIRED^) ACTION^(REPLACE^) | runmqsc ASH

	echo SET CHLAUTH^('CHLAUTH.USERMAP'^) TYPE^(USERMAP^)    CLNTUSER^('%USERNAME%'^)                       USERSRC^(CHANNEL^) CHCKCLNT^(REQUIRED^)  ACTION^(REPLACE^) | runmqsc ASH
	echo SET CHLAUTH^('COMPAT.USERMAP'^)  TYPE^(USERMAP^)    CLNTUSER^('%USERNAME%'^)                       USERSRC^(CHANNEL^) CHCKCLNT^(REQUIRED^)  ACTION^(REPLACE^) | runmqsc ASH

        SET "A=*" & SET "B= " & SET "C=*" & SET "D= "
	timeout /T !TIMR! >nul
	GOTO END_CASE

:: Set up USERSRC(NOACCESS) on the ID associated with the running process 
:CASE_4
	echo SET CHLAUTH^('CHLAUTH.ADDRMAP'^) TYPE^(ADDRESSMAP^) ADDRESS^('127.0.0.1'^)                         USERSRC^(CHANNEL^)  CHCKCLNT^(REQUIRED^) ACTION^(REPLACE^) | runmqsc ASH
	echo SET CHLAUTH^('CHLAUTH.PEERMAP'^) TYPE^(SSLPEERMAP^) SSLPEER^('CN=mqm'^)                            USERSRC^(CHANNEL^)  CHCKCLNT^(REQUIRED^) ACTION^(REPLACE^) | runmqsc ASH

	echo SET CHLAUTH^('COMPAT.ADDRMAP'^)  TYPE^(ADDRESSMAP^) ADDRESS^('127.0.0.1'^)                         USERSRC^(CHANNEL^)  CHCKCLNT^(REQUIRED^) ACTION^(REPLACE^) | runmqsc ASH
	echo SET CHLAUTH^('COMPAT.PEERMAP'^)  TYPE^(SSLPEERMAP^) SSLPEER^('CN=mqm'^)                            USERSRC^(CHANNEL^)  CHCKCLNT^(REQUIRED^) ACTION^(REPLACE^) | runmqsc ASH

	echo SET CHLAUTH^('CHLAUTH.USERMAP'^) TYPE^(USERMAP^)    CLNTUSER^('%testuser%'^)                       USERSRC^(CHANNEL^) CHCKCLNT^(REQUIRED^)  ACTION^(REPLACE^) | runmqsc ASH
	echo SET CHLAUTH^('COMPAT.USERMAP'^)  TYPE^(USERMAP^)    CLNTUSER^('%testuser%'^)                       USERSRC^(CHANNEL^) CHCKCLNT^(REQUIRED^)  ACTION^(REPLACE^) | runmqsc ASH

	echo SET CHLAUTH^('CHLAUTH.USERMAP'^) TYPE^(USERMAP^)    CLNTUSER^('%USERNAME%'^)                       USERSRC^(NOACCESS^) CHCKCLNT^(REQUIRED^) ACTION^(REPLACE^) | runmqsc ASH
	echo SET CHLAUTH^('COMPAT.USERMAP'^)  TYPE^(USERMAP^)    CLNTUSER^('%USERNAME%'^)                       USERSRC^(NOACCESS^) CHCKCLNT^(REQUIRED^) ACTION^(REPLACE^) | runmqsc ASH
	SET "A=*" & SET "B= " & SET "C= " & SET "D=*"
	timeout /T !TIMR! >nul
	GOTO END_CASE

:: Set MCAUSER of the channels with a blocking value 
:CASE_5
	echo DEFINE CHANNEL^('CHLAUTH.ADDRMAP'^) CHLTYPE^(SVRCONN^) MCAUSER^('^*NOBODY'^)                                            TRPTYPE^(TCP^) REPLACE | runmqsc ASH
	echo DEFINE CHANNEL^('CHLAUTH.PEERMAP'^) CHLTYPE^(SVRCONN^) MCAUSER^('^*NOBODY'^) SSLCIPH^('TLS_RSA_WITH_3DES_EDE_CBC_SHA'^) TRPTYPE^(TCP^) REPLACE | runmqsc ASH
	echo DEFINE CHANNEL^('CHLAUTH.USERMAP'^) CHLTYPE^(SVRCONN^) MCAUSER^('^*NOBODY'^)                                            TRPTYPE^(TCP^) REPLACE | runmqsc ASH
	echo DEFINE CHANNEL^('COMPAT.ADDRMAP'^)  CHLTYPE^(SVRCONN^) MCAUSER^('^*NOBODY'^)                                            TRPTYPE^(TCP^) REPLACE | runmqsc ASH
	echo DEFINE CHANNEL^('COMPAT.PEERMAP'^)  CHLTYPE^(SVRCONN^) MCAUSER^('^*NOBODY'^) SSLCIPH^('TLS_RSA_WITH_3DES_EDE_CBC_SHA'^) TRPTYPE^(TCP^) REPLACE | runmqsc ASH
	echo DEFINE CHANNEL^('COMPAT.USERMAP'^)  CHLTYPE^(SVRCONN^) MCAUSER^('^*NOBODY'^)                                            TRPTYPE^(TCP^) REPLACE | runmqsc ASH
	SET "E=*" & SET "F= "
	timeout /T !TIMR! >nul
	GOTO END_CASE

:: Set MCAUSER of the channels to blank 
:CASE_6
	echo DEFINE CHANNEL^('CHLAUTH.ADDRMAP'^) CHLTYPE^(SVRCONN^) MCAUSER^(' '^)                                                   TRPTYPE^(TCP^) REPLACE | runmqsc ASH
	echo DEFINE CHANNEL^('CHLAUTH.PEERMAP'^) CHLTYPE^(SVRCONN^) MCAUSER^(' '^) SSLCIPH^('TLS_RSA_WITH_3DES_EDE_CBC_SHA'^)        TRPTYPE^(TCP^) REPLACE | runmqsc ASH
	echo DEFINE CHANNEL^('CHLAUTH.USERMAP'^) CHLTYPE^(SVRCONN^) MCAUSER^(' '^)                                                   TRPTYPE^(TCP^) REPLACE | runmqsc ASH
	echo DEFINE CHANNEL^('COMPAT.ADDRMAP'^)  CHLTYPE^(SVRCONN^) MCAUSER^(' '^)                                                   TRPTYPE^(TCP^) REPLACE | runmqsc ASH
	echo DEFINE CHANNEL^('COMPAT.PEERMAP'^)  CHLTYPE^(SVRCONN^) MCAUSER^(' '^) SSLCIPH^('TLS_RSA_WITH_3DES_EDE_CBC_SHA'^)        TRPTYPE^(TCP^) REPLACE | runmqsc ASH
	echo DEFINE CHANNEL^('COMPAT.USERMAP'^)  CHLTYPE^(SVRCONN^) MCAUSER^(' '^)                                                   TRPTYPE^(TCP^) REPLACE | runmqsc ASH
	SET "E= " & SET "F=*"
	timeout /T !TIMR! >nul
	GOTO END_CASE

:: Set ADOPTCTX(YES) and REFRESH SECURITY
:CASE_7
	echo ALTER AUTHINFO^('SYSTEM.DEFAULT.AUTHINFO.IDPWOS'^) AUTHTYPE^(IDPWOS^) CHCKCLNT^(REQUIRED^) ADOPTCTX^(YES^) | runmqsc ASH
	echo REFRESH SECURITY TYPE^(CONNAUTH^) | runmqsc ASH
	SET "G=*" & SET "H= "
	timeout /T !TIMR! >nul
	GOTO END_CASE

:: Set ADOPTCTX(NO) and REFRESH SECURITY
:CASE_8
	echo ALTER AUTHINFO^('SYSTEM.DEFAULT.AUTHINFO.IDPWOS'^) AUTHTYPE^(IDPWOS^) CHCKCLNT^(REQUIRED^) ADOPTCTX^(NO^) | runmqsc ASH
	echo REFRESH SECURITY TYPE^(CONNAUTH^) | runmqsc ASH
	SET "G= " & SET "H=*"
	timeout /T !TIMR! >nul
	GOTO END_CASE
	
:: Reset to initial values
:CASE_R
:CASE_r
	echo ALTER QMGR AUTHOERV(ENABLED) CHLEV(ENABLED) SSLEV(ENABLED)                          | runmqsc ASH 1>NUL 2>&1
	echo SET CHLAUTH('CHLAUTH.*'^) TYPE(BLOCKUSER^) USERLIST('*NOBODY'^) ACTION(REPLACE^)    | runmqsc ASH 1>NUL 2>&1
	echo SET CHLAUTH('COMPAT.*'^)  TYPE(BLOCKUSER^) USERLIST('*NOBODY'^) ACTION(REPLACE^)    | runmqsc ASH 1>NUL 2>&1
	echo define LISTENER^(ASH.TCP.1416^) trptype^(TCP^) control^(qmgr^) port^(1416^) REPLACE | runmqsc ASH 1>NUL 2>&1
	echo start LISTENER^(ASH.TCP.1416^)                                                      | runmqsc ASH 1>NUL 2>&1
	SET TIMR2=!TIMR!
	SET /a TIMR=0
	2>NUL CALL :CASE_1
	2>NUL CALL :CASE_5
	SET TIMR=!TIMR2!
	2>NUL CALL :CASE_8
	GOTO END_CASE

:: User exception message for menu selection
:OOPS
	set "OOPSMSG=   !M! is not a valid option."
	GOTO END_CASE
  
:END_CASE
	VER > NUL # reset ERRORLEVEL
	GOTO :EOF # return from CALL

goto EOF

:usage
echo Usage is :
echo %0 testuserid
echo example: %0 svcacct
echo The testuserid must be the one for which the password is provided.
echo The testuserid must NOT be the one running this script or running
echo the Java/JMS test app making the connection.
echo The USERNAME environment variable is expected to contain the user
echo ID that will run the Java/JMS test app making the connection.
exit /b 4

:EOF
