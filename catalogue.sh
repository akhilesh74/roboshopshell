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
        exit 1
    else 
        echo -e "$2...$G success $N"
    fi

}

if [ $ID -ne 0 ]
then 
    echo -e "$R Error: please use root $N"
    exit 1
else
    echo "you are in root"
fi

dnf module disable nodejs -y &>> $LOGFILE

VALIDATE $? "disabling current nodejs" 

dnf module enable nodejs:18 -y &>> $LOGFILE

VALIDATE $? "enabling nodejs:18" 

dnf install nodejs -y &>> $LOGFILE

VALIDATE $? "installing nodejs:18" 

id roboshop
if [ $? -ne 0 ]
then
    useradd roboshop &>> $LOGFILE
    VALIDATE $? "roboshot user creation"
else 
    echo -e "skipping"
fi

VALIDATE $? " creating roboshot user" 

mkdir -p /app &>> $LOGFILE

VALIDATE $? " creating app directory" 

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $LOGFILE

VALIDATE $? " downloading catalogue application" 

cd /app 

unzip -o /tmp/catalogue.zip &>> $LOGFILE

VALIDATE $? " unzipping catalogue" 

npm install &>> $LOGFILE

VALIDATE $? " installing dependencies" 

#use absolute path
cp /home/centos/roboshopshell/catalogue.service /etc/systemd/system/catalogue.service &>> $LOGFILE

VALIDATE $? " coping service file" 

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? " catalogue demon reload" 

systemctl enable catalogue &>> $LOGFILE

VALIDATE $? " enable catalogue" 

systemctl start catalogue &>> $LOGFILE

VALIDATE $? "start catalogue" 

cp /home/centos/roboshopshell/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VALIDATE $? "coping mongodb.repo" 

dnf install mongodb-org-shell -y &>> $LOGFILE

VALIDATE $? "installing client" 

mongo --host 172.31.31.173</app/schema/catalogue.js &>> $LOGFILE

VALIDATE $? "loading catalogue data" 