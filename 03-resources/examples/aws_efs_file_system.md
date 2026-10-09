## Let's start with the  new topic :)
   
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