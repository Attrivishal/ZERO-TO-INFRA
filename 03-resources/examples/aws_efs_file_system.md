## Let's start with the  new topic :)

   EFS = ELASTIC FILE SYSTEM 

   The name of the new topic is "AWS EFS file System". We are going to deep dive in this topic and understand  about this topic in simplest way with the help of some example and analogy. 

   I request you to please stay focused throughout the way. 

   This section explain the engineering problems EFS solves. When to choose it over EBS, and the trade-offs you need to understand as a cloud/Devops Engineer.

1. Why do we need Amazon EFS?
    
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

2.1 The Problem with Instance-Local Storage
   
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
    
   And Then what  EFS = ELASTIC FILE SYSTEM Provides that EBS doesn't :

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

2.2 Shared storage Across Multiple  EC2 Instances

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

   
2.3 Why EFS Is Useful
 
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
          
  
          
