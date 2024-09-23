# Some hacks to make linuxing easier

This repo contains a basic set of linux commands injected into a user profile. The hacks/tools are features that I always end up doing manually, all the time, in all the profiles, in all the VMS so I put it all in one place to make things easier.

This works for linux VM's but is also useful for linux machines and PI's, some of the hacks in here are especially useful running ROS2.

## Ubuntu

### removing stuff - usually installed on ubuntu - but i don't need it

```bash
sudo apt remove --purge -y libreoffice* thunderbird
sudo apt clean && sudo apt autoremove
```

[some more space reduction stuff here](README.space.md)

### always needed stuff

```bash
#  update
sudo apt update
sudo apt upgrade -y

# packages i normally use
sudo apt install -y net-tools ssh htop vim iftop curl git gcc make \
    build-essential libssl-dev zlib1g-dev libbz2-dev screen \
    libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
    xz-utils tk-dev libffi-dev liblzma-dev
```

## Profile stuff

```bash
ln -sf ~/linux_profile/.vimrc ~/.vimrc
ln -sf ~/linux_profile/.editorconfig ~/.editorconfig
echo 'source ~/linux_profile/profile.sh humble' >> ~/.bashrc
# the 'humble' bit is to source in the ROS bash file
# it works for whatever the ROS folder is called - this could be done more elegantly
source ~/.bashrc
```

More details about ROS [here](ROS_HACKS.md)

## Git

```txt
   git config --global user.email "user@email.domain"
   git config --global user.name "your name"
   git config push.autoSetupRemote true
```

### ssh autostart

```bash
sudo systemctl enable ssh
sudo systemctl start ssh
```

### Add sudoers to Sudoers as nopasswd

```txt
%sudo   ALL=NOPASSWD: ALL
```

### Netbios hosname resolution

```bash
sudo apt install libnss-winbind winbind
```

Edit `/etc/nsswitch.conf` and add `wins` to the end hosts line.

### pyenv

pyenv [from here](https://github.com/pyenv/pyenv-installer)

check the script is sane and then:

```bash
curl https://pyenv.run | bash
```

Then install something python'y

```bash
pyenv install 3.10.7
pyenv global 3.10.7

#this assumes you're importing the profile.sh in your .bashrc
source ~/.bashrc
```

### AWS CLI Version 2

For x86_64

```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

For ARM_64

```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

Details [from here](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html)

### ubuntu 20.04 enhanced session in hyper-v

To enable ubuntu 20.04 **enhanced session** in hyper-v you will need to:
Run this in powershell on the hyper-v host:

```powershell
Set-VM -VMName "guest-name-in-hyper-v" -EnhancedSessionTransportType HvSocket
```

Then execute [the script here](https://raw.githubusercontent.com/microsoft/linux-vm-tools/cb07b3eaeb89822ebc6eaddb10f3932bb1879f47/ubuntu/20.04/install.sh) but read it first!

## License

I like beer, so buy me a beer if you want and I'm not responsible for how you use this code.

```text
/* 
 * — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — 
 * “THE BEER-WARE LICENSE” (Revision 42):
 * <Spidey> wrote this file. As long as you retain this  
 * notice you can do whatever you want with this stuff. If we meet
 * some day, and you think this stuff is worth it, you can buy me
 * a beer in return.
 * — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — 
 * Amendment 1: The author(s) of this code accept absolutely no 
 * liability for any damage or general bad things that may come as 
 * part of its use. Any use of this software is deemed an agreement 
 * to absolve the author(s) of any liability, culpability, 
 * durability and any other “(*)ability” (good or bad).
 */
```
