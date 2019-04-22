#!/bin/bash

FILTER="Name=tag:aws:dlm:lifecycle-schedule-name,Values=Midnight"
DATE=$(date -d '14 days ago' +%Y-%m-%d)
QUERY="Snapshots[?StartTime <= '$DATE'].{id:SnapshotId}"

#Loop through all regions
for REGION in us-west-2 \
              us-east-2
do
#Pull down all snapshot IDs that are tagged with the LifeCycle schedule tag of "Midnight"
SNAPSHOTS=$(aws ec2 describe-snapshots --region "$REGION" --filters "$FILTER" --query "$QUERY" --output text | grep -e 'snap-.*\w' -o)
echo -------------------------------
echo Looping through region $REGION
echo -------------------------------
#Loop through the snapshot and delete
for SNAPSHOT in $SNAPSHOTS
do
STARTTIME=$(aws ec2 describe-snapshots --filters Name='snapshot-id',Values=$SNAPSHOT | grep StartTime)
STARTDATE=$(echo $STARTTIME | cut -d":" -f 2 | cut -d 'T' -f 1 | cut -c 3-)
echo Snapshot ID $SNAPSHOT in $REGION is older than 14 days. Creation date is $STARTDATE. Deleting snapshot $SNAPSHOT.
aws ec2 delete-snapshot --snapshot-id $SNAPSHOT
done

done
