!#/bin/bash
#Loop through all regions
for REGION in us-west-2 \
              us-east-2
do
#Pull down all volume IDs that are attached to instances with the Environment tag of "Production-A" grabbing only the desired output of the volume ID, and assigning to the VOLUMES array variable
VOLUMES=($(aws ec2 describe-instances --profile yam-yit --region $REGION --filters Name=tag:Environment,Values=Production-A --query 'Reservations[*].Instances[*].BlockDeviceMappings[*].{VolumeId:Ebs.VolumeId}' | grep -e 'vol-.*\w' -o))

#Loop through the volume array adding the Snapshots=True tags.
for VOLUME in $VOLUMES
do
echo Adding Snapshots=True tag to volume ID: $VOLUME
aws ec2 create-tags --profile yam-yit --region $REGION --resources $VOLUME --tags Key=Snapshots,Value=True
done

done



--------------------
#Jenkins Job
#!/bin/bash

#Loop through all regions
for REGION in us-west-2 \
              us-east-2
do
#Pull down all volume IDs that are attached to instances with the Environment tag of "Production-A" grabbing only the desired output of the volume ID, and assigning to the VOLUMES array
VOLUMES=$(aws ec2 describe-instances --region $REGION --filters Name=tag:Environment,Values=Production-A --query 'Reservations[*].Instances[*].BlockDeviceMappings[*].{VolumeId:Ebs.VolumeId}' | grep -e 'vol-.*\w' -o)
echo -------------------------------
echo Looping through region $REGION
echo -------------------------------
#Loop through the volume array adding the Snapshots=True tags.
for VOLUME in $VOLUMES
do
echo Adding Snapshots=True tag to volume ID: $VOLUME in $REGION
aws ec2 create-tags --region $REGION --resources $VOLUME --tags Key=Snapshots,Value=True
done

done
