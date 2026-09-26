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
  
  You change it to:

    resource "aws_ebs_volume" "example" {
    size = 50
    }
## 9. Practical Example

## 10. Common Mistakes

## 11. Troubleshooting

## 12. Interview Questions

## 13. Key Takeaways

