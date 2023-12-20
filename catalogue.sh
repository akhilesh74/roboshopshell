#!bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"
MONGO_HOST=mongodb.akhi.fun

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "script started exicuted at $TIMESTAMP" &>> $LOGFILE

VALIDATE(){
    if [ $1 -ne 0 ]
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

dnf module disable nodejs -y

VALIDATE $? "disabling current nodejs" &>> $LOGFILE

dnf module enable nodejs:18 -y

VALIDATE $? "enabling nodejs:18" &>> $LOGFILE

dnf install nodejs -y

VALIDATE $? "installing nodejs:18" &>> $LOGFILE

useradd roboshop

VALIDATE $? " creating roboshot user" &>> $LOGFILE

mkdir /app

VALIDATE $? " creating app directory" &>> $LOGFILE

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip

VALIDATE $? " downloading catalogue application" &>> $LOGFILE

cd /app 

unzip /tmp/catalogue.zip

VALIDATE $? " unzipping catalogue" &>> $LOGFILE

npm install 

VALIDATE $? " installing dependencies" &>> $LOGFILE

#use absolute path
cp home/centos/roboshopshell/catalogue.service /etc/systemd/system/catalogue.service

VALIDATE $? " coping service file" &>> $LOGFILE

systemctl daemon-reload

VALIDATE $? " catalogue demon reload" &>> $LOGFILE

systemctl enable catalogue

VALIDATE $? " enable catalogue" &>> $LOGFILE

systemctl start catalogue

VALIDATE $? "start catalogue" &>> $LOGFILE

cp home/centos/roboshopshell/mongo.repo/etc/yum.repos.d/mongo.repo

VALIDATE $? "coping mongodb.repo" &>> $LOGFILE

dnf install mongodb-org-shell -y

VALIDATE $? "installing client" &>> $LOGFILE

mongo --host $MONGO_HOST </app/schema/catalogue.js

VALIDATE $? "loading catalogue data" &>> $LOGFILE