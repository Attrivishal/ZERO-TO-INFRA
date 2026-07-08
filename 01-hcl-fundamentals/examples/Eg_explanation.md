# first we see about the version.tf file

eg: 
```hcl
terraform {

}
```

This is a terraform block. yes you are right but It just 10% of the block 

Let me give you a proper understanding, see here: 

Let's imagine you're a terraform ( Vishal(Your_Name) Is a terraform ):
 
And some one runs:

```bash
terraform init #On Terminal 
```

*(it is a command for initializing the terraform. Just don't give focus on this for now. Ltaer you will get know).*

The time you write this "terraform init" command the terraform ask itself a questions.

```
       where am I
           ↓
Which folder should I read?
           ↓
 Are there any .tf files?
           ↓
        If (Yes)
           ↓
    Let's read them.
           ↓
Do I see a terraform block?
           ↓
       If (Yes!)
           ↓
         Good 
```

Now I know this project trying to tell me that:
 - Which Terraform version is required
 - Which provoder I need
 - Where the backend(Local/remote Storage) is.
 - Other Terraform settings.

So Guys Here ypu notice something.

Terraform ALWAYS looks for the 'terraform' block first because it contains the instructions about Terraform itselfs,

### Real-flow:

```
terraform version
        ↓
    provider
        ↓
     backend 
        ↓
  Infrastructure
```

```hcl
terraform {
   required_version = ">= 1.8"
}
```

Now lets emphasize on this word "required_version":

So let me clear you some important things about this "required_version" 

 - This is not the version of AWS or any others cloud providers.
 - It is not version of the provider.
 - It is the verison of the "Terraform CLI" you installed when you downloaded terraform online.


# What is required providers.

If you know most of the people says that it is used to define the providers. That is true but you this is not full  information about "PROVIDERS"

Imagine:
 when you type :
  terraform init   #On your terminal 

Terraform things like this:
 Read all .tf files
 |
 Find terraform block
 |
 Terraform Version
 |
 Do I need any Providers?
 |
 Yes
 |
 Which Providers?
 |
 Download them
 |
 store locally 
 |
 Ready to use

Here You Notice something?

Terraform cannot create anything until it downloads the required provider plugin.


