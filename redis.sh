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

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y

VALIDATE echo "installing remi redis"

dnf module enable redis:remi-6.2 -y

VALIDATE echo "enabling redis"

dnf install redis -y

VALIDATE echo "installing redis"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf & /etc/redis/redis.conf

VALIDATE echo "enabling remote connections"

systemctl enable redis

VALIDATE echo "enabling redis"

systemctl start redis

VALIDATE echo "starting redis"