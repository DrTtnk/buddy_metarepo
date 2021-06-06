# Buddy Meta Repo

A single repo for testing and CI purposes

## Quick startup

You'll need `nodejs`, `nodemon` and `meta` installed
```shell
sudo snap install node --classic --channel=14
npm i -g nodemon meta # sudo may be required 
```

## Setup

```shell
meta git clone git@github.com:ministry-of-silly-code/buddy_metarepo.git

cd buddy_metarepo
```

if you keep the watcher running, everything will be kept in sync all the time

## For the tester

You can quickly spin a deploy with just a command that:

1. creates a docker environment
2. setups a venv in the docker 
3. clones the example repo
4. installs Buddy locally
5. runs the deploy
6. waits for the results 
7. bonus: it detonates every time you make a single mistake, like a hand grenade :D

## Remember to enable the venv 
```shell 
# With virtualenv
virtualenv buddy_env
source ./buddy_env/bin/activate

# With Anaconda/Miniconda
conda create --name buddy_env python=3.7
conda activate buddy_env
```

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

#### In Docker
You can do the same runs within a Docker container, same conditions apply, but there is no need for a venv

```
# Local 
nodemon --config ./test_scripts/nodemon.json -- docker local

# Remote 
nodemon --config ./test_scripts/nodemon.json -- docker cluster
```
