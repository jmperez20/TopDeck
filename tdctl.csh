

usage()
{
    echo "Usage: $0 [start][stop][restart]"
    echo "$0 -h [To get help]"
    echo "NOTE: must 'sudo' or be 'su' to run TopDeck service"
}


runinfo()
{
    echo 'TopDeck service process completed!'
}


start()
{
    echo Starting TopDeck...
    ps aux | egrep 'mysql|mariadb' | cut -d' ' -f1 | grep mysql
    if [ $? -eq 0 ]
    then
        echo 'mysqld or mariadb is already running...'
    else
        /usr/local/etc/rc.d/mysql-server onestart
        echo 'mysqld started...'
    fi

    PATH=/usr/venv/pyvenv/bin:$PATH
    export PATH
    /usr/venv/pyvenv/bin/gunicorn --daemon --log-file /var/log/topdeck/topdeck.log --log-level debug -w 1 -b ${TDIPADD}:${TDPORT} topdeck:app
    echo TopDeck Panel Started...
    runinfo
}


stop()
{
    echo Stopping TopDeck...
    PROCLI=`ps aux | grep pyvenv | cut -w -f2`
    for p in $PROCLI
    do
        kill -9 $p
    done
    echo TopDeck panel stoped...
    runinfo
}


# MAIN
echo "Running TopDeck process: $1"
if [ "$1" == "start" ]
then
    start
elif [ "$1" == "restart" ]
then
    echo Restarting TopDeck Panel...
    stop
    sleep 1
    start
elif [ "$1" == "stop" ]
then
    stop
else
    echo "Invalid command option: $1"
    echo 'TopDeck service state not changed...'
    usage
fi


