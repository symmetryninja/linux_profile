# Some linux VM hacks to make linuxing easier

A basic linux profile that I always end up doing manually, this works for VM's but is also useful for linux machines and PI's etc

## Ubuntu

### always needed stuff

```bash
#  update
sudo apt update
sudo apt upgrade -y

# packages - note 20.04 doesn't have python-openssl
sudo apt install -y net-tools ssh htop vim iftop curl git gcc make \
    build-essential libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
    xz-utils tk-dev libffi-dev liblzma-dev python-openssl
```

Profile stuff
```bash
cp ~/linux_profile/.vimrc ~/
cp ~/linux_profile/.editorconfig ~/
echo 'source ~/linux_profile/profile.sh foxy' >> ~/.bashrc
# the 'foxy' bit is to source in the ROS bash file - it works for whatever the ROS folder is called :)
source ~/.bashrc
```

Git

```
   git config --global user.email "user@email.domain"
   git config --global user.name "your name"
```

### ssh autostart

```bash
sudo systemctl enable ssh
sudo systemctl start ssh
```

### ubuntu 20.04 enhanced session

execute [the script here](https://raw.githubusercontent.com/microsoft/linux-vm-tools/cb07b3eaeb89822ebc6eaddb10f3932bb1879f47/ubuntu/20.04/install.sh) but read it first!

***note*** I was unable to create the setup to enable using the "Enhanced session" feature in Hyper-V for an ubuntu 20.04 VM - but the script enables RDP which is basically the same thing.

You may need to change `/etc/xrdp/xrdp.ini` port reference to something like this to allow RDP:
```text
port=tcp://:3389
```

You also may need to change the VM properties to support "enhanced session" in an admin powershell:

```powershell
 Set-VM -VMName <your_vm_name>  -EnhancedSessionTransportType HvSocket
```

Finally open 3389 to the local network:
```bash
sudo ufw allow 3389
```

### pyenv

pyenv [from here] (https://github.com/pyenv/pyenv-installer)

check the script is sane and then:

```bash
curl https://pyenv.run | bash
```

Then install something python'y

```bash
pyenv install 3.9.7
pyenv global 3.9.7

#this assumes you're importing the profile.sh in your .bashrc
source ~/.bashrc
```

### AWS CLI

Version 2 :D

```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

```

Details [from here](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html)

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
