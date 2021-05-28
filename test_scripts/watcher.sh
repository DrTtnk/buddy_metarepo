#!/usr/bin/env bash
set -e
BUDDY_CURRENT_TESTING_BRANCH=$(git rev-parse --abbrev-ref HEAD)

function align_example_branch() { (
  cd examples
  if [ git ls-remote --exit-code --heads git@github.com:user/repo.git $BUDDY_CURRENT_TESTING_BRANCH ]; then
  elif [ git rev-parse --verify $BUDDY_CURRENT_TESTING_BRANCH ]; then
    git checkout -b $BUDDY_CURRENT_TESTING_BRANCH master
    sed -i "s|\.git\#egg|\.git\@$BUDDY_CURRENT_TESTING_BRANCH\#egg|" requirements.txt
    git 
  fi
) }

function update_repo() {
  sleep 1

  meta exec "git add -A"
  meta exec "git commit -m \"Testing changes\" && git push --force && git reset --soft HEAD~1"
}

function run_on_cluster() {
  docker run -v ~/.ssh:/root/.ssh --rm -i \
             -e WANDB_API_KEY=$WANDB_API_KEY \
             -e GIT_MAIL=$(git config user.email) \
             -e GIT_NAME=$(git config user.name) \
             -e BUDDY_CURRENT_TESTING_BRANCH=$(git rev-parse --abbrev-ref HEAD) \
             -v $(pwd)/experiment_buddy/test_scripts/test_flow.sh:/test_flow.sh \
             -e ON_CLUSTER=1 \
             -u root:$(id -u $USER) $(docker build -f ./Dockerfile-flow -q .) \
             /test_flow.sh
}

clear
align_example_branch
# update_repo
# run_on_cluster
