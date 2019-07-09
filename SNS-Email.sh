#!/bin/bash

# Ask the user for his Topic name
echo Hello, What is your Topic Name?
read vartopic


#Create Topic
aws sns create-topic --name $vartopic
topic_arn=$(aws sns list-topics | grep arn | cut -d':' -f2,3,4,5,6,7 | sed 's/"//g')


#Create Email Subscription
# Ask the user for his Topic name
echo What is your subscribe Email?
read varmail
aws sns subscribe --topic-arn $topic_arn --protocol email --notification-endpoint $varmail

#Integrate ASG With SNS Topic
while true
do
 read -r -p "Are You Need To Integrate SNS Topic With ASG? [Y/n] " input

 case $input in
     [yY][eE][sS]|[yY])
echo What is your Autoscaling Group Name?
read var_asg
aws autoscaling put-notification-configuration --auto-scaling-group-name $var_asg --topic-arn $topic_arn --notification-type autoscaling:EC2_INSTANCE_LAUNCH autoscaling:EC2_INSTANCE_LAUNCH_ERROR autoscaling:EC2_INSTANCE_TERMINATE autoscaling:EC2_INSTANCE_TERMINATE_ERROR autoscaling:TEST_NOTIFICATION
 ;;
     [nN][oO]|[nN])
 echo "Script Finished Check AWS Console"
 exit
        ;;
     *)
 echo "Invalid input..."
 ;;
 esac
done
