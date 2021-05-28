# Buddy Meta Repo

A single repo for testing and CI purposes

## Quick startup

You'll need `nodejs` and `nodemon` installed

## Setup

```shell
npx meta git clone git@github.com:DrTtnk/buddy_metarepo.git

cd buddy_metarepo
```

if you keep the watcher running, everythign will be kept in sync all the time

## For the tester

You can quickly spin a deploy with just a command that:

1. creates a docker environment
2. setups a venv in the docker 
3. clones the example repo
4. installs Buddy locally
5. runs the deploy
6. waits for the results 
7. bonus: it detonates every time you make a single mistake, like a hand grenade :D


### Local flow
Runs a local deploy
```shell
./test_scripts/watcher.sh local
```   

### Remote flow
Runs a complete deploy on the cluster
```shell
./test_scripts/watcher.sh cluster
```

### Watcher
#### Local
```shell
nodemon --config ./test_scripts/nodemon.json -- local
```
#### Remote
```shell
#To allow the docker to communicate with the cluster you may need to change your ~/.ssh/config permissions 
sudo chown root:$USER ~/.ssh/config && sudo chmod 640 ~/.ssh/config

#The first runs is quite slow, give it a few minutes 
nodemon --config ./test_scripts/nodemon.json -- cluster
```