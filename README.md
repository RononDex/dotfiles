# My personal dotfiles for void and arch linux

This repository contains a set of scripts to support different profiles / setups and environments

# How to install
## General

Install your basic OS (arch linux or void linux).

Then install git with the package manager (which is needed to clone this repo):
```bash
xbps-install -Sy git sudo
```

Now clone this repo to wherever want (it should stay at that location even after running the setup, to make sure you can
also update your profile with the `up` command)
```bash
git clone https://github.com/RononDex/voiddotfiles
```

Open the directory with `cd dotfiles` and execute the installation script:

```
sh profile-enabler.sh
```

This will take a while to run, go grab a coffee or exercise :)
Once the script has finished, simply reboot into your finished and ready to use system (**you might have to enter `exit` once during the installation process, it sometimes gets stuck in the zsh after installing it. After entering `exit` it will continue installation**)

To upgrade your system (including the AUR packages) just enter `up` in your terminal. This will do a git pull of the dotfiles repository, and rerun the profile-enabler.sh with your installed profile.

## AstroPi
See [AstroPi-README](AstroPi-README.md)

# How it works

1. Copies all files from the folder `defaults` to your home directory
1. Runs `default-profile-install-<distro>.sh` which will install all the default stuff that is the same across all pc's
1. Run profile-enabler.sh lcoated in your chosen profile folder `profiles/[profileName]/profile-enabler.sh`

So to create your own profile, simply fork this repository and create your own profile in the `profiles` folder. The only mandatory files are `bashprofile`, `distro` and `profile-enabler.sh`

## Software installed by default (for all profiles)
For an up to date list check the file itself here https://github.com/RononDex/dotfiles/raw/master/default-profile-install-void.sh

- zsh (with oh-my-zsh and powerlevel10k)
- networkmanager
- fonts
- ranger
- zathura
- sddm (with sugar candy theme)
- ...

# Data Structure

This repository is structured into the following folders:

1. defaults: Contains all the default files that install all the base files into ~/
2. profiles: Contains one subfolder per profile, with overrides for the base profile.
3. functions: Contains several functions reused throughout the different shell scripts

![Screenshot](https://github.com/RononDex/voiddotfiles/raw/master/Screenshot.jpg)
