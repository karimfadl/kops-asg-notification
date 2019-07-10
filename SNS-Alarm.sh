#!/bin/bash

# Ask the user for his Topic name
echo Hello, What is your Topic Name?
read vartopic


#Create Topic
aws sns create-topic --name $vartopic
topic_arn=$(aws sns list-topics | grep $vartopic | cut -d':' -f2,3,4,5,6,7 | sed 's/"//g')


#Create Email Subscription
# Ask the user for his Mail
echo What is your subscribe Email?
read varmail
aws sns subscribe --topic-arn $topic_arn --protocol email --notification-endpoint $varmail

#Create Alarm For ASG Group Desired Capacity
while true
do
 read -r -p "Are You Need To Create Alarm with SNS Action For ASG? [Y/n] " input

 case $input in
     [yY][eE][sS]|[yY])
echo What is your Autoscaling Group Name?
read var_asg
echo What is Group Desired Capacity Threshold of ASG instances?
read var_threshold
aws cloudwatch put-metric-alarm --alarm-name $var_asg-Alarm --alarm-description "Check Kops ASG Group Desired Capacity" --metric-name GroupDesiredCapacity  --namespace AWS/AutoScaling --statistic Average --period 300 --threshold $var_threshold --comparison-operator LessThanThreshold --dimensions  Name=AutoScalingGroupName,Value=$var_asg --evaluation-periods 1 --alarm-actions $topic_arn
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
