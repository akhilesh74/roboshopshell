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

mkdir -p /app &>> $LOGFILE

VALIDATE $? " creating app directory" 

curl -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>> $LOGFILE

VALIDATE $? " downloading user application" 

cd /app 

unzip -o /tmp/user.zip &>> $LOGFILE

VALIDATE $? " unzipping user" 

npm install &>> $LOGFILE

VALIDATE $? " installing dependencies"

cp /home/centos/roboshopshell/user.service /etc/systemd/system/user.service

VALIDATE $? " coping service file" 

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? " user demon reload" 

systemctl enable user &>> $LOGFILE

VALIDATE $? " enable user" 

systemctl start user &>> $LOGFILE

VALIDATE $? "start user"

cp /home/centos/roboshopshell/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VALIDATE $? "coping mongodb.repo" 

dnf install mongodb-org-shell -y &>> $LOGFILE

VALIDATE $? "installing client" 

mongo --host mongodb.akhi.fun </app/schema/catalogue.js &>> $LOGFILE

VALIDATE $? "loading user data" 