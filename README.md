# My personal dotfiles for void linux

This repository contains a set of scripts to support different profiles / setups and environments

# How to install

First, install Void-Linux by following this guide: https://docs.voidlinux.org/installation/index.html

After you have followed and finished that guide and having a bootloader setup, reboot into your newly installed system
and login with your personal user

Then install git (which is needed to clone this repo):
```bash
xbps-install -Sy git sudo
```

Now clone this repo to wherever want (it should stay at that location even after running the setup, to make sure you can
also update your profile with the `up` command)
```bash
git clone https://github.com/RononDex/archdotfiles
```

Open the directory with `cd archdotfiles` and execute the installation script:

```
sh profile-enabler.sh
```

This will take a while to run, go grab a coffee or exercise :)
Once the script has finished, simply reboot into your finished and ready to use system (**you might have to enter `exit` once during the installation process, it sometimes gets stuck in the zsh after installing it. After entering `exit` it will continue installation**)

To upgrade your system (including the AUR packages) just enter `up` in your terminal. This will do a git pull of the dotfiles repository, and rerun the profile-enabler.sh with your installed profile.

# How it works

1. Copy all files from the folder `defaults` to your home directory
1. Run `default-profile-install.sh` which will install all the default stuff that is the same across all pc's
1. Run profile-enabler.sh lcoated in your chosen profile folder `profiles/[profileName]/profile-enabler.sh`

So to create your own profile, simply fork this repository and create your own profile in the `profiles` folder. The only mandatory files are `xprofile`, `bashprofile` and `profile-enabler.sh`

## Software installed by default (for all profiles)
For an up to date list check the file itself here https://github.com/RononDex/voiddotfiles/raw/master/default-profile-install.sh

- zsh (with oh-my-zsh and powerlevel10k)
- networkmanager
- fonts
- pulseaudio
- ranger
- zathura
- lightdm (with webkit litarvan theme)
- ...

# Data Structure

This repository is structured into the following folders:

1. defaults: Contains all the default files that install all the base files into ~/
2. profiles: Contains one subfolder per profile, with overrides for the base profile.
3. functions: Contains several functions reused throughout the different shell scripts

![Screenshot](https://github.com/RononDex/voiddotfiles/raw/master/Screenshot.png)
