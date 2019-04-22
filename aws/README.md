## aws-volume-tagging.sh

This script is used to pull down all AWS volumes that are tagged with a "Production-A", and then apply "Snapshots:True" for use with the AWS Snapshot Lifecycle manager in the EC2 console.

Replace the necessary tagging to fit your needs.  Also in this file is the slightly modified script for a Jenkins job.


## aws-snapshot-cleanup.sh

This script is used remove any orphaned snapshots. Lifecycle manager will keep snapshots around for volumes that have been deleted, and no longer processes cleanup.

This script will loop through any region that is specficied in the REGION array, and search for any snapshots older than 14 days with the Lifecycle Manager schdule tag of "Midnight"
