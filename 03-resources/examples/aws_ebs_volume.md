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
     |-- 125 MB/s
     |-- us-east-1a


4.2 Volume size
    
 Size detemines how much storage capacity the volume provides.

For example: 
   
    20 GiB
    50 GiB
    100 GiB
    500 GiB

 Guys listen here is one important take:
  
    size = How much data can i store?

  That doesnt't direclty mean 

    size = How fast is my disk? 
  
  So, Basically if the size of the disk is much like (500 GiB) then it does not mean  speed is also higher. Speed may be slower. 

  So that's where the concept like IOPS and throuhput comes in the picture. 

4.3 Volume Type
  
  The volume type determines the storage technology and performance characteristics.  

   "Speed and purpose" how fast our storage works. 

  SO lemme explain with the real life Analogy:
   
   Think of vehicles:

     1. Sports cars = Fast, expensive (for racing)
     2. Family car = Balanced , Affordable (for daily driving)
     3. Truck      = Slow, Huge load capacity (for movong goods)

   So like this only we have different EBS volumne type - different types for different needs. 

   The main two categories:

    
    SSD(Solid state Drive) ->     Fast,expensive  ->  Databases and Operating systems
    HDD(Hard Disk Drive)   ->     Slow, cheap     ->   Big data, archives, logs
    
 Now we are seeing the 6 types of volumes:
 SSD Types (Fast):
       
      Type         Name(nickname)          Best For  
      gp3          General Purpose         most workloads (3,000 IOPS and 125 MiB/s)
      gp2          Older general purpose   Older worloads,(low cost workloads )
      io2          High performance        Critical Databases(Oracle,SQL Server)
      io1          Older High performance  Databases
 HDD Types (Cheap & Big) :

     Type          Name(nickanme)           Best For
     st1           Throughput optimized     Big data, logs
     sc1           Cold Storage             Archive, Infrequent access.

GiB   = GibiByte
MiB/s = Mebibyte per second

If we need speed? 

    Then, Use gp3 or io2 for critical databases. 

If wee need cheap space?
  
    Then, Use st1 (throughput optimized HDD) for logs/big data, or sc1 for cold archives.

This is how our volume types is - You need to understand them carefully. 
Now,If someone says.
 -> "Create a 100 GiB gp3 volume"
  100 GiB -> Storage Space 
  gp3     -> Volume type(General Purpose)

4.4 IOPS

IOPS Means: Input Output Per Second. 
 
It represents that how many individual I/O operations storage can handle per second. 
 
 Imagine an Application making a lots of small reads/writes operations -
      
       Application
           |
          Read
           |
          Write
           |
          Read
           |
          Write
           |
          Read
           |
          Write
           |
         Storage

Here, is the most important concept -
 1. IOPS Measures - How many operations per seconds. Not how much data per second.
 2. IOPS Measures - Number of reads/writes per second. Not the size of each operation. 
 3. IOPS Measures - Tranasctions speed. Not the Throughput. 
      
      Transaction Speed means = Number of individual read/write request the storage can handle in one per seconds. 

      Throughput means =  Measure the actual volume of data transeferred per second. 
   

 IOPS by  Volume Type:
     
     Volume Type     Baseline IOPS                Max IOPS
        gp3              3000                      80,000
        gp2              3 IOPS/GiB                16,000
        io2              Provisioned               256,000
        st1              N/A Throughput based      N/A
        sc1              N/A Throughput based      N/A
 
 4.5 Througput 
   Throuhput is about how much data can be transeffered per unit of time. 
   

    And Usually measured in: 

         MiB/s


4.6 Availability Zone
  
  Every EBS Volume belongs to a specefic Availiablity Zone. 

  It means Every EBS volume belongs to a specific Availability Zone. We cannot access one EBS volume in a different zone. If I create an EBS in us-east-1a and want to access it in us-east-1b, it's not possible. I need to create another EBS volume in that particular zone.
   
    for example: 
     |--   us-east-1a
     |        |
     |         -- EBS Volume
     |
     |-- us-east-1b
     |       |
     |        -- EBS Volume
     |
     |
     |-- us-east-1c
     |      |
     |       -- EBS Volume

  An AWS volume is not a regional resource that can freely move between all AZ's 

   This creates an important design relationship
     
     EC2
      |
      |
       -- EBS
           |
           |
            -- SAME AZ 

  Suppose if you launch EC2 in a us-east-1c, You need to new choose your EBS volume for that EC2 instance in the same AZ in which you have your EC2 launced.

4.7 Persistence
  Persistence means the EBS volume exists independently from the EC2 instance's running state. 

  Lemme explain you in a simple Analogy:

    Think i have my laptop and an external hard drive:
    -> My laptop = EC2 instance 
    -> External hard drive = EBS Volume

    If i Turn off my laptop (stop EC2),the external hard drive still exists  with all the data.

    if i throw my laptop (terminate EC2), the external hard drive still may exists - but i need to check if it's set away thrown away too. 

Okay this below is the simple defination - Please read this also.

      "Persistence means our data will remain present in the EBS volume whether the EC2 instance is stopped or running—the EBS volume data will stay there. But in the case of EC2 termination, the data may be deleted if DeleteOnTermination is true. Otherwise not."

      DeleteOnTermination = True -> EBS data loss
       
      DeleteOnTermination = Falso -> EBS data remains. 
      
      "Persistence = Data stays when EC2 is stopped or running. On termination, check DeleteOnTermination—if true, data is deleted; if false, it stays."
       
       EC2 Running → EBS Data 
       EC2 Stopped → EBS Data 
       EC2 Restarted → EBS Data 
       EC2 Terminated → Check DeleteOnTermination
                          |-- true  → EBS Data 
                          |-- false → EBS Data 

4.8 Encryption 

  EBS encryption means the data stored on the volume is scrambled (encrypted) so that no one can read it without the proper key. 

  I know "scrambled" is more technical term for you. Lemme explain this for you. 

   Whenever Plaintext (readable information like a text, message,file or image) is scrambled into ciphertext (an unreadable, random-looking code) so no unauthorized person can read the information 

  The simple Analogy: 
    
     Think like you have a diary with a lock:
    -> you write your secrets in that diary (data)
    -> You lock with a key (encryption)
    -> Anyone who finds the diary can't read it without the key.
    -> Only you (or someone who have the key) can unlock it and read it.

 What Encryption protects:

 Layer               What happens
 At rest              Data on disk is encrypted
 In transit           Data between EC2 and EBS is enrcypted 
 Snapshots            Encrypted snapshots remains encrypted

 how it happen:
    
        Application 
            |
         EBS Volume
            |
        Encrypted Storage
            |
        Data is stored -> No one can read it without the key. 

  Now I will going to tell you the most important conecpt of encryption in AWS is KMS Keys. Please understand it carefully. 

    "So KMS keys are the encryption keys that AWS Key management service(KMS) create and manages to protect our data. "

    When, we set encrypted = true , AWS uses its KMS key to actually perform the encryption and decryption operations. 

Also there three types of KMS keys. 
    
    1. Customer Managed Keys: -
         
         This type of key is created and control by the user who is making these keys. "User" can rotate (change), disable, or delte it.
          
          But it cost us Monthly and the usage. 
    2. AWS Managed Keys: -
         
         AWS creates and manages the key for you - And you can use it but can't change it. 
 
    3. AWS Owned Keys: -
         
         This type of keys owned and managed  by the AWS itself. You never see these keys and it's free to use. 
  
  The One-Liner for you to make it more simple: 
       
       "
        CUSTOMER MANAGED = WE  CONTROL ,
        AWS MANAGED      = AWS CONTROL , 
        AWS OWNED        = AWS CONTROLS IT, BUT WE CAN'T SEE THE KEYS.
       "


4.9 EBS Attachment 
    
So, This is the concept where most of the students gets confused between EBS volume and  EBS attachment they think this the same concept, But technicaly it's not. 
These both are two different concept in AWS. 

Wait, let me explain in easy way. 
      
      Concept                 Definition
    
      EBS Volume      ->      The block storage resource itself. Exists  independently and can exists withour being attached to an EC2 instance. 

      EBS Attachemnt   ->      The Connection between EBS Volume and EC2 instance is called EBS attachment. It only exixts when a volume is connected to an instance. 

The relationship between them. 

         EBS Volume (Storage exists)
                   |
                   |
                   | <-- Attachment of both (Connection) 
                   |
                   |
             EC2 instance (Compute)

         - The volume is the storage.

         - And the attachment is the link  that makes volume available to the instance.


## 5. Terraform Resource
   
 In this section we'll see that how terraform actuall represents and manages an EBS volume. 

 From here you will get to know how to create a proper ebs volume and how to connect it to and EC2 instance all the things we discussed above. 
  
  Terraform uses the "aws_ebs_volume" resource to create and manage an Amazon EBS volume.

    The resource represents the actual EBS storage volume in AWS.

              Terraform Configuration
                       ↓
                aws_ebs_volume
                       ↓
               AWS EBS Volume

5.1 Resource Type
  
  In Terraform, a resource type tells Terraform what kind of infrastructure to create. The AWS provider resource type for every AWS service. 

        For EBS volumes, the resource type is:
         
           Resource "resource_type" "local_name_for_this_resource"{
              # configuration 
           }

           resource "aws_ebs_volume" "My-ebs" {
                     # configuration
            }

 Okay, I know many of you don't know about this syntax so let me break down this syntax for you in a simple way. 

      "Resource_type" = Tells terraform what kind of resource needs to make, in this example we write 
         
         resource_type = aws_ebs_volume -> So basically we are telling Terraform to create an EBS Volume.

      "Local_name" = It is the second name or we can say the local name for the resource that we are making. 
         
         local_name = My-ebs -> so, Now i can use this local name to call my resource elsewhere in my terraform configuration. you can write of your choice also . this makes the configuration more easy and readable.
          

The Resource Type (aws_ebs_volume) -

    The resource type defines what Terraform will create.
          aws → The provider (AWS)
          ebs_volume → The resource (EBS Volume)


How to Reference It.

 Once you defined all the configuration, you can reference the resource using: 

      aws_ebs_volume_My-ebs

    Refernece it like this:

     Reference                          Meaning
     aws_ebs_volume_My-ebs                The main entire resource
     aws_ebs_volume_My-ebs.id             It give the volume ID (generated by AWS)
     aws_ebs_volume_My-ebs.arn            It gives the ARN of the Volume

 5.2 What does the resource Represent?
   
   An aws_ebs_volume resource represents an EBS volume itself.
    
   It does not automatically mean that the volume is attached to an EC2 instance.

   The concepts are seperate: 

     EBS Volume
     |
     |
     |---- Storage Resource
     |
     |---- can exists independetly
    
  And in case if we want to connect the volume to an EC2 instance, that attachment is handled seperately. 

   Conceptually: 

     Terraform 
       |
       | -- aws_ebs_volume
       |         |
       |       EBS Volume
       |
       | --  Attachment
                  |
                 EC2
  I already told you this, That creating a storage and attaching storage are two different things or operations.

5.3 Basic Resource Structure

  A basic EBS resource follow this structure:

    resource "aws_ebs_volume" "My-ebs" {
    size               = .....
    type               = .....
    availability_zone  = .....
    encrypted          = .....
    }

 The exact values depend on the requirements of the infrastructure. 

  For example, a requirement might say:
    
     size              : 50 GiB
     volume Type       : gp3
     Availabilty_zone  : us-east-1a
     encrypted         : Enabled

5.4 Resource Arguments vs Resource Attributes

  First it is important to distinguish between arguments and attributes.

  Arguments :
   
    Arguments are values that we provide in the terraform configuration to tell terraform how the resource should be configured.
   
   For example: 
      
      size               : 30 GiB
      type               : "1o2"
      availability_zones : "us-east-1a"
      encrypted          : true

  Attributes:
     
    Attributes are value that terraform can  expose about the resource after it is created or observed. 

  For example:
       
      Volume ID 
      ARN
      Availability Zone
      Size
      Volume Type

  And these values can be usefull when another terraform resource need information about the EBS Volume. 

5.5 Resource Arguments we should understand. 
  
  Before writing the final terraform configuration, we should understand the "IMPORTANT ARGUMENTS SUPPORTED BY THE EBS_VOLUME". 
    
  You need to pay more attention to:
   
     size             : Defines the storage capacity
     type             : Define the EBS Volume type
     availability_zone: Defines the availability zone where the volume is created
     encrypted        : Check whether the volume is encrypted or not
     iops             : configured provisioned IOPS where supported
     throuhput        : Configure throughput where supported

     And, One important thing that
              
              Size              : (IF NOT USING SNAPSHOTS)
              availabolity_zone :
          is must required. 

5.6 using Variables :
 
   This is the most  topic, I request you to please pay attention to this. 

  You already know till now we are configuring  our values directly in the code (Hardcoded). But this is not the best way and efficient way to write our configuration.

  see, In past we wrote like this:

   size = 20 GiB

  But the main problem with this hardcoded value is:

      1. These value is difficult to reuse, if anyone want to use this resouce but they want different size so they have change its size always which is not a good practice in technical world. it costs you time. 

      2. Hardcoded values can be compromised, This is not the case for "SIZE".

       "Suppose you hardcoded your "availabilty_zone" in this case anyone see in which zone your "EBS_Volume" is created and compromise that."
        
      So, Instead of writing.

      size = 20 GiB
       
       we can define the vaiable:

         size = var.ebs_volume_size
      
      For example:
        
        variable "ebs_volume_size" {
          description = Size of the EBS Volume in GiB "
          type        = number
        }

       And:
       ebs_volume_size = 20
        
        In we doing like this then,
          
          The flow becomes: 

                     terrafomr.tfvars
                            |
                        variable 
                            |
                        aws_ebs_volume
                            |
                        AWS EBS Volume
    This makes the configuration easier to modify and reuse.

5.7 Example Configuration 
   
  A simple configuration can represent the following infrastructure requirement:

  Create an encrypted 20 GiB gp3 EBS volume 
  in Availability Zone us-east-1a.

     Terraform 
      
       resource "aws_ebs_volume" "My-ebs" {
        size               : 20 GiB
        type               : gp3
        availability_zone  : us-east-1a
        encrypted          : true
       }
    
    This tells terraform the desired configuration. 
   
  Terraform then compares this desired configuration with the infrastructure represented in its state and the actual infrastructure observed through the provider.

  If the volume does not exist, Terraform's plan will normally show that the resource needs to be created.


5.8 Resource creation vs Attachment 
  
  "CREATING RESOURCE IS NOT SAME AS ATTACHING IT"
   
   In terraform, creating an EBS Volume and attaching it to an EC2 instance are two seperate operations.

     resource "aws_ebs_volume" "example" {
         availability_zone = "us-east-1a"
         size              = 20
        type               = "gp3"
     }

   The configuration only creates the volume. It does not:
      1. Attach the volume to any instane
      2. configure the operating system
      3. Create a filesystem
      4. Mount the volume

  The complete flow :
     
     After a volume is attached to EC2, additional OS-level work may still be required:
           
            EBS Volume 
                |
          Attach to EC2
                |
       OS detect the block device
                |
            Filesystem
                |
              Mount
                |
        Application uses the storage
  

5.9 Professional Workflow
  
  When creating an EBS Volume with the terraform, do not start by blindly copying a resource block.
  
   Use This workdlow:

                 Requirements
                      |
              Indentify Resource
                      |
          Read Terraform Documentation
                      |
          identify Required Arguments
                      |
          Identify Required Optional Arguments
                      |
          Decide which value should be variables
                      |
          Write terraform configuration
                      |
               terraform fmt
                      |
               terraform validate
                      |
               terraform plan
                      |
                terraform apply
                      |
        The improtant skill is not memorizing the syntax.
                       |
        The important skill is being able to move from
                      |
              Infrastructure Requirement
                      |
              Terraform Documentation
                      |
               Correct Resource
                      |
              Correct Arguments
                      |
              Terraform configuration
  
  This workflow can be reused for other resources also such as VPC,EC2,RDS,IAM,S3, and many others. 


## 6. Important Arguments
 
 Now we are discussing about the important arguments. 

   The ebs_volume_volume resource uses arguments to define the configuration of an EBS Volume. 

   Think of arguments as the settings you choose when creating a volume. 

   The main arguments we need to understand are: 

        Argument                          Purpose 
        
        size                             Defines the Volume capacity
        type                             Defines the EBS Volume type
        availability_zone                Defines where  the volume is created
        encrypted                        Enables or disables encryption
        iops                             Defines provisioned IOPS where supported
        thoroughput                      Defines throughput where supported

6.1 Size

  Defines the storage capacity of the volume. 

     size = 20
  
  This creates a volume with 20 GiB of capacity.

     size -> Defines how much data can be stored. 

  Important : 
     
     Size represents capacity, not directly the performance of the volume. 

6.2 Type
   
   Defines the EBS volume type.

        type = "gp3"
   
   Common type include:
     
        "gp3"
        "gp2"
        "io1"
        "io2"
        "sc1"
        "st1"

    Important: 
        
        The selected type effects the volume's performance characteristics and which performance arguments can be used. 

6.3 availability_zone

  Define the Availability Zone where the EBS volume will be created. 

       availability_zone = "us-east-1a"
  
  Important: 

        The EBS volume belongs to that Availability Zone, so it normally needs to be attached to an EC2 instance in the same Availability Zone.

6.4 Encrypted 
 
 Contorl whether the EBS Volume is encrypted.

     encrypted = true

  true means -> encryption enabled

  Important:
       
       "If your infrastructure needs encryption, configure it yourself. Never assume it's already enabled."


6.5 IOPS

   Defines provisioned IOPS for volume type that support configurable IOPS. 

      iops = 5000

  IOPS represents the number of input/outputs operation the storage can handle per second. 

  Important: 

       "Whether you can use this argument—and what numbers you can put—depends on the volume type you picked. So check first."


6.6 Throughput
    
   Define the storage throughput where supported.

     throughput = 250
  
  Throughput represents the amount of data that can be transferred per second. 

            IOPS
             |
     Number of I/O operations

        Throughput
            |
     Amount of data transferred
   
   Important:
             
       "This argument may not work with every volume type. The volume type decides if you can use it and what numbers you can put."


6.7 Basic example
    
  Putting the important arguments together.
        
        resource "aws_ebs_volume" "example" {
             size              = 20
             type              = "gp3"
             availability_zone = "us-east-1a"
             encrypted         = true
            }

  This represents: 
                       
                       20 GiB
                         +
                        gp3
                         +
                     us-east-1a
                        +
                      Encrypted

   Important Rule :
         
        " Do not assume that every argument can be used with every EBS volume type."
        
Before adding performance-related arguments such as iops or throughput, check whether they are supported by the selected volume type and what values are valid.
           

## 7. Terraform Behavior

In this we are ging to check how Terraform behaves after we define the EBS resource. 

  So, Basically we are  creating an EBS volume from the staring and we are thinking that when we create EBS Volume it directly gets created. But it's not. 

     Terraform does not immediately creates an EBS volume when we write the resource block. 

     it first compares:

         Terraform Configuration  (main.tf)
                   |
            Desired state

                  VS

        Current infrastructure (AWS)
                  |
            Actual State

    
 FIRST TIME:
┌─────────────────┐
│ Desired State   │ (main.tf)
└────────┬────────┘
         │
         │ COMPARE
         │
┌────────▼────────┐
│ Actual State    │
│ (AWS - nothing) │
└────────┬────────┘
         │
         ▼
    terraform apply
         │
         ▼
┌─────────────────┐
│ State File      │ ← Created NOW!
│ terraform.tfstate│
└─────────────────┘


SECOND TIME:
┌─────────────────┐
│ Desired State   │
└────────┬────────┘
         │
         │ COMPARE
         │
┌────────▼────────┐
│ State File      │
│ (now exists)    │
└────────┬────────┘
         │
         │ COMPARE
         │
┌────────▼────────┐
│ Actual State    │
│ (AWS)           │
└────────┬────────┘
         │
         ▼
    terraform plan
         │
         ▼
   "No changes"
    
    "First run: Terraform compares code vs AWS (no state file yet) → creates everything → saves state. Second run: Compares code vs state vs AWS → decides what to change."

   
## 8. What happens when configuration changes?
    
   Let's Start with What You Already Know

  You know that Terraform compares your desired configuration with the actual infrastructure.
  
   
  But here's the interesting part:

     What happens when you change something that already exists?

   The three posibilities. 
    
    When you change an EBS volume configuration, Terraform can respond in one of three ways:

     1. No Change
        |
     Already matches desired state → Nothing happens

    2. Update in-place (~)
        |  
       Existing resource can be modified → Same volume, updated

    3. Replacement (-/+)
        |
       Existing resource must be replaced → Old destroyed, new created  


8.1 Increasing Volume Size

  Let's say you have this:

     hcl
    resource "aws_ebs_volume" "example" {
    size = 20
     }
  
  You need change it to:

    resource "aws_ebs_volume" "example" {
    size = 50
    }
  
  Terraform detects the differemce:
      
      20 GiB
         |
      50 GiB

  For EBS, Increasing the volume size can generally be performed without replacing the volume. 

Terraform may therefore show:

    ~ update in-place 

This means the existing volume is modified rather than destroy and recreated. 


8.2 Decreasing the volume size

  Now suppose the existing volume size is: 

     size = 100
  
  And we need to change it to:
    
     size = 50
   
  In this case EBS cannot simply reduced the size in place:

    Therefore, this is not the same situation as increasing the size. 
  
  So, What we need to do here is?

    100 GiB Volume
         |
    Create smaller volume (50 GiB)
         |
    Move required data
         |
    Use new volume

 Here we are using, Migration Strategy.

     1. Create a smaller volume (50 GiB)
     2. Attach it to an EC2 instance
     3. Copy the required data from the old volume to new volume
     4. Detach old volume and attach new volume to the application
     5. Delete old volume (after verifying data)
    

  One critical warning:

       Never assume that changing size = 100 to. size = 50 will safley shrink the existing volume. 

  But Why?     

        - AWS does not support shrinking EBS volumes in-place
             
        - Terraform will destroy the old volume and create a new one
        
        - All data on the old volume will be lost unless you migrate it first

What You Must Do Before Applying:

 1. Do I have a snapshot?	 

        why it matters: Can i restore if somehing went wrong

2. Have I migrated the data?
         
         why it matters: Is the data safe on the new volume?

3. Is the Application ready?
         
         Why it matters: Will it break if the volume is replicated? 

   "EBS cannot shrink. Decreasing size = -/+ replacement = migrate data first or lose it."

8.3 Changine the Volume Type:

  if anyone wants to change its volume type:
    
    For example:
       
       type = "gp3"
            |
            To
      type = "io2"

  Terraform check the resource behaviour definded by the AWS Provider and determines whether the change can be performed in place or requires replacement 

  Therefore, always check:
       
       terraform plan

 before applying the change.

 The plan is the source of truth for what terraform intends to do. 

 8.4 Changing the Availability Zone
   
   if anyone want to change the availability zone of volume. 

   Like The volume is in: 

      availibility_zone = "us-east-1a"

   To
      
      availability_zone = "us-east-1b"
  
  An EBS Volume belongs to a specific availability zone.

  It cannot simply be moved between Availability Zones like changing a string value.

 A change like this can therefore require the existing volume to be replaced or migrated.

          us-east-1a
               |
          Existing EBS Volume 
               |
          us-east-1b
               |
          New EBS Volume

  Because persistent storage contains data, such changes must be handled carefully.


8.5  ~ vs -/+ 

Let's understand these symbols:
   
   When you run terraform plan, Terraform uses symbols to show what it intends to do. 

  You already know: 

    Teraform compares desired state with actual state.

    Then it creates a plan

   But what do the symbols in the plan means?
      
       1. ~ : we call it update in-place 

         what does update in-place means that it modify the existing resource. 

      2. -/+ : we call it replacement 

         What it does, that it destroy the old, and create a new one 
         
           - is for destroy old one
           + is for create new one


8.6 The Golden Rule

   Before applying any change to an EBS resource:
     
  Always Run this command first:
       
         terraform plan 
  Because terraform will tell you exactly what is plans to do-before it does it.

  Then carefully check whether Terraform plans: 
    
    NO change
     ~ update in-place
     -/+ replacement
  
  for persistent storage, never look only at what value changed. 
  
  Also check for: 

     what will happen to the exixting data?
    
  "Don't just ask what changed—ask what happens to the data. A small change can destroy everything."

## 9. Practical Example
 
   Now this is time when i will show you some practical concepts:

   Let's create an EBS Volume using terraform:

9.1 Requirement

  We need to create:

  EBS Volume
  |
  | -- Size: 2- GiB
  | -- Type: gp3
  | -- Availiability Zone : us-east-1a
  | -- Encryption : Enabled

  These are the requirements for creating an EBS Volume. 

9.2 Define Variables

 First we have to define the variables for this volume so that we can use them in other volume also

  file name is "variables.tf"

    variable "ebs_volume_size" {
    decsription = "Size of the volume"
    type        = number
    }

    variable "ebs_volume_type" {
    description = "EBS Volume type"
    type        = string
    }

    variable "ebs_availability_zone" {
    description = "Availability Zone for the EBS Volume"
    type        = string
    }
    
    variable "ebs_encrypted" {
      description = "Whether the EBS volume should be encrypted"
      type        = bool
    }

9.3 Provide values
  
  Now i have to provide the values for all. 

  I define all the values in "terraform.tfvars" file.

    ebs_volume_size        = 20 
    ebs_volume_type        = gp3
    ebs_availability_zone  = us-east-1a
    ebs_encrypted          = true
  
9.4 Create the Resource

   As i allready defines the varibale and provide values. 

   But now we have to create the resource for which we defining the variables and all that. 

   in main.tf:


     resource "aws_ebs_volume" "My-ebs" {
          size     = var.ebs_volume_size
          type     = var.ebs_volume_type
          availability_zone = var.ebs_availability_zone
          encrypted = var.ebs_encrypted
    }
  The flow is : 
         
         terraform.tfvars (Defibed values)
                |
            Variables     (that we had created in variables.tf)
                |
          aws_ebs_volume 
                | 
          AWS EBS Volume 

After all this, Now we have to do: 

9.5 Format And validate
  
  Now we have to format all our code in a proper indentation and validate that our written configuration is valid or not?  

  BY using this we can check our configuration is ready for next or not!
  
   First we have to run:
     
     terraform fmt
  
   then:
     
     terrafomr validate

  terraform fmt formats the configuration.

   terraform validate checks whether the configuration is syntactically and structurally valid.

9.6 Create the Plan
   
   After all of this we need to create the plan for terraform what to do next?
  
  For that we have to run: 

      terraform plan

  if the EBS volume does not already exists, Terraform should plan to create it. 

  The plan will contain a resource similar to:
   
    + create
  
  Terraform may also show values that will only be known after the resouce is created. 

  But, Remember at this stage nothing has been created in AWS. 

9.7 Apply the Configuration

   So, After  the plan was created and reviewing it properly. we will going to run a command called "terraform apply"

       teraform apply

  Terrafomr create the EBS Volume in AWS. 
  
   The final flow of the structure is: 

         Requirements
              |
          Variables
              |
          Terraform resource
              |
          Terraform fmt
              |
          Terrafomr Validate
              |
          Terraform Plan
              |
            Review 
              |
          Terraform apply
              |
        EBS Volume created

9.8 Verify the Resource

  So, after applying we need to verify the resource. 

  We cab inspect the terraform state: 
     
     terraform state list
     
  We should see:

     aws_ebs_volume.example

   we can inspect the resource with: 
  
     terraform state show aws_ebs_volume.example
   
   This allow us to verify the information Terraform is managing for the EBS Volume. 

9.9  Important Learning
 
  This example demonstarte the complete terraform workflow: 

              Think
                |
          Define Requirement
                |
            Choose Resource
                |
            Define Variables
                |
            Write resource
                |
             Format
                |
            Validate
                |
               Plan 
                |
              Review
                |
              Apply
                |
              Verify

   Remember one thing is that goal is not to memorize this particular EBS Configuration. 

    The Goal is to understand the workflow so that the same process can be applied to other terraform resources. 
              
     
## 10. Common Mistakes

    
    When working with EBS volumes in terraform, beginners commonly make a few mistakes. 

10.1 Confusing Size with performance

    size = 100 
      
    Does not mean the volume has IOPS

         size 
          |
        Storage capacity

        IOPS
         |
    I/O Operations per second

        throughput
            |
      Amount of data transferred per second. 
  
  These are different properties. 

10.2 Using the wrong Availability Zone
   
   An EBS volume belongs to a specific Availability Zone. 
  
  For Example: 
    
    availability_zone = "us-east-1a"
   
   The Volume cannot simply be attached to an EC2 instance in another Availability Zone. 
  
  Always Consider:
    
    EC2 Availabiltiy Zone
           |
    EBS Availability Zone

    Before creating an attachment.

10.3 Assuming every arguments works with Every Volume Type
  
  Arguments Such as:
     
     iops        = .....
     throughput  = .....

  It depends on the selected EBS volume type. 

  So Do not blindly add them to every confuguration.  
 
  Always check the resource documentation for the selected volume type.

  Making it easy for you. Here are the volume type that support bith iops and thoroughput:
     
     Volume type      Supports (iops)    Support (througput)
     gps                  Yes                 Yes
     io2                  Yes                 No
     io1                  Yes                 No

  Only these volume type supports  iops and thoughput. 

10.4 Reducing  an Existing Volume's Size
  
  Increasing 
     
     20 GiB -> 50 GiB

  is different form reducing 

     100 GiB -> 50 GiB
    
 EBS volume cannot simply be shrunk in place.

 A size reduction may require a new volume and migrating the data.

10.5 Applying changing without checking the plan
  
   This is the most common mistake that everyone do especially begineers.

   Make sure, Never make storage changes blindly. 

   Always Run:
      
      terraform plan
   
   and check whether terraform intends to:

     + create
     ~ update in-place
     -/+ replace
     -  destroy
  
  For EBS, this is especially important because the volume may contain important  data. 

10.6 Forgetting that creating a volume does not attach it

   Means if you created an EBS volume does not mean it automatically connect to an EC2 instance 

  The volume and it's attachment are seperate resources/operations.

  We need to attach it 


 -------------------------> Important Rule <---------------------------
     
       "Always understand what Terraform plans to do before applying changes to persistent storage."

## 11. Troubleshooting
  
  So, I request you to all thay please think like a real engineer here while you are  troubleshooting something. Because this is the critical steps that every engineer must have to face. 

  When working with the aws_ebs_volume, problems can occur during validation, planning or applying the configuration. 

   So the best apporach is to indentify where the problem occurs first. 

              terraform validate
                      | 
                      | Configuration problem
                      |
              terraform plan
                      |
                      | planning / provider problem
                      |
              terraform apply
                      |
                      |  AWS / resource operation problem
    

Understand using this: 
       Command                   What it checks?

      terraform validate	      Your code (syntax, arguments)
      terraform plan	          Your configuration (provider, compatibility)
      terraform apply	          AWS (permissions, limits, API)
  
 Use this simple process:
    
                       

                       Read the error
                             |
                      Indentify where It occured
                             |
                      Check the resource Arguments
                             |
                      Check the AWS Region / AZ (availability zone)
                             |
                      Check Volume Type Compatibility
                             |
                      Run terraform validate
                             |
                      Run terrafomr plan
                             |
                      Review the planned Action
                             |
                      Apply Only after Understanding the change

 
  KEY RULE: 
       
       Don't troubleshoot by randomly changing values. Read the error, identify the cause, verify the documentation, and then make the smallest necessary change.
        
  
## 12. Interview Questions

These questions cover the important EBS and Terraform concepts discussed in this documentation.

### 12.1 Basic EBS Questions

**1. What is Amazon EBS?**

Amazon EBS (Elastic Block Store) is a block-level storage service that provides persistent storage for EC2 instances.

---

**2. What is the difference between EC2 and EBS?**

```text
EC2 → Compute
EBS → Storage
```

EC2 provides computing resources such as CPU and memory, while EBS provides persistent block storage.

---

**3. Does an EBS volume automatically attach to an EC2 instance when created?**

No.

Creating an EBS volume and attaching it to an EC2 instance are separate operations.

---

**4. What is an Availability Zone in relation to EBS?**

An EBS volume belongs to a specific Availability Zone and normally needs to be attached to an EC2 instance in the same Availability Zone.

---

### 12.2 EBS Performance Questions

**5. What does `size` represent in an EBS volume?**

`size` represents the storage capacity of the volume, measured in GiB.

---

**6. What is IOPS?**

IOPS means **Input/Output Operations Per Second**. It represents how many I/O operations the storage can handle per second.

---

**7. What is throughput?**

Throughput represents the amount of data that can be transferred per second.

---

**8. Is a larger EBS volume automatically faster?**

No.

Storage capacity and storage performance are different properties.

```text
Size      → Capacity
IOPS      → I/O operations
Throughput → Data transfer
```

---

### 12.3 Terraform Questions

**9. Which Terraform resource creates an EBS volume?**

```hcl
aws_ebs_volume
```

Example:

```hcl
resource "aws_ebs_volume" "example" {
  ...
}
```

---

**10. What is the difference between a Terraform argument and attribute?**

An **argument** is a value we provide to configure a resource.

An **attribute** is information exposed by the resource that can be referenced elsewhere.

Example:

```hcl
aws_ebs_volume.example.id
```

---

**11. What does `terraform plan` do?**

It compares the desired configuration with the current infrastructure/state and shows the changes Terraform intends to make.

It does **not** apply the changes.

---

**12. What does `terraform apply` do?**

It executes the changes described by the Terraform plan and creates or modifies the infrastructure.

---

**13. What does `+ create` mean in a Terraform plan?**

It means Terraform plans to create a new resource.

---

**14. What does `~ update in-place` mean?**

It means Terraform plans to modify the existing resource without replacing it.

---

**15. What does `-/+` mean?**

It means Terraform plans to replace the existing resource by destroying the old resource and creating a new one.

---

### 12.4 Practical Questions

**16. What happens if an EBS volume is changed from 20 GiB to 50 GiB?**

Increasing the size of an EBS volume can generally be performed without replacing the volume. Terraform can therefore plan an in-place update.

---

**17. Can an EBS volume be reduced from 100 GiB to 50 GiB directly?**

No. EBS volumes cannot simply be shrunk in place. A migration to a smaller volume may be required.

---

**18. What happens if you change the Availability Zone of an EBS volume?**

An EBS volume belongs to a specific Availability Zone, so moving it to another Availability Zone can require replacement or a migration strategy.

---

**19. Why should `terraform plan` be checked before applying EBS changes?**

Because EBS is persistent storage and may contain important data. The plan shows whether Terraform intends to create, update, replace, or destroy the resource.

---

**20. What is the most important rule when modifying infrastructure containing persistent storage?**

Always understand what Terraform plans to do and consider what will happen to the existing data before applying the change.


## 13. Key Takeaways

