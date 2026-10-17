## Let's start with the new topic :)

EFS = ELASTIC FILE SYSTEM

The name of the new topic is "AWS EFS file System". We are going to deep dive in this topic and understand about this topic in simplest way with the help of some example and analogy.

I request you to please stay focused throughout the way.

This section explain the engineering problems EFS solves. When to choose it over EBS, and the trade-offs you need to understand as a cloud/Devops Engineer.

## 1. Why do we need Amazon EFS?

So the core problem is:

     "How can multiple instance access the same files without maintaining separate copies of the data on each instance?"

Let me explain this with a simple scenario.

So, The scenario is:

     Imagine you have a web application running on 3 EC2 instance:

        EC2 instance 1 -> Has file: /data/images/photo.png
        EC2 instance 2 -> Has file: /data/images/photo.png
        EC2 instance 3 -> Has file: /data/images/photo.png

    The problem is: -

      - Each instance has its OWN COPY of the file.
      - If you update the photo on instance 1, you must        manually update it on instance 3 and instance 3
      - This is messy, error-prone and very Time-consuming

    Now you are thinking that why this happens?

        EBS Volume are attached to ONE EC2 instance at a time (in most cases). They cannot be shared accross multiple instances.

       Like this:

        EC2 Instance 1 -> EBS Volume 1 (its own storage)
        EC2 Instance 2 -> EBS Volume 2 (its own storage)
        EC2 Instance 3 -> EBS Volume 3 (its own storage)

     Each Instance has its own separate storage. No sharing.

        │ EC2 #1      │     │ EC2 #2      │     │ EC2 #3      │
        │             │     │             │     │             │
        │ EBS Volume  │     │ EBS Volume  │     │ EBS Volume  │
        │ logo.png    │     │ logo.png    │     │ logo.png    │
        │ (copy 1)    │     │ (copy 2)    │     │ (copy 3)    │

    Problem: 3 separate copies of the same file!

## 2.1 The Problem with Instance-Local Storage

       Problem                  Explanation

    1. No sharing              Each instance has its own storage
    2. Duplicate data          Same files stored multiples times
    3. Manual Sync             You must update each copy manually in every instance
    4. Inconsistency           Different instances may have different versions
    5. Wasted space             Storage is duplicated

Let's see the simple analogy:

     Think you 3 friends are working in 3 separate offices:

       - Each has their own filling cabinet (EBS Volume)
       - If someone update a document, they must photocopy it and mail it to the other 2 offices also
       - If they forgot to do so, the other offices have old versions.

That is why this is getting very serious issue amongs the system.

And Then what EFS = ELASTIC FILE SYSTEM Provides that EBS doesn't :

      EFS provides a shared file system that multiple EC2 instances can access at the same time.

Like this I am going to show with the help of diagram:

     ---------     --------      --------
    | #1 EC2 |    | #2 EC2 |    | #3 EC2 |
     ---------     --------      --------
        |              |             |
        |              |             |
         ----------------------------
                       |
                       |
              --------------------
             |  EFS File system   |
             | (shared) photo.png |
             | (one copy of)      |
              --------------------

So we can see that in this approach all instance see the SAME File. One Copy. Always in SYNC

Just to give you all. A normal way to see EBS - EFS is:

      EBS = private storage for one instance.

      EFS = shared storage for many instances.

## 2.2 Shared storage Across Multiple EC2 Instances

Let's connect Know that EBS Volumes are attached to ONE EC2 instance at a time.

So if you have:

1. EC2-A with its own EBS Volume
2. EC2-B with its own EBS Volume

They cannot share files. Each has it own separate storage.

Now the Questions is: What if you want both EC2-A and EC2-B tp access the sames files?

That exactly what EFS solves:

Let me show with the diagram:

                  Users
                    |
         Application Load  balancer
               /          \
               |          |
               |          |
            EC2-A        EC2-B
              |            |
              |            |
               ------------
                  Amazon
                    EFS
                Shared files

    1. Users         : Those People who actually accessing  your application.

    2. Load balancer : Distributes traffic to EC2-A and EC2-B

    3. EC2-A, EC2-B  : Your applicayion servers
    Amazon EFS    : Shared files storage both servers can access

This means:

      Both the instance access the same files instead of maintaing indepndent copies.

Without EFS (What you already know):

     EC2-A → EBS Volume A → photo.png (copy 1)
     EC2-B → EBS Volume B → photo.png (copy 2)

Problem: Two copies. If one changes, the other doesn't know.

With EFS (The new solution) we are learning about:

       EC2-A --
        |---> EFS: photo.png (ONE copy)
       EC2-B --

Both see the same file. Always.

For example:

    If EC2-A writes a file to EFS, EC2-B can access that file through the same file system—subject to filesystem permissions and access configuration.

    Step 1: EC2-A writes "file1.pdf" to EFS
    Step 2: EC2-B reads "file2.pdf" from EFS
    Result: EC2-B sees the same file EC2-A wrote

But there is one catch here: (warning)

      EFS provides shared access to files, not automatic application-level synchronization.

## 2.3 Why EFS Is Useful

    In this part we will going to see why EFS is usefull.

A. Shared Application Files:

     Multiple application servers may need access to common files, including:

     1. user-uploaded images and documents
     2. Shared application assets
     3. Common file repositories
     4. Files processed by multiple worker instances

B. Horizontal Scalling:

     Horizontal scalling means adding more compute instancres to handle increased workloads.


     without  shared storage, every instance might needs its own copy  of the application's files.

     with EFS , Multpiple instances can access the same fike system.
          Like this:

              Add more instances
                      |
              Shared Amazon EFS
                      |
              Commin File Data

    This seprates the application's compute capacity from its shared file storage.

C. Storage That Grows with usage:

Okay listen, Firstly let's connect that you already know.

You already that witht EBS, you provision a specefix size:

      resource "aws_ebs_volume" "My-volume" {
        size = 20    # <- You must choose a fixed size
      }

So if you need more space, you must manually increase it (and if you want less, you cannot shrink it).

Now the Question is?

     What if you don't know how much storage you will need in future. What if it changes constantly?

     That's exactly EFS solves

The Core Difference:

     EBS                                   EFS
     You provision fixed size              It grows and chrinks automatically
     20 GiB means 20 GiB not more space    No fixed size - pay for what you use
     Mannual resize needed                 Automatic scaling

Let me show you with the visuals:

      EBS Volume:
      ---------------------------------------------------
     |   |||||||||||||||||||| (Total space)
     |   ||||||| (Used space)
     |
     |   Fixed at 20 GiB
     |     (you pay for 20 GiB even you only use 5 GiB)
      ---------------------------------------------------

      EFS File system:
      ------------------------------------------------------------------
    |   Grows and shrinks automatically
    |
    |      |||||||| (space)  <- 5 GiB used
    |      You pay only for what you use
    |
    |     Later if you want to use more 10 GiB:
    |
    |      it will automatocally increased without manual intervention.
    |       ||||||||||||||| (10 GiB space)
      ------------------------------------------------------------------

Think like that there is a water tank:

     1. EBS = A fixed-size tank. I buy a 100-litre tank. If I only use 20 litres, I still paid for 100 litres. That's not efficient and effective.

     2. EFS = A tank that expands and contracts based on how much water I need to put in that tank according to our needs. I Just have to pay only for the water that actually present in a tank.

This is the simple analogy you need to understand it. then you will be able to get the whole point.

But guysssss. let me tell you one thing that there is a twist here!

     Now as you all that EFS grows and shrink automatically, but it's not unlimited. There are still limits(quotas) and you have to pay (charges) for that also.

The Visuals:

        EFS File System
        │
        ├── Grows automatically
        │
        ├── But has limits (quotas)
        │   ├── Max file size
        │   ├── Max file system size
        │   └── Max throughput
        │
        └── And you pay for usage
             ├── Storage used
             ├── Throughput
             └── Requests

The One-Liner:

     "EBS = Fixed Size, you provioned it. means we decide how much space do we needed."

     "EFS = grows and shrink automatically. you pay for what you use. But quotas and charges still apply."

D. Decoupling Storage from Compute:

     Decoupled meaning: Storage and compute are separate. They are not tied together.

    You already know that with EBS, storage is attached to a specific EC2 instance.

         EC2 Instance -> EBS Volume (attached)

What happens if that EC2 instance fails?

    The EBS volume may survive, But it's tied to that instance lifecycle.

    You may need to detach and reattach it. It's not automatically available to a new instance.

Now the Question is: What if the application's files were stored separately from the instance?

That's exaclty what EFS solved.

Suppose this is the Scenario: (Already Choose EFS)

     An EC2 instance fails and must be replaced.

       Old EC2 instance
             |
             X Instance fails (failure)
             |
       New EC2 instance
             |
             |

        Same Amazon EFS
             |
             Existing Files

What Happen here:

     1. Old instance fails
     2. I launched a new EC2 instance
     3. The new instance mounts the same EFS file system
     4. All files are still there- no copying needed

     The files do not need to be copied from the failed instance because they are stored separately.

The Key Concept:

     Storage is decoupled from compute. The files live on EFS, not on the instance.

The two Architecture:

      Coupled (EBS - Old Way):

         ┌─────────────────────────────┐
         │  EC2 Instance               │
         │                             │
         │  ┌─────────────────────┐    │
         │  │   EBS Volume        │    │
         │  │   (Storage)         │    │
         │  │   files live here   │    │
         │  └─────────────────────┘    │
         │                             │
         │  Compute + Storage together │
         └─────────────────────────────┘

     Storage is INSIDE the instance's world. If the instance fails, storage is tied to it.

Decoupled (EFS - New Way):

       ┌─────────────────┐
       │  EC2 Instance   │
       │  (Compute only) │
       └────────┬────────┘
                │
                │ (mounts)
                ▼
       ┌─────────────────┐
       │   EFS           │
       │   (Storage)     │
       │   files live    │
       │   here          │
       └─────────────────┘

       Storage is SEPARATE from the instance. If the instance fails, storage is still there, untouched.

E. Managed File Storage

     AWS manages the underlying  EFS storage infrastructure.

     MEANS -> AWS handles all the physical storage, hardware, replication, and scalling behind the scenes. You don't see it, touch it, or manage it.

     You do not need to manually create and maintain individual storage disks for each application server to establish shared file access.

     MEANS -> You don't have to create a seprate disk for each EC2 instance just to share files between them. EFS gives you one shared file system that all instances can use.

     You remain responsible for configuring access, security groups, mount targets, permissions, backup policies, and application-level behaviour.

## 2.4 Why Not Uses EBS for Everything?

You already Know that:

      EBS = Block Storage attached to EC2 (private storage)

      EFS = Shared file storage for multiple instances

Now the question is: If EBS works fine, why not use it for everything?

    The answer is Simple: EBS and EFS are designed for different problems. They are not interchangable.

Let me Compare you with one table:

     ** Requirement                                     Appropirate Starting Point

      operating-sysetm disk for EC2                   EBS
      Block storage for an application or database    EBS
      Shared files accessed by multiple EC2 instances EFS
      Files that should remain available when an instance is replaced  EFS
      Shared storage using standard file-system access EFS**

Why EBS Cannot Replace EFS?

    Important Distinction: EBS volumes are generally shared writable file system for multiple EC2 instances.

What you might think Reality

"You can attach EBS to multiple EC2 instances" Not you cannot, Genrally EBS is designed for one instance

"I can use EBS as a shared file system" No. It is a block storage, not a shared file system

"EBS Multi-attach solves this" Only for specific volume types, and requires cluster-aware file system

## 2.5 Production Scenario

Consider a web application running on three EC2 instances behind an application Load Balancer.

Users upload documents, and background workers process those documents.

The requirements are:

     - Every application instance must access uploaded files.

     - Worker instances must process files from the same repository.

     - Replacing an EC2 instance must not remove the shared files.

     - Storage must grow as users upload more documents.

In this case Suitable Archtitecture is:

                           Users
                             |
                   Application load Balancer
                             |
                  -------------------------
               |             |              |
               EC2-A       EC2-B          EC2-C
               |             |              |
                  --------------------------
                             |
                        Amazon EFS
                             |
                     Shared Documents

All instances mount the shared EFS file system through appropirately configured mount targets and network access.

For production, you would also evaluate:

EFS encryption at rest and in transit

      - Network access through security groups

      - POSIX file permissions and IAM authorization where appropriate

      - Availability Zone placement and mount-target design

      - Backup and recovery requirements

      - Performance mode, throughput mode, and storage-class costs


"EFS is not automatically the best option for every workload. If an application needs a database engine, object storage, or high-performance block storage, a different service may be more appropriate."

## 2.6 Key Takeaway

Amazon EFS is useful when multiple compute instances need shared, persistent, elastic file storage. It separates shared file data from individual EC2 instances and supports architectures in which application servers can scale or be replaced without maintaining separate copies of the same files.

Remember: EFS solves the shared-file-storage problem. It does not replace every use case for EBS, S3, or a database.

## 3. How Amazon EFS Works

   Amazon EFS Provides a shared file system that can be accessed by multiple clients over a network. AWS manages the underlying storage infrastructure, while you configure the file system, network connectivity, and access permissions.

## 3.1 High-Level Architecture

    An EFS architecture includes a file system, mount  targets, a VPC, and clients such as EC2 instances. Each client connects through an appropirate mount target in its network environment.

The Diagram:

             AWS VPC
    ┌─────────────────────────────────┐
    │                                 │
    │  Availability Zone A            │
    │  ┌──────────────┐               │
    │  │ EC2 Instance │               │
    │  └──────┬───────┘               │
    │         │ NFS                   │
    │  ┌──────▼───────┐               │
    │  │ Mount Target │               │
    │  └──────┬───────┘               │
    │         │                       │
    │         │                       │
    │  ┌──────▼───────────────────┐  │
    │  │       Amazon EFS          │  │
    │  │       File System         │  │
    │  └──────▲───────────────────┘  │
    │         │                       │
    │  ┌──────┴───────┐               │
    │  │ Mount Target │               │
    │  └──────▲───────┘               │
    │         │ NFS                   │
    │  ┌──────┴───────┐               │
    │  │ EC2 Instance │               │
    │  └──────────────┘               │
    │  Availability Zone B            │
    └─────────────────────────────────┘

The Main Components:
     
     Components                     What it does
     1. EFS File system             stores the shared files and directories
     2.  Mount Target                Provides a network endpoint through which clients access the file system
     3. EC2 instance                 Runs the application that reads and writes files
     4. VPC                          Provides  the network environment used for communication 
     5. NFS Protocol                 Enables clients to access the remote file system

How Each Component Connects:
   
         EC2 Instance (AZ A)
                │
                │ NFS
                ▼
         Mount Target (AZ A)
               │
               │
               ▼
         EFS File System
               ▲
               │
         Mount Target (AZ B)
               ▲
               │ NFS
               │
         EC2 Instance (AZ B)


## 3.2 Create the EFS File System
 
  let's connect this to what you already Know:

  You already know that with EBS, you create a volume and specify it's size:

     
     resource "aws_ebs_volume" "My-Volume" {
          size = 20 # <- You must choose a fixed size
     }

  
  Now with EFS, the first step is similar but different. 

  I create a file system, but i don't specify a fixed size. it grows and shrinks automatically.

  What Happens in this step
    
    An EFS file system is created in AWS. it is the shared storage resource. 

 Step 1: Create EFS File System
               |
               |
         AWS creates the file system 
               |
               |
         You get a filesystem ID: fs-0123456789abcdef0

  
  The File System ID:
     
    It has its own  file system ID, such as -fs-0123456789abcdef0. This ID indentifies the EFS resource. 
   
    Resource	        ID Format	                  Example
    EBS Volume	        vol-xxxxxxxxxxxxxxxxx	        vol-0a1b2c3d4e5f6g7h8
    EFS File System    fs-xxxxxxxxxxxxxxxxx	        fs-0123456789abcdef0
    EC2 Instance	   i-xxxxxxxxxxxxxxxxx	        i-0a1b2c3d4e5f6g7h8
     
     The ID is  how you refernce the file system later. 

  The Key Difference From EBS:

       Aspect              EBS                                    EFS
       Size                You specifies fixed size (20 GiB)     No fixed size grows\shrinks automatically 

       Creation            Create volume + attach to Ec2         creates file system+ mount targets

       Access              Attached to one instance               Shared accross many instance 


    "Unlike an EBS volume, you do not specify a fixed volume size when creating an EFS file system. Its storage usage grows and shrinks as data is added and removed."
  
   
 And this how we create a EFS using AWS resources: 

     resources "aws_efs_file_system" "My-efs" {
          creation_token = "My-efs"
          encrypted      = true

          tags {
               Name = "app-shared-storage"
          }
     }

     That single block creates the file system in AWS. 

Important Arguments:
      
      1. Creation_token:  A unique name you give to your file system so AWS doesn't accidently create duplicates.
     
      2. encrypted - The Lock : Encrypts your data so no one can read it without the key.

      3. tags - The Labels: Labels you attach to your file system so you  can find it easily later.

      tags = {
         Name        = "my-app-efs"   # - Easy to find
         Environment = "production"   # - Which environment?
         Team        = "devops"       # - Who owns it?
      }

   Important Warning: 
       
       "At this stage, creating the file system alone does not mean an EC2 instance can access it. Network access must also be configured."

  The Visual:
    
     Step 1:  Create EFS File System 
                    |
                    |
             EFS File system
             ID -  ID: fs-0123456789abcdef0    
             (created, but not accessible yet)
                    |
                    | Next step - Configure network access
                    |
     Step 2: Create Mount Targets
     Step 3: Configure Security Groups
     Step 4: Mount from EC2 

  Let me tell you with the help of Analogy:
    
    Think of a new office Building:

     Step1 : The Building is constructed (EFS File system create)
     But = No doors 

     Step2 : Install doors and roads (Mount targets)

     Step3 : Give Keys to employees (Security groups)
     Step4 : Employees can enter (EC2 Mounts the file system)

  Creating the Building is just the first step: You still need doors and keys.

  The One-Liner

    "Step-1: Create the EFS file system. it has as ID(fs-xxx). No fixed size. But it's not accessible yet- network access must be configured next."


## 3.3 Step 2 - Create Mount Targets
  
   Let's Connect this to what  you already know

   You already know that:
     
     - Step 1: You created the EFS file system (fs-fs-0123456789abcdef0)
     - But: The file system exists in AWS - it's not accessible yet

   Now the questions: How does an Ec2 instance actually connect to it?

   That's what mount targets solve.

   Now you are thinking that what is mount Target?

     A mount target privides a network endpoint for accessing an EFS file system from a VPC.

   Think of it like a doorway into the filesystem.

     without Mount Target:
     EFS File System (isolated, no way in)

     With Mount Target:
     EFS File System -> Mount Target (doorway) -> EC2 can Connect 
 
   