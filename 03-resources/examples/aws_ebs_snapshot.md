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


# Step 1: Snapshot already exists (or create one)

# Step 2: Create volume from snapshot

    resource "aws_ebs_volume" "from_snapshot" {
     availability_zone = "us-east-1a"
     snapshot_id       = aws_ebs_snapshot.example.id
     size              = 20
    }

# Step 3: Attach volume to EC2

      resource "aws_volume_attachment" "attach" {
          device_name = "/dev/sdf"
          volume_id   = aws_ebs_volume.from_snapshot.id
          instance_id = aws_instance.web.id
      }

   The One-Liner: 

        "Snapshot = backup. You cannot attach it directly. You must create a volume from it first, then attach that volume to EC2."