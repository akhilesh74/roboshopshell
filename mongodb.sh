#!bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "script started exicuted at $TIMESTAMP" &>> $LOGFILE

VALIDATE(){
    if [$1 -ne 0]
    then
        echo -e "$2...$R failed $N"
    else 
        echo -e "$2...$G success $N"
    fi

}

if [ $ID -ne 0 ]
then 
    echo -e "$R Error: please use root $N"
    exit 1
else
    echo "yau are in root"
fi

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VALIDATE $? "copied mongo repo"

dnf install mongodb-org -y &>> $LOGFILE

VALIDATE $? "installing mongodb"

systemctl enable mongod &>> $LOGFILE

VALIDATE $? "enabling mongodb"

systemctl start mongod &>> $LOGFILE

VALIDATE $? "starting mongodb"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> $LOGFILE

VALIDATE $? "editing remote access to mongodb"

systemctl restart mongod

VALIDATE $? "restarted mongodb"