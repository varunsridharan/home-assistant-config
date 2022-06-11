#!/bin/sh

key_storage_location(){
    echo "/config/.deploy-keys"
}

locate_key(){
    echo "$(key_storage_location)/${1}"
}

git_repo_path(){
    echo "/tmp/auto-backups"
}

locate_repo(){
    echo "$(git_repo_path)/${1}"
}

run_ssh_cmd(){
    REPO="$1"
    CMD="$2"
    if [ -z "$REPO" ]; then
        echo "Enter A Valid Repository Name"
        exit 1
    fi

    SSH_KEY="$(locate_key $REPO)/key"
    ssh-agent sh -c "ssh-add $SSH_KEY; $CMD"
}

clone_repo(){
    REPO="$1"
    CLONE_DIR="$2"
    run_ssh_cmd "$REPO" "git clone --no-tags --single-branch --depth=1 git@github.com:$REPO.git $CLONE_DIR"
}

pull_repo(){
    cd "$(locate_repo "$1")"
    run_ssh_cmd "$1" "git pull"
}

push_repo(){
    cd "$(locate_repo "$1")"
    run_ssh_cmd "$1" "git push $2"
}

setup_github_repo(){
    REPO="$1"
    NAME="$2"
    EMAIL="$3"

    if [ -z "$REPO" ]; then
        echo "Enter A Valid Repository Name"
        exit 1
    fi

    if [ -z "$EMAIL" ]; then
        EMAIL="githubactionbot+cache@gmail.com"
    fi

    if [ -z "$NAME" ]; then
        NAME="Auto Backup"
    fi


    REPO_DIR="$(locate_repo $REPO)"

    if [ ! -d "$REPO_DIR" ]; then
        echo " "
        echo "-------- Quick Info --------"
        echo "REPO : $REPO"
        echo "REPO_DIR : $REPO_DIR"
        echo "Name : $NAME"
        echo "Email : $EMAIL"
        echo "-------- Quick Info --------"
        echo " "
        echo "💾  Cloning $REPO"
        clone_repo "$REPO" "$REPO_DIR"
        cd $REPO_DIR
        git config user.email "$EMAIL"
        git config user.name "$NAME"
        echo " "
    else
        echo " "
        echo "Updating Repository"
        pull_repo "$REPO"
        echo " "
    fi

    if [ ! -f "$REPO_DIR/.github/.gitkeep" ]; then
        echo " "
        mkdir -p "$REPO_DIR/.github/"
        touch "$REPO_DIR/.github/.gitkeep"
        git add "$REPO_DIR/.github/.gitkeep" -f
        git commit -m "🎉 Successfully Pushed Using Deploy Keys"
        push_repo "$REPO"
        echo " "
    fi
}

ha_secrets(){
  grep ^$1: /config/secrets.yaml | sed 's/^[^:]*: //' | sed 's/ //g'
}

ha_api_trigger(){
  curl -X POST "http://127.0.0.1:8123/api/webhook/$1"
}

ha_api_trigger_secret(){
  KEY="$(ha_secrets "$1")"
  ha_api_trigger "$KEY"
}

