#!/usr/bin/env bash
set -x
set -e
unset -f

BUDDY_CURRENT_TESTING_BRANCH=$(cd experiment_buddy > /dev/null && git rev-parse --abbrev-ref HEAD)
function align_example_branch() { (
  cd examples
  if ! git ls-remote --exit-code --heads git@github.com:ministry-of-silly-code/examples.git "$BUDDY_CURRENT_TESTING_BRANCH" > /dev/null; then
    # There is no examples branch, create it and push it
    git checkout -b $BUDDY_CURRENT_TESTING_BRANCH origin/master
    git push -u origin HEAD
  elif ! git rev-parse --verify $BUDDY_CURRENT_TESTING_BRANCH > /dev/null; then
    # Otherwise checkout it
    git checkout $BUDDY_CURRENT_TESTING_BRANCH
  fi

  # Set the correct branch in the requirements 
  sed -i -e "s|\.git.*\#egg|\.git\@$BUDDY_CURRENT_TESTING_BRANCH\#egg|" requirements.txt
) }

function update_repo() {
  sleep 1

    meta exec "git add -A \
          && git commit -q -m \"Testing changes\" \
          && git push -q --force \
          && git reset --soft HEAD~1 \
          || echo nothing to commit"
}

function run_deploy() {
  echo Loading Docker
  DEPLOY_DESTINATION=$1
  docker run -v ~/.ssh:/root/.ssh --rm -i \
             -e WANDB_API_KEY="$WANDB_API_KEY" \
             -e GIT_MAIL=$(git config user.email) \
             -e GIT_NAME=$(git config user.name) \
             -e BUDDY_CURRENT_TESTING_BRANCH="$BUDDY_CURRENT_TESTING_BRANCH" \
             -e DEPLOY_DESTINATION="$DEPLOY_DESTINATION" \
             -v $(pwd)/test_scripts/test_flow.sh:/test_flow.sh \
             -u root:$(id -u $USER) $(docker build -f ./test_scripts/Dockerfile-flow -q .) \
             /test_flow.sh
}

clear
align_example_branch
update_repo
run_deploy $1
