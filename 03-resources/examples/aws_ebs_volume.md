## Now we discuss about the AWS EBS Volume. What is this and how is this work
# AWS EBS Volume


## 1. What is Amazon EBS?
    Amazon EBS (Elastic Block store) is a block-level storage service designed for use with Amazon EC2 instances.

    In Simple terms we can say that, EBS volumes behave like a virtual hard disk that we can attach with our EC2 instance. It provides persistent storage that remians available if the instance is stopped or terminated. 

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
        "EBS is a virtual hard disk for EC2 - it provided persistent storage that survives instance restarts."



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

     This is why seperation allows stoarge to be managed independently from 

## 3. How EBS works

## 4. Important concepts

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