# Cleaning up space

This is a braindump of what I've found to clear space from Linux installs - particularly useful if you're creating images of Pi's.

## Docker stuff

The aliases below agressively delete and prune docker files around the place.

```bash
# Docker bits
alias sn_dockerRMC='docker rm $(docker ps -a -q)' # Delete all containers
alias sn_dockerRMI='docker rmi -f $(docker images -q)' # Delete all images
alias sn_dockerRMV='docker volume rm $(docker volume ls -q)' # Delete all volumes
alias sn_dockerRMALL='docker rm $(docker ps -a -q); docker rmi -f $(docker images -q); docker volume rm $(docker volume ls -q); docker system prune -a' # Delete all and prune the layers
```

## Ubuntu general stuff

### Agressively reduce log files

```bash
journalctl --vacuum-size=100M
```

### Remove office packages from base install

```bash
sudo apt remove --purge -y libreoffice* thunderbird
```

### Remove unused packages from apt

```bash
sudo apt clean && sudo apt autoremove
```
