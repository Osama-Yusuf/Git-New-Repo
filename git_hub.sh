if (ls /bin | grep "git" >/dev/null); then
    # echo "Good, Git is installed lets's move on the next step"
    echo >/dev/null
else
    read -p "Git is not installed, would you like to install it? [y/n] " install_git
    if [ "$install_git" = "y" ]; then
        sudo apt-get install git
    else
        echo "Please install git and run this script again"
        exit 1
    fi
fi

if (git config -l | grep user.name >/dev/null); then
    echo "Good, Git is installed & configured lets's move on the next step"
    echo
else
    read -p "Git is not configured, would you like to configure it? [y/n] " configure_git
    if [ "$configure_git" = "y" ]; then
        echo
        read -p "Please enter your UserName: " UserName
        read -p "Please enter your Email: " Email
        git config --global user.name "$UserName"
        git config --global user.email "$Email"
        echo
        echo "Good, Git is installed & configured lets's move on the next step"
        echo
    else
        echo "Please configure git and run this script again"
        exit 1
    fi
fi

init_fun() {
    # dicover project files in a git repository
    # echo
    read -p "Did you execute git init command here before? (y/n) " answer_init
    if [ "$answer_init" = "n" ]; then
        clear
        git init
        echo
    elif [ "$answer_init" = "y" ]; then
        clear
    else
        clear
        echo "Please answer y or n"
        init_fun
    fi
}
init_fun

modify_branch() {
    # check which branch you are on
    if (git branch | grep "*" >/dev/null); then
        echo >/dev/null
    else
        echo "You are not on any branch"
        echo
        read -p "Please enter a branch name to create one: " branch_name
        echo
        git checkout -b "$branch_name"
    fi

    another_branch_fun() {
        echo
        read -p "DO you want to perform another branch modification? (y/n) " another_branch
        if [ "$another_branch" = "y" ]; then
            clear
            modify_branch
        elif [ "$another_branch" = "n" ]; then
            clear
        else
            clear
            echo "Invalid input, Please enter y or n"
            echo
            another_branch_fun
        fi
    }

    git branch
    echo

    # to create a new branch type "git branch <branch_name>"
    read -p "Do you want to switch to a different branch or remove a branch? (y/n) " answer_switch
    if [ "$answer_switch" = "y" ]; then
        clear
        git branch
        # echo "You are on branch: $(git branch | grep "*" | cut -d " " -f 2)"

        echo
        read -p "what do you want to do (s)witch or (r)emove a remote a branch? (s/r) " answer_add_remove
        if [ "$answer_add_remove" = "s" ]; then
            echo
            read -p "Enter the branch name you want to switch to: " branch_name

            git branch $branch_name
            git checkout $branch_name >/dev/null

            echo
            another_branch_fun

        elif [ "$answer_add_remove" = "r" ]; then
            read -p "Enter the branch name you want to delete: " branch_name
            echo

            git branch -D $branch_name
            another_branch_fun

        else
            echo "Invalid input, Please enter s or r"
            modify_branch
        fi

        clear
        git branch
        echo
    elif [ "$answer_switch" = "n" ]; then
        clear
        # echo "No branch added or removed"
    else
        clear
        echo "Invalid input, Please enter y or n"
        modify_branch
    fi
}
modify_branch

modify_remote() {

    another_remote_fun() {
        read -p "DO you want to perform another remote repository modification? (y/n) " another_remote
        if [ "$another_remote" = "y" ]; then
            modify_remote
        elif [ "$another_remote" = "n" ]; then
            clear
        else
            clear
            echo "Invalid input, Please enter y or n"
            echo
            another_remote_fun
        fi
    }

    git remote
    git remote -v
    echo

    read -p "Do you want to add or remove a remote repository? (y/n) " answer_remote
    if [ "$answer_remote" = "y" ]; then
        clear
        git remote
        git remote -v
        echo
        read -p "what do you want to do (a)dd or (r)emove a remote repository? (a/r) " answer_add_remove
        if [ "$answer_add_remove" = "a" ]; then
            echo

            read -p "Enter remote repository name you want to add (ex. origin): " remote_repository_name
            read -p "Enter remote repository URL you want to add: " remote_repository_URL
            echo
            git remote add $remote_repository_name $remote_repository_URL
            clear
            echo "$remote_repository_name added"
            another_remote_fun

        elif [ "$answer_add_remove" = "r" ]; then
            echo
            read -p "Enter remote repository name you want to remove: " remote_repository_name
            echo
            git remote rm $remote_repository_name
            clear
            echo "$remote_repository_name removed"
            another_remote_fun
        else
            clear
            echo "Invalid input, Please enter a or r"
            modify_remote
        fi

        echo
        git remote
        git remote -v
        echo

    elif [ "$answer_remote" = "n" ]; then
        clear
    else
        echo "Invalid input, Please enter y or n"
        modify_remote
    fi
}

if (git remote | grep "" >/dev/null); then
    modify_remote
else
    read -p "Enter remote repository name you want to add (ex. origin): " remote_repository_name
    read -p "Enter remote repository URL you want to add: " remote_repository_URL
    echo
    git remote add $remote_repository_name $remote_repository_URL
    clear
    echo "$remote_repository_name added"
    echo
    modify_remote
fi

# check for unmodified files & uncommited changes
files_add() {
    git status
    echo

    missed_add_fun() {
        read -p "Missed to add files or did you make you a typo? (y/n) " missed_add
        if [ "$missed_add" = "y" ]; then
            files_add
        elif [ "$missed_add" = "n" ]; then
            clear
        else
            clear
            echo "Invalid input, Please enter y or n"
            echo
            missed_add_fun
        fi
    }
    # add all files or add specific files or do nothing
    read -p "Do you want to add (a)ll files or add (s)pecific files or do (n)othing? (a/s/n) " answer_add
    if [ "$answer_add" = "a" ]; then
        git add .
        clear
        echo "All files added"
        echo
    elif [ "$answer_add" = "s" ]; then
        clear
        read -p "Enter the file name you want to add: " file_name
        git add $file_name
        echo
        echo "$file_name added successfully"
        echo
        missed_add_fun
        clear
        echo "$file_name added successfully"
        echo
    elif [ "$answer_add" = "n" ]; then
        clear
        echo "No files added"
    else
        clear
        echo "Invalid input, Please enter a or s or n"
        files_add
    fi
}
files_add

commit() {
    # commit the changes
    read -p "Commit the changes? (y/n) " answer_commit
    if [ "$answer_commit" = "y" ]; then
        read -p "Enter commit message: " commit_message
        git commit -m "$commit_message"
        clear
        echo "Commited successfully: $commit_message"
    elif [ "$answer_commit" = "n" ]; then
        clear
        echo "No changes committed"
    else
        clear
        echo "Invalid input, Please enter y or n"
        commit
    fi
}
commit

echo
git status
echo

remote_branch_vars() {
    # checking if the remote repository & branch variables are set
    if [ -z "$remote_repository_name" ]; then
        if [ -z "$branch_name" ]; then
            # echo "vars are empty"
            echo
            read -p "Enter the remote repository name you want to push to (ex. origin): " remote_repository_name
            read -p "Enter the branch name you want to push to (ex. main): " branch_name
        else
            # echo "vars are NOT empty and has: $remote_repository_name $branch_name"
            echo
        fi
    else
        # echo "vars are NOT empty and has: $remote_repository_name $branch_name"
        echo
    fi
}
pull() {
    # pull the changes from remote repository
    read -p "Do you want to pull the changes from remote repository? (y/n) " answer_pull
    if [ "$answer_pull" = "y" ]; then
        remote_branch_vars
        git pull -u $remote_repository_name $branch_name
        clear
        echo "Pulled successfully"
    elif [ "$answer_pull" = "n" ]; then
        clear
        echo "No changes pulled"
    else
        echo "Invalid input, Please enter y or n"
        pull
    fi
}
pull

push() {
    error_pushing() {
        read -p "Is there an error preventing you from pushing? (y/n) " push_error
        if [ "$push_error" = "y" ]; then
            echo
            git push --force $remote_repository_name $branch_name
            # clear
            echo
            echo "Pushed successfully"
        elif [ "$push_error" = "n" ]; then
            clear
            echo "Pushed successfully"
        else
            clear
            echo "Invalid input, Please enter y or n"
            push
        fi
    }

    # push new changes to github
    echo
    read -p "Push new changes to github? (y/n) " answer_push
    if [ "$answer_push" = "y" ]; then
        git config credential.helper store
        remote_branch_vars
        echo
        git push $remote_repository_name $branch_name
        echo
        error_pushing
        echo
    elif [ "$answer_push" = "n" ]; then
        echo "No changes pushed"
    else
        clear
        echo "Invalid input, Please enter y or n"
        push
    fi
}
push

echo Made By Osama-Yusuf
echo My Linkedin: https://www.linkedin.com/in/osama--youssef/
echo GitHub Repo: https://github.com/Osama-Yusuf/WIFI-Password-Cracker

# Made by Osama-Yusuf
# GitHub Repo: https://github.com/Osama-Yusuf/WIFI-Password-Cracker
# My Linkedin: https://www.linkedin.com/in/osama--youssef/
