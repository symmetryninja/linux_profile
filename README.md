# Some hacks to make linuxing easier

This repo contains a basic set of linux commands injected into a user profile. The hacks/tools are features that I always end up doing manually, all the time, in all the profiles, in all the VMS so I put it all in one place to make things easier.

- [aliases](aliases.sh) - a set of useful aliases for ROS and linux including cleaning out docker.*
- [helpers-aws](helpers-aws.sh) - a set of functions that make working with multiple AWS accounts easier
- [helpers-ros](helpers-ros.sh) - a profile selector and script executor, making working on multiple ROS projects on the same machine easier [readme here](README.ROS.hacks.md)
- [helpers-misc](helpers-misc.sh) - misc functions like stopwatch, find usage and snaps cleanup
- [ps1](ps1.sh) - a cool PS1 - overkill for most but handy for me
- [git-completion](git-completion.bash) - a direct import of [Shawn O. Pearce's gitcompletion implementation](https://github.com/git/git/tree/master/contrib/completion)
- [some commentary on clearing space](README.space.md)

This works for linux VM's but is also useful for linux machines and PI's, some of the hacks in here are especially useful running ROS2.

## Ubuntu

### Removing stuff that I don't need

```bash
sudo apt remove --purge -y libreoffice* thunderbird
sudo apt clean && sudo apt autoremove
```

[some more space reduction stuff here](README.space.md)

### Packages I need

```bash
#  update
sudo apt update
sudo apt upgrade -y

# packages i normally use
sudo apt install -y net-tools ssh btop htop vim iftop curl git gcc make \
    build-essential libssl-dev zlib1g-dev libbz2-dev screen tmux \
    libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
    xz-utils tk-dev libffi-dev liblzma-dev
```

## Profile helpers, including the ros bit

`.vimrc` - this file simply adds a vim command `w!!` that prepends sudo onto the write command in vim - which is useful when you attempt to make changes to a write protected file.

`.tmux.conf` - this adds in mouse interractions with tmux and ties in xclip for clipboard interaction with tmux - it's not perfect - in particular if you're in tmux on a local machine, the clipboard doesn't work and you need to hold shift while click-dragging to have the clipboard play nice with your terminal.

`.editorconfig` - a very basic editorconfig.

### the env.sh file

There are some parameters in the env file that could be reused later, if you wish to set them up, use the template:

```bash
cp example.env.sh env.sh
```

Then make your modifications!

### Getting this into your bash

```bash
ln -sf ~/linux_profile/.vimrc ~/.vimrc # optional
ln -sf ~/linux_profile/.editorconfig ~/.editorconfig # optional
ln -sf ~/linux_profile/.tmux.conf ~/.tmux.conf # optional
# Termide - optional
## config dir
[ ! -s  ~/.config/termide ] && mkdir -p ~/.config/termide/
[ ! -s  ~/.config/termide/config.toml ] && ln -sf ~/linux_profile/termide.toml ~/.config/termide/config.toml


echo 'source ~/linux_profile/profile.sh humble' >> ~/.bashrc
# the 'humble' bit is to source in the ROS bash file
# it works for whatever the ROS folder is called - this could be done more elegantly
source ~/.bashrc
```

More details about [ROS helpers here](README.ROS.hacks.md)

## Git

If you've created your env.sh file

```bash
profile_setup_git
```

Otherwise, the old fashioned way.

```bash
git config --global user.email "user@email.domain"
git config --global user.name "your name"
git config --global push.autoSetupRemote true
git config --global pull.rebase true
```

### ssh autostart

```bash
sudo systemctl enable ssh
sudo systemctl start ssh
```

### Add sudoers to Sudoers as nopasswd

```ini
%sudo   ALL=NOPASSWD: ALL
```

### pyenv

pyenv [from here](https://github.com/pyenv/pyenv-installer)

check the script is sane and then:

```bash
curl https://pyenv.run | bash
```

Then install something python'y

```bash
pyenv install 3.13
pyenv global 3.13

#this assumes you're importing the profile.sh in your .bashrc
sb
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

## License

TLDR; I like beer, so buy me a beer if you want and I'm not responsible for how you use this code.

Actual License

```text
/* 
 * — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — 
 * “THE BEER-WARE LICENSE” (Revision 42):
 * <Spidey> wrote this file. You can do whatever you want with this code, users
 * of this code take all responsibility for the use of it. If we meet some day,
 * and you think this stuff is worth it, you can buy me a beer in return.
 * — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — 
 * Amendment 1: The author(s) of this code accept absolutely no liability for
 * any damage or general bad things that may come as part of its use. Any use
 * of this software is deemed an agreement to absolve the author(s) of any
 * liability, culpability, durability and any other “(*)ability” (good or bad).
 */
```
