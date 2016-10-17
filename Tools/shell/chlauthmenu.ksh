#!/usr/bin/ksh
# =============================================================================
# chlauthmenu.ksh
# 
# 
# 
# 
# 
# 
# 
# 
# =============================================================================
# 20161017 T.Rob      New script
# 
# =============================================================================


# Must run as mqm!
[[ $(whoami) != "mqm" ]] &&  _Usage "Script must be executed as the mqm user.\n"

QMGR=ASH
OOPSMSG="   The '*' indicates the current setting."
TIMR=3
A=" "; B=" "; C=" "; D=" "; E=" "; F=" "; G=" "; H=" "

strmqm -z ASH; read -t 2



function press_enter
{
    echo ""
    echo -n "Press Enter to continue "
    read -t 3
    clear
}

function CHL {
	echo "SET CHLAUTH('CHLAUTH.ADDRMAP') TYPE(ADDRESSMAP) ADDRESS('127.0.0.1') USERSRC(CHANNEL) CHCKCLNT(REQUIRED)                 ACTION(REPLACE)" | runmqsc $QMGR
	echo "SET CHLAUTH('CHLAUTH.PEERMAP') TYPE(SSLPEERMAP) SSLPEER('CN=mqm')    USERSRC(CHANNEL) CHCKCLNT(REQUIRED)                 ACTION(REPLACE)" | runmqsc $QMGR
	echo "SET CHLAUTH('CHLAUTH.USERMAP') TYPE(USERMAP)    CLNTUSER('mqm')      USERSRC(CHANNEL) CHCKCLNT(REQUIRED)                 ACTION(REPLACE)" | runmqsc $QMGR
	echo "SET CHLAUTH('CHLAUTH.USERMAP') TYPE(USERMAP)    CLNTUSER('t.rob')    USERSRC(CHANNEL) CHCKCLNT(REQUIRED)                 ACTION(REPLACE)" | runmqsc $QMGR

	echo "SET CHLAUTH('COMPAT.ADDRMAP')  TYPE(ADDRESSMAP) ADDRESS('127.0.0.1') USERSRC(CHANNEL) CHCKCLNT(REQUIRED)                 ACTION(REPLACE)" | runmqsc $QMGR
	echo "SET CHLAUTH('COMPAT.PEERMAP')  TYPE(SSLPEERMAP) SSLPEER('CN=mqm')    USERSRC(CHANNEL) CHCKCLNT(REQUIRED)                 ACTION(REPLACE)" | runmqsc $QMGR
	echo "SET CHLAUTH('COMPAT.USERMAP')  TYPE(USERMAP)    CLNTUSER('mqm')      USERSRC(CHANNEL) CHCKCLNT(REQUIRED)                 ACTION(REPLACE)" | runmqsc $QMGR
	echo "SET CHLAUTH('COMPAT.USERMAP')  TYPE(USERMAP)    CLNTUSER('t.rob')    USERSRC(CHANNEL) CHCKCLNT(REQUIRED)                 ACTION(REPLACE)" | runmqsc $QMGR
	A="*";  B=" ";  C=" ";  D=" "
}

function MAP {
	echo "SET CHLAUTH('CHLAUTH.ADDRMAP') TYPE(ADDRESSMAP) ADDRESS('127.0.0.1') MCAUSER('addrmap1') USERSRC(MAP) CHCKCLNT(REQUIRED) ACTION(REPLACE)" | runmqsc $QMGR
	echo "SET CHLAUTH('CHLAUTH.PEERMAP') TYPE(SSLPEERMAP) SSLPEER('CN=mqm')    MCAUSER('peermap1') USERSRC(MAP) CHCKCLNT(REQUIRED) ACTION(REPLACE)" | runmqsc $QMGR
	echo "SET CHLAUTH('CHLAUTH.USERMAP') TYPE(USERMAP)    CLNTUSER('mqm')      MCAUSER('usermap2') USERSRC(MAP) CHCKCLNT(REQUIRED) ACTION(REPLACE)" | runmqsc $QMGR
	echo "SET CHLAUTH('CHLAUTH.USERMAP') TYPE(USERMAP)    CLNTUSER('t.rob')    MCAUSER('usermap1') USERSRC(MAP) CHCKCLNT(REQUIRED) ACTION(REPLACE)" | runmqsc $QMGR

	echo "SET CHLAUTH('COMPAT.ADDRMAP')  TYPE(ADDRESSMAP) ADDRESS('127.0.0.1') MCAUSER('addrmap1') USERSRC(MAP) CHCKCLNT(REQUIRED) ACTION(REPLACE)" | runmqsc $QMGR
	echo "SET CHLAUTH('COMPAT.PEERMAP')  TYPE(SSLPEERMAP) SSLPEER('CN=mqm')    MCAUSER('peermap1') USERSRC(MAP) CHCKCLNT(REQUIRED) ACTION(REPLACE)" | runmqsc $QMGR
	echo "SET CHLAUTH('COMPAT.USERMAP')  TYPE(USERMAP)    CLNTUSER('mqm')      MCAUSER('usermap2') USERSRC(MAP) CHCKCLNT(REQUIRED) ACTION(REPLACE)" | runmqsc $QMGR
	echo "SET CHLAUTH('COMPAT.USERMAP')  TYPE(USERMAP)    CLNTUSER('t.rob')    MCAUSER('usermap1') USERSRC(MAP) CHCKCLNT(REQUIRED) ACTION(REPLACE)" | runmqsc $QMGR
	A=" ";  B="*";  C=" ";  D=" "
}

function CD {
	echo "SET CHLAUTH('CHLAUTH.ADDRMAP') TYPE(ADDRESSMAP) ADDRESS('127.0.0.1') USERSRC(CHANNEL)  CHCKCLNT(REQUIRED)                ACTION(REPLACE)" | runmqsc $QMGR
	echo "SET CHLAUTH('CHLAUTH.PEERMAP') TYPE(SSLPEERMAP) SSLPEER('CN=mqm')    USERSRC(CHANNEL)  CHCKCLNT(REQUIRED)                ACTION(REPLACE)" | runmqsc $QMGR

	echo "SET CHLAUTH('COMPAT.ADDRMAP')  TYPE(ADDRESSMAP) ADDRESS('127.0.0.1') USERSRC(CHANNEL)  CHCKCLNT(REQUIRED)                ACTION(REPLACE)" | runmqsc $QMGR
	echo "SET CHLAUTH('COMPAT.PEERMAP')  TYPE(SSLPEERMAP) SSLPEER('CN=mqm')    USERSRC(CHANNEL)  CHCKCLNT(REQUIRED)                ACTION(REPLACE)" | runmqsc $QMGR

	echo "SET CHLAUTH('CHLAUTH.USERMAP') TYPE(USERMAP)    CLNTUSER('t.rob')    USERSRC(CHANNEL)  CHCKCLNT(REQUIRED)                ACTION(REPLACE)" | runmqsc $QMGR
	echo "SET CHLAUTH('COMPAT.USERMAP')  TYPE(USERMAP)    CLNTUSER('t.rob')    USERSRC(CHANNEL)  CHCKCLNT(REQUIRED)                ACTION(REPLACE)" | runmqsc $QMGR

	echo "SET CHLAUTH('CHLAUTH.USERMAP') TYPE(USERMAP)    CLNTUSER('mqm')      USERSRC(NOACCESS)                                   ACTION(REPLACE)" | runmqsc $QMGR
	echo "SET CHLAUTH('COMPAT.USERMAP')  TYPE(USERMAP)    CLNTUSER('mqm')      USERSRC(NOACCESS)                                   ACTION(REPLACE)" | runmqsc $QMGR
	A="*";  B=" ";  C="*";  D=" "
}

function CSP {
	echo "SET CHLAUTH('CHLAUTH.ADDRMAP') TYPE(ADDRESSMAP) ADDRESS('127.0.0.1') USERSRC(CHANNEL)  CHCKCLNT(REQUIRED)                ACTION(REPLACE)" | runmqsc $QMGR
	echo "SET CHLAUTH('CHLAUTH.PEERMAP') TYPE(SSLPEERMAP) SSLPEER('CN=mqm')    USERSRC(CHANNEL)  CHCKCLNT(REQUIRED)                ACTION(REPLACE)" | runmqsc $QMGR

	echo "SET CHLAUTH('COMPAT.ADDRMAP')  TYPE(ADDRESSMAP) ADDRESS('127.0.0.1') USERSRC(CHANNEL)  CHCKCLNT(REQUIRED)                ACTION(REPLACE)" | runmqsc $QMGR
	echo "SET CHLAUTH('COMPAT.PEERMAP')  TYPE(SSLPEERMAP) SSLPEER('CN=mqm')    USERSRC(CHANNEL)  CHCKCLNT(REQUIRED)                ACTION(REPLACE)" | runmqsc $QMGR

	echo "SET CHLAUTH('CHLAUTH.USERMAP') TYPE(USERMAP)    CLNTUSER('mqm')      USERSRC(CHANNEL)  CHCKCLNT(REQUIRED)                ACTION(REPLACE)" | runmqsc $QMGR
	echo "SET CHLAUTH('COMPAT.USERMAP')  TYPE(USERMAP)    CLNTUSER('mqm')      USERSRC(CHANNEL)  CHCKCLNT(REQUIRED)                ACTION(REPLACE)" | runmqsc $QMGR

	echo "SET CHLAUTH('CHLAUTH.USERMAP') TYPE(USERMAP)    CLNTUSER('t.rob')    USERSRC(NOACCESS)                                   ACTION(REPLACE)" | runmqsc $QMGR
	echo "SET CHLAUTH('COMPAT.USERMAP')  TYPE(USERMAP)    CLNTUSER('t.rob')    USERSRC(NOACCESS)                                   ACTION(REPLACE)" | runmqsc $QMGR
	A="*";  B=" ";  C=" ";  D="*"
}

function MCANOBODY {
	echo "DEFINE CHANNEL('CHLAUTH.ADDRMAP') CHLTYPE(SVRCONN) MCAUSER('*NOBODY') TRPTYPE(TCP)                                          REPLACE" | runmqsc $QMGR
	echo "DEFINE CHANNEL('CHLAUTH.PEERMAP') CHLTYPE(SVRCONN) MCAUSER('*NOBODY') SSLCIPH('TLS_RSA_WITH_3DES_EDE_CBC_SHA') TRPTYPE(TCP) REPLACE" | runmqsc $QMGR
	echo "DEFINE CHANNEL('CHLAUTH.USERMAP') CHLTYPE(SVRCONN) MCAUSER('*NOBODY') TRPTYPE(TCP)                                          REPLACE" | runmqsc $QMGR
	echo "DEFINE CHANNEL('COMPAT.ADDRMAP')  CHLTYPE(SVRCONN) MCAUSER('*NOBODY') TRPTYPE(TCP)                                          REPLACE" | runmqsc $QMGR
	echo "DEFINE CHANNEL('COMPAT.PEERMAP')  CHLTYPE(SVRCONN) MCAUSER('*NOBODY') SSLCIPH('TLS_RSA_WITH_3DES_EDE_CBC_SHA') TRPTYPE(TCP) REPLACE" | runmqsc $QMGR
	echo "DEFINE CHANNEL('COMPAT.USERMAP')  CHLTYPE(SVRCONN) MCAUSER('*NOBODY') TRPTYPE(TCP)                                          REPLACE" | runmqsc $QMGR
	E="*";  F=" "
}

function MCABLANK {
	echo "DEFINE CHANNEL('CHLAUTH.ADDRMAP') CHLTYPE(SVRCONN) MCAUSER(' ') TRPTYPE(TCP)                                               REPLACE" | runmqsc $QMGR
	echo "DEFINE CHANNEL('CHLAUTH.PEERMAP') CHLTYPE(SVRCONN) MCAUSER(' ') SSLCIPH('TLS_RSA_WITH_3DES_EDE_CBC_SHA') TRPTYPE(TCP)      REPLACE" | runmqsc $QMGR
	echo "DEFINE CHANNEL('CHLAUTH.USERMAP') CHLTYPE(SVRCONN) MCAUSER(' ') TRPTYPE(TCP)                                               REPLACE" | runmqsc $QMGR
	echo "DEFINE CHANNEL('COMPAT.ADDRMAP')  CHLTYPE(SVRCONN) MCAUSER(' ') TRPTYPE(TCP)                                               REPLACE" | runmqsc $QMGR
	echo "DEFINE CHANNEL('COMPAT.PEERMAP')  CHLTYPE(SVRCONN) MCAUSER(' ') SSLCIPH('TLS_RSA_WITH_3DES_EDE_CBC_SHA') TRPTYPE(TCP)      REPLACE" | runmqsc $QMGR
	echo "DEFINE CHANNEL('COMPAT.USERMAP')  CHLTYPE(SVRCONN) MCAUSER(' ') TRPTYPE(TCP)                                               REPLACE" | runmqsc $QMGR
	E=" ";  F="*"
}

function ADOPTCTXYES {
	echo "ALTER AUTHINFO('SYSTEM.DEFAULT.AUTHINFO.IDPWOS') AUTHTYPE(IDPWOS) CHCKCLNT(REQUIRED) ADOPTCTX(YES)" | runmqsc $QMGR
	echo "REFRESH SECURITY TYPE(CONNAUTH)" | runmqsc $QMGR
	G="*";  H=" "
}

function ADOPTCTXNO {
	echo "ALTER AUTHINFO('SYSTEM.DEFAULT.AUTHINFO.IDPWOS') AUTHTYPE(IDPWOS) CHCKCLNT(REQUIRED) ADOPTCTX(NO)" | runmqsc $QMGR
	echo "REFRESH SECURITY TYPE(CONNAUTH)" | runmqsc $QMGR
	G=" ";  H="*"
}
	
function RESET {
        echo "ALTER QMGR AUTHOREV(ENABLED) CERTLABL('forest') CHLEV(ENABLED) CHLAUTH(ENABLED) CONNAUTH('SYSTEM.DEFAULT.AUTHINFO.IDPWOS') DEADQ('SYSTEM.DEAD.LETTER.QUEUE') REVDNS(DISABLED) SSLEV(ENABLED) FORCE" | runmqsc $QMGR
	echo "SET CHLAUTH('CHLAUTH.*') TYPE(BLOCKUSER) USERLIST('*NOBODY') ACTION(REPLACE)" | runmqsc $QMGR 
	echo "SET CHLAUTH('COMPAT.*')  TYPE(BLOCKUSER) USERLIST('*NOBODY') ACTION(REPLACE)" | runmqsc $QMGR 
	CHL
	MCANOBODY
	ADOPTCTXNO
	dmpmqcfg -o 1line -m $QMGR | grep "SET CHLAUTH"| grep -v '(SYSTEM.'
}

function OOPS {
	OOPSMSG="   $M is not a valid option."
}


RESET; read -t 3 M

M=
until [ "$M" = "0" ]; do
clear
	echo
	echo "   CHLAUTH Testing Menu"
	echo
	echo "    ${A}1) USERSRC(CHL)"
	echo "    ${B}2) USERSRC(MAP)"
	echo
	echo "    ${C}3) USERSRC(NOACCESS) - CD"
	echo "    ${D}4) USERSRC(NOACCESS) - CSP"
	echo "     Sets USERSRC(CHL) globally then overrides USERMAP"
	echo
	echo "    ${E}5) MCAUSER('*NOBODY')"
	echo "    ${F}6) MCAUSER(' ')"
	echo
	echo "    ${G}7) ADOPTCTX(YES)"
	echo "    ${H}8) ADOPTCTX(NO)"
	echo
	echo "     R) Reset to intitial values"
	echo "     X) Exit"
	echo
	echo "   $OOPSMSG"
	OOPSMSG=
	echo
	
	read M
    case $M in
        1 ) CHL; press_enter ;;
        2 ) MAP; press_enter ;;
        3 ) CD; press_enter ;;
        4 ) CSP; press_enter ;;
        5 ) MCANOBODY; press_enter ;;
        6 ) MCABLANK; press_enter ;;
        7 ) ADOPTCTXYES; press_enter ;;
        8 ) ADOPTCTXNO; press_enter ;;
        R | r ) RESET; press_enter ;;
        X | x ) exit ;;
    esac
done
