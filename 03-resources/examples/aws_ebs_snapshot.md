## In this we are going to study about the  "EBS SNAPSHOT"  What it is? 

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



2. Why Do we Need EBS Snapshots?

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

2.3  Data Protection
   
   Snapshots provide an additional copy of important volume data. 
     
     for example: 
          
           original EBS volume
                   |
             Application Data
                   |
              Snapshot
 
        
          If the original volume is accidentally deleted or becomes unavailable, the snapshot can provide a recovery point.