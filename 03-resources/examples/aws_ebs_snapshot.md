## In this we are going to study about the "EBS SNAPSHOT" What it is?

This is the most important concept. You need to take it very seriously.

So I request you to please follow me whatever I am teaching you.

1. What is an EBS Snapshot?

   An Amazon EBS Snapshots is a point-time backup of an EBS Volume.

   It allows us to preserve the data stored on an EBS volume so that the data can be later be used to create another EBS volume.

   "we can it is a bluprint of existing EBS."

Like this:

           EBS Volume
              |
          snapshots
              |
        Backup / Recovery
              |
        New Ebs Volume

1.1 Why Do we need Snapshots?

An EBS volume is the storage that an application actively uses.

A Snapshot provides a way to presevre that storage data seperatley.

For example:

      EC2
       |
    EBS Volume
       |
    Application Data
          |
          | Snapshot
          |
      EBS Snapshot
          |
      Point-in-time backup

    If the original volume is lost or we need another volume containing the captured data, a new EBS volume can be created from the snapshot

1.2 Simple Difference

      EBS Volume
       - This is the active storage used by EC2

      Snapshot
      - This is point-in time backup of the volume

1.3 Important Concept

     A snapshot is not the same thing as an EBS volume.

     EBS Volume
        |
     Actual block storage
        |
     Can be attached to EC2


     EBS Snapshot
         |
     Point-in time backup
         |
     can be used to create an EBS Volume.

This distinction is important when working with terraform because Terraform manages the volume and snapshots as different AWS Resources.

## 2. Why Do we Need EBS Snapshots?

    EBS snapshots are mainly used to preserve the data of an EBS Volume so that it can be recovered or used again when needed.

2.1 Backup

A snapshot provides a backup point for an EBS volume.

          EBS Volume
              |
          Snapshot
              |
         Backup Point

If the original has a problem, the snapshots can be used as a recovery source.

2.2 Recovery

Snapshot can be used to creare a new EBS volume containing the data captured by the snapshot.

        EBS snapshot
             |
        New EBS volume
             |
       Attach to EC2

This provide a way to recover storage without depending on the original volume.

2.3 Data Protection

Snapshots provide an additional copy of important volume data.

     for example:

           original EBS volume
                   |
             Application Data
                   |
              Snapshot


          If the original volume is accidentally deleted or becomes unavailable, the snapshot can provide a recovery point.

2.4 Creating Additional Volumes.

A snapshot can also be used as the starting point for creating another EBS volume.

     For example:

                Original Volume
                       |
                    Snapshot
                       |
                 -------------
                |             |
            Volume 1       Volume 2

    This can be usefull when another volume needs the same data as the original.

If i tell you this in a one line:

       EBS snapshots provide a backup and recovery mechanism for EBS volumes and can aslo be used to create additional volumes from a captured point in time.

## 3. How EBS Snapshot Work

An EBS Snapshot captures the data of an EBS volume at a particular point in time.

                  OR

An EBS Snapshot is a backup of our EBS Volume at a specific moment in time.

Let me explain you some words meaning:

1.  Point-in time : A specific moment (eg, 2:30 PM on Monday)
2.  Captures data. : Everything on the volume at that moment
3.  Backup : A copy we can restore from later.

    The basic flow:

           EBS Volume
               |
           EBS Snapshot
               |
          Point-in time Backup
               |
           Snapshot
               |
        create New EBS Volume
               |
            Attach to EC2

3.1 Creating a snapshot

Suppose we have:

      EBS Volume
      Size : 20 GiB
      Data : Application Data

We create a snapshot:

     EBS Volume
         |
      Snapshot

The snapshot represents the volume's data at that point-in time.

The original EBS Volume continues to exist and can continue to be used.

3.2 Snapshot as a recovery Source

If we need to create another volume from the snapshot:

           EBS Snapshot
               |
           New EBS volume
               |
           Attach to EC2

The new volume can then be used as storage for an EC2 instance.

3.3 Incremental Snapshots

    EBS snapshots are incremental after the first snapshot.

    This means the first snapshot saves everything. Every snapshot after that only saves what changed since what changed since the last snapshot.

Conceptually:

          First snapshot
               |
          Initial data
               |
          Second snapshot
               |
         Only changed data is captured
               |
         Third snapshot
               |
         New changed are captured

So we do not need to think of every snapshots as a completely independent full copy of the volume's data.

We don't need to worry about how snapshots are stored or how they connect to each other. AWS handles all of that behind the scenes.

The One-Liner:

      "First snapshot = everything. Every snapshot after = only what changed. This saves storage, time and money."

      Incremental = Only changes are saved.

3.4 Snapshot Does not automatically restore the volume.

    Creating a snapshot does not automatically create another EBS Volume.


      Snapshot Created
            |
      Snapshot exists
            |
      No new volume automatically created

If we need a new volume, we explicitly create one from the snapshot.

     Snapshot
        |
    Create Volume
        |
    New EBS Volume

SO lastely:

     " A snapshot is a point-in time backup of an EBS Volume. It can later be used as a source of creatinf another EBS Volume. "

## 4. Important concept

4.1 Snapshot

A snapshot is a point-in time backup of an EBS Volume.

       EBS Volume
          |
       Snapshot

The original volume and the snapshots are separate resources.

Why they are seperate resources:

     Concept            Original Volume                Snapshot

     What it is           -   storage we use      -       Backup of that storage

     Where it lives       -   AWS (attach to EC2) -    AWS S3 (stored separately)

     Can you write to it? -  YES                  -     NO (read-only)

     Can you delete it?   -  YES                  -     YES (independently)

     Purpose	           -  Run your application -	 Backup/restore

4.2 Point-in time Backup

A snapshot represents the state of the EBS volume at the time the snapshot was created.

Suppose:

        Time ---------------------->

        10:00      11:00       12:00
        |
        |
         --> Snapshot
               capture the data at this point of time

Once a snapshot is created, it captures a frozen moment in time. Any changes you make to the original volume after that do NOT affect the snapshot. The snapshot stays exactly as it was.

     Time -------------------------->

     10:00        11:00        12:00
      |
      |
       --- Snapshot
           captures data at 10:00

     At 11:00: You change a file
               Snapshot still shows 10:00 data

     At 12:00: You delete a file
               Snapshot still shows 10:00 data

Let me Explain you by an example:

At 10:00 AM - we create a snapshot

    Volume has:
      | -- File1.txt
      | -- File2.txt
      | -- database.db

    Snapshot captures: File1, File2, database.db

At 11:00 AM - I make changes in File2.txt

    Volume has:
      | -- File1.txt (same)
      | -- File2.txt (changed)
      | -- database.db (same)

    Snapshot still shows: File1.txt, File2.txt (same original like at 10:00 AM), database.db

At 12:00 PM - I delete the file File1.txt

    Volume has:
      | -- File2.txt (changed)
      | -- database.db (same)

    Snapshot still shows: file1, file2 (ORIGINAL), database.db

The Snapshot never changes.

      --------------------
     | Snapshot = frozon  |
     | Volume   = Changes |
      --------------------

4.3 Incremental Snapshot

After the first snapshot, subsequent snapshots are incremental.

          First snapshot
               |
           Initial data
               |
          Second snapshot
               |
          Chnage since previous snapshot
               |
          Third snapshot
               |
          Further changes

    This allows AWS to efficiently manage snapshots storage.

4.4 Snapshot -> EBS Volume

    A snapshot can be used to create a new EBS Volume.

      EBS Snapshot
          |
      New EBS Volume
          |
      Attach to EC2

Important:

    A snapshot is just a backup. You cannot attach it directly to an EC2 instance. You must first create a volume from it, then attach that volume.


     The correct flow:

                   EBS Snapshot
                       |
                       |  create volume from snapshot
                       |
                  EBS Volume (Active storage)
                       |
                       | Attach to EC2
                       |
                   EC2 instance
                       |
                       |
                       |
                        --- Can now use the stoarge

Step 1: Snapshot already exists (or create one)

Step 2: Create volume from snapshot

    resource "aws_ebs_volume" "from_snapshot" {
     availability_zone = "us-east-1a"
     snapshot_id       = aws_ebs_snapshot.example.id
     size              = 20
    }

Step 3: Attach volume to EC2

      resource "aws_volume_attachment" "attach" {
          device_name = "/dev/sdf"
          volume_id   = aws_ebs_volume.from_snapshot.id
          instance_id = aws_instance.web.id
      }

The One-Liner:

        "Snapshot = backup. You cannot attach it directly. You must create a volume from it first, then attach that volume to EC2."

4.5 Snapshot and source Volume

Creating a snapshot does not remove or replace the original EBS Volume.

     Original EBS Volume
             |
             |
              -- Snapshot

    Both can exist idenpendently.

    The original volume can continue serving an application while the snapshot is retained as a recovery point.

4.6 Snapshot Deletion

A snapshot can be deleted when it is no longer required.

However, Snapshots may be part of chain of incremental snapshots, so deletion should be considered carefully.

     Incrementals Means = "Only what changed sice last time."

For production environments, snapshot retention should normally be based on a defined backup and recovery requirement rather than deleting snapshots randomly.

The last key point to remember:

      An EBS volume is a point-in time recovery copy of an EBS volume. it can be retained independently and used to create a new EBS volume when required.

## 5. Terraform resources

Now we are going to see actuall work how to make snapshop in terraform.

I request you to please be more focused here.

So, Terraform provides the "aws_ebs_snapshot" resource to create and manage an Amazon EBS Snapshot.

An EBS Snapshot is created from an existing EBS volume. Therefore, Terraform needs to know which EBS volume should be used as the snapshot source.

The Terraform resource is:

     resource "aws_ebs_snapshot" "my-snapshot" {
        volume_id = aws_ebs_volume.my-snapshot.id
     }

5.1 Resource Structure

Basically the general structure is looking like this:

        resource "aws_ebs_snapshot" "Any-prefered-name" {
            volume_id = <EBS_VOLUME_ID>
        }

There are three importants parts:

1.  Resource

          resource

    The resource block tells the terraform that we want to create an manage an infrastructure resource.

2.  aws_ebs_snapshot

           aws_ebs_snapshot

    This is the AWS provider resource type used to manage an EBS snapshot.

3.  Any-prefered-name

          Any-prefered-name

    This is the local terraform name assigned to the snapshot.

    It is used when referring to this snapshot elsewhere in the terraform configuration.

5.2 Volume_id

This is the most important arguments:

     volume_id = aws_ebs_volume.local-terraform-name.id

volume_id specefies the EBS Volume from which terraform should create the snapshot.

For example:

      resource "aws_ebs_volume" "My-volume" {
        availability_zone = us-east-1a        size              = 50 GiB
        type              = gp3
      }

      resource "aws_ebs_snapshot" "My-snapshot" {
        volume_id = aws_ebs_snapshot.My-snapshot.id
      }

Terraform first create the EBS Volume.

AWS assign the volume_id to the EBS Volume.

Like:

     vol-0344455bdhdbfjffhh0

Terraform then used that ID for the snapshot:

    EBS Volume
    vol-0344455bdhdbfjffhh0
           |
           | volume_id
           |
     EBS snapshot

5.3 Resource Reference

    Resource Reference means how terraform connects one resource to another.  it tells the terraform use the value from that resource here.

This Expression:

      aws_ebs_volume.My-snapshot.id

is a terraform resource reference.

it means:

       aws_ebs_volume
            |
            |
             -- My-snapshot
                   |
                   |
                    -- id

Terraform retrieves the ID of the EBS Volume created by:

      resource "aws_ebs_volume" "My-volume"

And passes that ID to:

       volume_id

    This is preferable to manually hardcoding an AWS volume ID because terraform can track relatioship between the resources.

5.4 Implicit Dependency

    An implicit dependency is a relationshp terraform automatically detects when one resource references another. You don't have to tell Terraform about it - it figure it out on its own.

How it works:

When you write this:

       resource "aws_ebs_snapshot" "My-snapshot" {
        volume_id = aws_ebs_volume.My-snapshot.id
       }

Terraform see the reference (aws_ebs_volume.My-snapshot.id) and understands:

       "The snapshot depends on the EBS Volume because the snapshot configuration references the volume."

The Dependency

        aws_ebs_volume.My-volume
                   |
                   | .id
                   |
        aws_ebs_snapshpt.My-snapshot


    Resource = aws_ebs_My-snapshot

    Depends on = aws_ebs_My-volume

Why this matters:

      Terraform knows that the volume must exist before the snapshot can be created.

We cannot create a snapshot of a volume that doesn't exists yet. terraform understands this automatically.

The expected execution order is:

       1. Create EBS Volume
                |
       2. Obtain EBS Volume ID
                |
       3. Create EBS snapshot

You normally do not need to manually specify depends_on for this relationship.

5.5 Complete Example

A simple configuration can obtain both the EBS volume and its snapshot:

         resource "aws_ebs_volume" "My-volume" {
            availability_zone   = us-east-1a
            size                = 20 GiB
            type                = gp3

             tags = {
                Name = "example-volume"
             }
         }


         resource "aws_ebs_snapshot" "My_snapshot" {
            volume_id = aws_ebs_volume.My-volume.id

            tags = {
                Name = "example-snapshot"
            }
         }

The infrastructure relationship is:

         ----------------------
        |     EBS Volume       |
        |                      |
        |  size : 20           |
        |  Type : gp3          |
        |  AZ   : us-east-1a   |
         ----------------------
                    |
                    | volume_id
                    |
         ----------------------
        |     EBS snapshot     |
        |                      |
        |  Point-in-time copy  |
        |                      |
         ----------------------

## Important Arguments

As we already saw the argument for snapshot, but let focus them again just to remember.

The aws_ebs_snapshot resource uses arguments to define how the EBS snapshot should be created.

The important arguments are:

     Arguments         Purpose

     Volume_id        Specifies the EBS Volume from which the snapshot is created
     description      Describes the purpose or content of the snapshot
     tags             Adds metadata to the snapshot

6.1 volume_id

This is the most important argument.

it specefies which EBS volume should be used as the source for the snapshot.

Example:

       volume_id = aws_ebs_volume.My-volume.id

The relationship is:

        EBS volume
           |
           | .id
           |
        volume_id
           |
           |
        EBS snapshot

Terraform gets the ID of the EBS volume and passes it to the snapshot resource.

6.2 Description

The description argument can be used to describe the snapshot.

Example:

      description = "backup of the application data volume"

This helps identify the purpose of a snapshot, especially when an environment contains many snapshots.

6.3 tags

tags can be used to add metadata to the snapshot.

Example:

      tags = {
        Name = "application-backup"
        Environment = "dev"
      }

    Tags can help with identification, organization, automation, and cost management.

6.4 Basic configuration

A simple snapshot configuration can therefore look like:

      resoruce "aws_ebs_snapshot" "My-snapshot" {
        volume_id = aws_ebs_volume.My-volume.id
        description = "Backup of application volume"

        tags = {
            Name = "Application-snapshot"
        }
      }

The important relationship is:

       aws_ebs_volume.My-volume
                |
                | .id
                |
       aws_ebs_snapshot.My-snapshot

Key Point

       volume_id connects the snapshot to the EBS volume that terraform should snapshot.

Because the volume_id references another Terraform resource, Terraform can automatically understand the dependency between the volume and the snapshot.

## 7. Terraform Behavior

In this we will going to see the Terraform behavior, How terraform behaves.

Terraform uses the configuration, state,and actual AWS infrastructure to determine what needs to happen to the EBS Snapshot.

7.1 Snapshot Does Not Exist

If the snapshots is defined in the terraform configuration but does not exists in terraform state or AWS, Terraform plans to create it.

         Configuration
              |
         Terraform Plan
              |
         Snapshot does not exist
              |
         + create snapshot

Example:

- resource "aws_ebs_volume" "My-snapshot" {
  volume_id = "Vol-xxxxxxx"
  }

- means Terraform plans to create the resource

7.2 Terraform Tracks the snapshot

After:

      Terraform Apply

Terraform records the snapshot in its state:

          Terraform Configuration
                   |
                   |
                 Apply
                   |
                   |
                AWS Snapshot
                   |
                   |
             Terraform state

Terraform can then compare the desired configuration with the existing resource during future terraform plan operations.

7.3 Changing volume_id

What happen when you change the volume_id.

If the source volume changes. Terraform may need to REPLACE THE SNAPSHOT because the snapshot represents a backup of a specific volume.

       Old Notebook (Volume A)
           |
       Photocopy (snapshot from volume A)
           |
       New Notebook (Volume B)
           |
       New Photocopy (Snapshot from Volume B)

The old photocopy was of volume A. If you now want a snapshot of Volume B, You must create a new one.

Why this happens:

     Reason                                   Explanation

     Snapshot is tied to a volume           It's copy of that specific volume

     changing the source = new snapshot     The old snapshot can't magically become a copy of the new volume

     Terraform detects this                  It knows the snapshot must be created

What terraform will show:

    terraform plan

       # aws_ebs_snapshot.My-snapshot must be replaced
       -/+ resouce "aws_ebs_snapshot" "My-snapshot" {
         ~ volume_id = "vol-12345" -> "vol-67890" # forces replacement
       }

       Plan: 1 to add, 0 to change, 1 to destroy.

    Translation: "I will destroy the old snapshot and create a new one."

7.4 Changing Description or Tags

changes to metadata such as:

      description = "updated backup"

or:

     tags = {
        Name = "updated-snapshot"
     }

are evaluated by Terraform during terraform plan.

The Key Question:

      Can Terraform update the snapshot in place, or does the change require replacement?

      change                What happens

      Description           Usually updated in-place
      Tags                  Usually updated in-place
      Volume ID             Forces replacement (-/+)

The One-liner:

      "Description and tags = update in-place. Volume ID = replace. Always check the plan."

7.5 Important Backup Consideration - Documentation

    The Key point

       An EBS Snapshot backup data. Do not treat it like a disposible resource.

Before Destroying or Replacing a Snapshot

    Always ask these questions:
 
     Question              	               Why It Matters

     Is this snapshot still required?      Do we need it for recovery?
     Is it being used for recovery?        Is someone depending on it?
     Is it the only backup available?      If yes, deleting means data loss
     Will destroying it cause data loss?   What is the impact?

  Always think as the production mindset:
     
     "Do not treat snapshot resource like disposable resources without first understanding their backup role."

  You just need to follow some approach: 

  First I will tell you Wrong approach : -

  Wrong Approach 

  1. "It's just a snapshot, ----  delete it"
  2. "Terraform will handle it"
  3. "I'll create another one"

  Right Approach

  1. "Is this snapshoy needed for recovery?"
  2. "What happens to that data?"
  3. "Is this the only backup?"
  

  The One-Liner:
      
      "Snapshot are backups. Before destroying one, ask: Do we need it? Is it the only backup? Will data be lost?"



## 8. What happen when Configuration changes?

   Terraform compares the updated configuration with the existing state and infrastructure, then determines the required action. 

8.1 Changine description
  
  If only the snashot description changes, terraform evaluates the change during terraform plan.
      
       description = "Updated application backup"
  
  Terraform shows whether the existing snapshot can be updated or needs replacement. 

8.2 Chaning tags
   
   for example:

      tags = {
        Name = "production-backup"
        Environment = "prod"
      }
    
    Terraform detect the metadat change during terraform plan and determines the required action. 

8.3 changing volume_id
  
   changing:
      
      volume_id = aws_ebs_volume.My-volume.id
    
   to another EBS volume changes the source of the snapshot.

   Conceptually:
       
          OLD Volume
             |
             |
          OLD Snapshot
             |
             |
          New Volume 
             |
             |
          New Snapshot
    
   This is an importanat change because a snapshot represents a backup of a specific EBS Volume. 


   Always inspect the plan before applying it. 


8.4 Removing the Snapshot from configuration 

   If the snapshot resource is removed from the terraform configuration while terraform still manages it. Terraform may plan to destroy the snapshot. 


            Configuration
                  |
            Snapshot removed
                  |
            Terraform plan
                  |
            Destroy snapshot 
    
   Because a snapshot can represent backup data, do not approve this without checking whether the snapshot is still required. 


8.5 Update vs Replacement vs Destroy

   Terraform plans can indicate different actions:
     

     Symbol               Meaning

     ~                    update in-place
     -/+                  Destroy and create
     -                    Destroy
     +                    Create

  For Example:
     
     ~ update in-place
     
     means terraform can modify the existing resource. 

     -/+ replace

     means terraform must destroy the existing resouce and create a new one.

     - destroy

     means terraform plans to remove the resouce.

  Most important key point: 

        "Never assume that a configuration change is harmless. Run terraform plan and understand whether Terraform will update, replace, create, or destroy the snapshot before applying the change."


## 9. Practical Example

   In this section w'll see the practical example of EBS snapshot "aws_ebs_snapshot"

9.1 Create the EBS Volume 

     resource "aws_ebs_volume" "My-volume" {
        availability_zone = "us-east-1a"
        size              = 20
        type              = "gp3"
        encypted          = true

        tags = {
            Name = "application-volume"
        }
     }

9.2 Create the EBS Snapshot

  The snapshot reference the volume using the volume_id.

     resource "aws_ebs_snapshot" "My-snapshot" {
        volume_id = aws_ebs_volume.My-volume.id
        description = "backup of application volume"


        tags = {
            Name = "Application-snapshot"
        }
     }
 Terraform automatically understand that the volume must exixts before the snapshot because the snapshot references:
    
    aws_ebs_volume.My-volume.id

  The dependency is therefore:

         EBS Volume
            |
         Volume_id
            |
        EBS Snapshot

9.3 Run Terraform Plan 
    
  First, format and validate the configuration:
      
      terraform fmt
      terraform validate 

   Then create the execution plan:
     
      terraform plan
    
   You should see terraform planning to create both resources:
     
     + aws_ebs_volume.My-volume
    + aws_ebs_snapshot.My-snapshot

    Plan: 2 to add, 0 to change, 0 to destroy.

  The exact output will vary depending on the rest of your configuration. 


9.4 Apply the configuration
   
   if the plan is correct:
       
       terraform apply
  
  Terraform creates the volume first and then create the snapshot from that volume. 

                  Terraform
                     |
                 Creates EBS Volume
                     |
                 Volume ID generated
                     |
                 Create EBS Snapshot
                     |
                 Snapshot created


9.5 Verify Terraform state
 
  After  you run terraform apply and it executed successfully. 
  
   then you with the help of this command you can check the state of the terraform
         
          terraform state list 
    
   You should see resources similar to: 
      
      aws_ebs_volume.My-volume
      aws_ebs_snapsho.My-snapshot
    
   You can inspect the snapshot with:
     
     terraform state show aws_ebs_snapshot.My-snapshot

   This allows you to see the attributes terraform is tracking for the snapshot. 


9.6 verify the Dependency
   
   The important relationship is:

        aws_ebs_volume.My-volume
                 │
                 │ id
        aws_ebs_snapshot.My-snapshot

  The snapshot is created from the volume identified by:

        volume_id = aws_ebs_volume.My-volume.id

  This is an example of a resource reference creating an implicit dependency.

   Key Point:

     "In practice, Terraform creates the EBS volume first, uses its generated volume ID to create the snapshot, and then records both resources in Terraform state."


 ## 10. Common mistakes


10.1 Using The wrong Volume_id

  The snapshot must reference an existing EBS Volume.
      
      volume_id = aws_ebs_volume.My-volume.id
  
  A wrong resource reference will cause Terraform to fail during validation for planning.

10.2 Confusing a snapshot with a volume

  An EBS volume is active storage that can be attached to an EC2 instance. 

  A snapshot is a backup of a volume. 

       EBS Volume -> Active Storage
       EBS Snapshot -> Backup
  
  A snapshot cannot simply be treated as an attached storage volume. 

10.3 Assuming a snapshot Automatically Creates a Volume

 Creating a snapshot does not automatically create another EBS volume. 

The recovery flow is: 

         Snaphot
            |
         Create New EBS volume
            |
        Attach volume to EC2

10.4. Snapshotting a Non-Existent Volume
 
     If the referenced EBS Volume does not exist, terraform cannot create the snapshot from it. 

      Always verify the source volume and its dependency before applying the configuration.

10.5 Accidently Destroying a required Backup
  
  removing a snapshot from terraform configuration can cause terraform to plan its destruction.
   
   Before applying:
       
       terraform plan
   
   check carefully for:
        
        - destroy
   
   A snapshot may contain important  recovery data, so destruction should be intentional. 

10.6 Skipping terraform plan
   
    Do not immediately run:
        
        terraform apply
    
  without understanding the proposed changes.
   
   Use:
     
        terraform plan 
   
   to verify whether Terraform will:
    
    - create the snapshot
    - update metadata
    - replace the snapshot
    - destroy the snapshot
  
   key point:

        "The most important practice with EBS Snapshots is to understand what data the snapshot represents and carefully review Terraform's planned actions before creating, replacing, or destroying it."
    


## 11. Troubleshooting 

  This is very important concept for  cloud and devops role. You need to take this seriously. 

  When an EBS Snapshot operation fails, investigate the problem layer by layer instead of changing Terraform configuration randomly. 

11.1  Snapshot Creation Fails 

Always think that what can be the problem behind this why the snapshot creation is failed then do the following steps.
  
  start with:
      
      terraform plan -> it will show you all the plan what terraform will going to create from the configuration that you had wrote. 

      terraform apply 

   check the terraform  error message first:
     
   Then verify:
     
     - the source EBS volume exists 
     - the volume_id is correct
     - the AWS region is correct
     - the AWS credentials have sufficient permissions

11.2 volume_id is Invalid
  
    Here we checking whether the volume_id is actually valid or not.

   check the resource reference:
         
         volume_id = aws_ebs_volume.My-volume.id
    
   Make sure: 
     
     - the referenced resource name is correct
     - the volume exists
     - the volume ID belongs to the expected AWS environment 

   Terraform resource references should be preferred over manually hardcoding IDs.


11.3 Source volume is Unexpected
   
 Check the source from a specific EBS volume. 

      Volume 
      |
      | -- Volume ID
      | -- Availability Zone
      | -- State
      | -- Encryption 


Make sure Terraform is referencing the volume you actually intend to back up. 

11.4 Terraform Plan is Unexpected
    
   If terraform wants to create, replace, or display a snapshot unexpectedly, do not immediately apply it. 
 
  Run: 
      
      terraform plan
   
  Then inspect:
      
      Configuration 
            |
      Terraform State
            |
      AWS Infrastructure
            |
      Planned Change

 Determine which part differs before making a change. 

11.5  Snapshot Exists in AWS but Not in terraform state
   
Terraform manages resources through its state.

    If a snapshot already exists in AWS but Terraform does not know about it, Terraform may attempt to create another snapshot.

  check: 
    
    terraform state list
    
 If the snapshot is not listed, investigate the state and existing AWS resource before applying. 

 11.6 Terraform wants to Destroy a snapshot Unexpectedly

  if the plan shows:
     
     - destroy
 
  first determine why?
   
   check:
     
     terraform plan
    
  Look for:

    - the resource being removed from configuration
    - changed resource arguments
    - state differences
    - configuration changes that require replacement

  Because snapshots can contain backup data, do not approve unexpected destroy operation until you understand its impact. 

  11.7  Troubleshooting Flow
     
   Use this investigation order:
      
      Terraform Configuration 
               |
      terraform validate
               |
       terraform plan 
               |
        Terraform state
               |
         AWS EBS Volume 
               |
         AWS EBS Snapshot
               |
         IAM Permission / AWS API

 This prevents random changes and helps identify which layer is actually causing the problem.

  Key Point:
      
       "Troubleshoot EBS Snapshot problems systematically: verify the Terraform configuration, inspect the plan and state, verify the source volume and snapshot in AWS, and finally investigate permissions or AWS API errors."