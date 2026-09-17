## Now we discuss about the AWS EBS Volume. What is this and how is this work

# AWS EBS Volume

## 1. What is Amazon EBS?

    Amazon EBS (Elastic Block store) is a block-level storage service designed for use with Amazon EC2 instances.

    In Simple terms we can say that, EBS volumes behave like a virtual hard disk that we can attach with our EC2 instance. It provides persistent storage that remians available if the instance is stopped.

    For Example:

    EC2 Instance
        |
        |   (attached to)
        -> EBS Volume
               |
               -> 20 GB

    1. EC2 Instance - Provide compute resources (CPU, memory)

    2. EBS Volume - Provides persistent storGE (disk)

     You can tell  anyone in one line :-
        "EBS is AWS block storage that works like a virtual hard disk for EC2 and provides persistent storage."

## 2. Why do we need EBS?

THis is the main question that "Why do we need EBS"

    We Know that application that are running on EC2 instance need storage for things such as:
    - Application Data
    - Database Files
    - Logs
    - Uploaded Files
    - Operating system files
    - Backups

    So basically instead of treating storage as a part of server. AWS allow storage to be managed seperately using EBS.

     EC2 = Handles Compute
     EBS = Storage.

     This is why seperation allows stoarge to be managed independently from compute.

## 3. How EBS works

    First we understand What happens inside AWS and  inside the EC2 operating system

    if i tell you in the simple way:

     AWS Region
         |
    Availability Zone
         |
      EBS Volume
         |
    Attach to EC2
         |
    operating system see a block device
         |
     Filesystem
         |
    Application

Step 1. Create an EBS volume
Suppose we create:
EBS Volume
Size: 20 GiB
type: gp3
AZ: us-east-1a
Aws create a block storage volume in a us-east-1a
so it will looks like:

    us-east-1a
    |
     -- EBS Volume
         |
          -- 20 GiB

    There is no ec2 instance connected or attached yet.

    The volumes exists independently:

    So we need to attach the ec2 to this volume.

Step 2. Attaching EBS Volume to EC2

Now suppose we have:

EC2
AZ = us-east-1a

we attach:

EBS Volume
|
EC2

Now the relataionship becomes:

      us-east-1a
      |
      | -- EC2
      |
       -- EBS Volume
             |
             |
              -- attached to EC2

    <!-- Always remember EBS Volume and EC2 Instance must be in the same Availablity zone.  -->
     And creating and EBS Volume and attaching an EBS volumes are two different things.

Step 3. How Ec2 operating system detects the Volume.

    What Happens here:
     AWS attaches the storage at the hardware level. BUt linux OS needs to seeit.

     think like this:
        -> suppose you plug one USB drive into you system. The hardware is connected but the OS needs a time to detect it and assign it a name.

       In linux it appears like,
        /dev/nvme1n1

        How is the flow.

            AWS EBS
               |
            EC2 Hardware
               |
            Linus OS
               |
            /dev/nvme1n1    <-- Actually Linux see this device
    Here is one important thing is that device can vary depending on instance and OS.

Step 4. THe disk is not Automaticaly a filesystem.

So here is the most important concept.
Suppose linux sees:
/dev/nvme1n1
That doesn't means i can immediatly get into this by writing
cd /dev/nvme1n1

     Because it is not a directory or a filesystem.

     We need a  filessytem such as:
       "ext4 & xfs"
      These filesystem is used to organize the data.

    I know this getting very much for you. But just try to remeber it becuase this is the main things that happens.

    SO conceptually:

       EBS Volume
           |
       Block Device
           |
       Filesystem (ext4 & xfs)
           |
        Mount Point.

     For example:

         /dev/nvme1n1
              |
             xfs (File organizer)
              |
            /data (Mounting point)

    Now  an application can use:
      /data
     because it converts into a file or a directory by mounitng it.

Step 5. Application Uses the Storage.

Once the EBS volume is formatted and mounted, the application can use it like any normal folder

Application

/data
|
Filesystem (XFS)
|
Block Device (/dev/nvme1n1)
|
EBS Volume
|
AWS Storage Infrastructure

This gives us three layers.
Layer 1- AWS infrastructure

      EBS Volume
         |
    Attachement
         |
        EC2

Layer 2- Operating system

       Block Device
           |
     Partition (if used)
           |
      Filesystem
           |
       Mount Point

Layer 3- Application

        Application
            |
          Files
            |
           Data
    So,

       AWS
        |
        OS
        |
    Application

And Each layer has a different responsibility.

EBS Lifecyle -

1.  What Happens When EC2 is Stopped?

    If the EC2 is stopped for any reasons, then in this case RAM & CPU will stops compute. EBS Volume and its Data remain intact or we can say Data is still available.

        Before Stop:
          EC2 (Running)
          |-- CPU : Active
          |-- RAM : Active
          |
           -- EBS Volume(attached)
                 |
                  -- Data : Stored

          After Stop:
         EC2 (Running)
          |-- CPU : Inactive
          |-- RAM : Cleared
          |
           -- EBS Volume(Still attached)
                 |
                  -- Data : Stored

2.  What happens when EC2 is terminated?

    So, Basically this is very important to understand this.
    If the Ec2 is Terminated. The EC2 instance is deleted forever. What happens to EBS is actually depends on the configurations.

    There is a critical setting on deletion named "DeleteOnTermination"

    If DeleteOnTermination = true In this case EBS volume is deleted with the instance.
    if DeleteOnTermination = false In this case EBS volume will not delete or terminate.

    So it all depends on this small but important configuration.

    Let me show you with the Flow:

        EC2 Terminated
            |
            |-- If  DeleteOnTermination = true
            |           |
            |            -- EBS Volume -> DELETED
            |-- If  DeleteOnTermination = false
            |           |
                         -- EBS Volume -> REMAINS

        "-------GOLDEN RULE-------"
           Don't Memorize "EC2 terminated = EBS deleted"
           Not always, as we seen about configuration.

           ALWAYS DO - "I NEED TO CHECK THE VOLUME'S DELETION CONFIGURATION"
3.  What Happens If the EBS Volume Itself is Deleted?
   
    If the EBS volume is destroyed, the data on that volume is gone forever (unless you have a snapshot).

    Snapshot = A copy or we can say the backup of that data which is present in the volume.

                EC2 Instance
                    │
                 EBS Volume
                    │
                     --- Important Application Data
                            │
                            │ (Volume Deleted) 
                       Data → GONE 

   

## 4. Imprtant concepts
    
In this we do not need to memorize every AWS details. Just to understnand the concepts that affect architecture, performance, cost, reliabilty and terraform decissions. 

4.1 EBS Volume
    
 An EBS Volume is a actuall Block storage resource.
 
 The 5 Things Evey EBS Volume has: 

    Size              How much stoarge         20GiB
    Volume Type       How fast it is           gp3,io2,st1
    Performance       IOPS and throughput      3,0000 OPS, 125 MB/s
    Encryption        Is data encrypted?       Yes/No
    Availabilty Zone  Where it lives            us-east-1a,us-east-1b


Think:

     EBS Volume
      |-- Size
      |-- Volume type
      |-- Performance
      |-- Availabilty Zone

For example:
   
     Volume
     |-- 20 GiB
     |-- gp3
     |-- us-east-1a
     |-- Encrypted

 

## 5. EBS vs EC2

## 6. Availability Zones 

## 7. EBS Volume Types

## 8. Terraform Resource

## 9. Important Arguments

## 10. Terraform Behavior

## 11. What happens when configuration changes?

## 12. Practical Example

## 13. Common Mistakes

## 14. Troubleshooting

## 15. Interview Questions

## 16. Key Takeaways
