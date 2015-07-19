# Keys

## SSH

### Installation

Install the following packages, like so:

    pacman -S openssh autossh sshfs x11-ssh-askpass

### Key Pair Generation

To generate a 8192 bits keys using the RSA algorithm run:

    ssh-keygen -t rsa -b 8192

To use the default filename i.e., *id_rsa* and default location i.e., */home/USERNAME/.ssh/*, answer:

> ``ENTER``  
> ``PASSPHRASE ENTER``   
> ``PASSPHRASE ENTER``  

**NOTE: Replace PASSPHRASE with a strong passphrase.**

## GnuPG

Any user specific information e.g., personal information or (partial) fingerprints of keys, should be replaced with your appropiate corresponding information.

### Installation

Install the following packages, like so:

    pacman -S gnupg

### GnuPG Home and Configuration

Create GnuPG's configuration (home) directory (which defaults to `~/.gnupg`) and configuration file:

    gpg -k

To use stronger algorithms, add the following to ``~/.gnupg/gpg.conf`` i.e., the configuration file:

    personal-digest-preferences SHA512
    cert-digest-algo SHA512
    default-preference-list SHA512 SHA384 SHA256 SHA224 AES256 AES192 AES CAST5 ZLIB BZIP2 ZIP Uncompressed
    personal-cipher-preferences TWOFISH CAMELLIA256 AES 3DES

### Key Generation

Firts generate a *master*, sign only, key pair:

    gpg --full-gen-key
    
Subsequently, answer the questions like the following:
    
> 4     
> 2048  
> 0     
> y     
> Koen Boes     
> koenboes@gmail.com    
> Master Key    
> O     

Now, generate two subkey pairs for, respectively, signing and encryption:

    gpg --edit-key 5998AD4A
    
First add the *signing* subkey pair, and answer the questions like the following:
    
> addkey    
> 4     
> 2048  
> 1y    
> y     
> y     

Second add the *encryption* subkey pair, and answer the questions like the following:

> addkey    
> 6     
> 2048  
> 1y    
> y     
> y     

Finally, save both subkey pairs:

> save  

### Backup and Secure the Master Key

Backup the ``~/.gnupg`` directory (including the private part of your master key).

Then, extract (only) the secret subkeys and temporary (and securely) store them somewhere:

    gpg --export-secret-subkeys 5998AD4A > 5998AD4A_secret_subkeys

Subsequently, delete the secret master key (including the secret subkeys):

    gpg --delete-secret-key 5998AD4A

During the deletion process answer the question, respectively, like the following:

> y     
> y     

Now, import (only) the secret subkeys:

    gpg --import 5998AD4A_secret_subkeys

Finally, remove the (temporary) stored secret subkeys:

    rm 5998AD4A_secret_subkeys


## Setup Caching of Passphrases of GnuPG keys

### Installation

    pacman -S expect

Add the following to ``~/.gnupg/gpg.conf``:

    use-agent

