#!/bin/bash

if [ -d .git ]; then
    # echo "Good, this dirctory $PWD is initialized lets's move on to the next step"
    # to skip the login with username & password and you won't be asked for them 
    git config credential.helper store
    # git config --global credential.helper store
    # git config --global credential.helper 'store --file ~/.my-credentials'
fi

check_git() {
    if (ls /bin | grep "git" >/dev/null); then
        # echo "Good, Git is installed lets's move on to the next step"
        echo >/dev/null
    else
        read -p "Git is not installed, would you like to install it? [y/n] " install_git
        if [ "$install_git" = "y" ]; then
            sudo apt-get install git
        elif [ "$install_git" = "n" ]; then
            echo "Please install Git and try again"
            exit 1
        else
            echo "Invalid input, Please enter y or n"
            check_git
        fi
    fi
}
check_git 

if (git config -l | grep user.name >/dev/null); then
    clear
    echo "Good, Git is installed & configured lets's move on to the next step"
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
        echo "Good, Git is installed & configured lets's move on to the next step"
        echo
    else
        echo "Please configure git and run this script again"
        exit 1
    fi
fi

clone_fun() {

    read -p "Enter the URL of the repository you want to clone: " repo_url
    read -p "Enter GitHub repository name: " repo_name

    echo
    read -p "Do you want to clone $repo_name here? [y/n] " clone_here

    if [ "$clone_here" = "y" ]; then

        # git clone https://github.com/Osama-Yusuf/Git-Repo-Pusher ~/repos/github/
        git clone $repo_url $repo_name

        cd "$repo_name"
        
        clear
        echo "$repo_name cloned successfully here: $PWD"
        
    elif [ "$clone_here" = "n" ]; then

        read -p "Enter a directory full path that you want to clone the repository in (ex. /home/user/RepoName): " repo_dir
        git clone $repo_url $repo_dir

        cd $repo_dir
        
        clear
        echo "$repo_name cloned successfully here: $PWD"
        
    else
        echo "Invalid input, Please enter y or n"
        clone_fun
    fi
}
want_to_clone() {
    read -p "Do you want to clone a remote repo? (y/n) " clone_init
    if [ "$clone_init" = "y" ]; then
        clear
        clone_fun
    elif [ "$clone_init" = "n" ]; then
        clear
    else
        clear
        echo "Invalid input, Please enter y or n"
        want_to_clone
    fi
}
want_to_clone

init_fun() {
    # dicover project files in a git repository
    # read -p "Did you execute git init command here before? (y/n) " answer_init
    # if (ls -a | grep ".git" >/dev/null); then
    if [ -d .git ]; then
        clear
        echo "Good, this dirctory $PWD is initialized lets's move on to the next step"
        git config credential.helper store
        echo
    else
        read -p "This directory $PWD is not initialized do you want to execute 'git init' (h)ere or check (e)lsewhere? [h/e] " check_init
        if [ "$check_init" = "h" ]; then
            clear
            git init -q
            echo "Directory is initialized"
            git config credential.helper store
            echo
        elif [ "$check_init" = "e" ]; then
            read -p "Please enter full path of the directory you want to perform git operations in it: " init_path
            echo
            cd $init_path
            init_fun
        else
            echo "Invalid input, Please enter h or y"
            init_fun
        fi
    fi
}
init_fun

# checking if there's a .gitignore file in the directory and if not, create one
check_gitignore() {
    # check if user is running the script in the project or from bin
    if (ls -a | grep "git_hub.sh" >/dev/null); then

        if (ls -a | grep ".gitignore" >/dev/null); then

            if (cat .gitignore | grep git_hub.sh >/dev/null); then
                echo > /dev/null
            else
                echo git_hub.sh >> .gitignore
            fi

            if (cat .gitignore | grep ".gitignore" >/dev/null); then
                echo > /dev/null
            else
                echo ".gitignore" >> .gitignore
            fi
        else
            touch .gitignore
            echo .gitignore >> .gitignore
            echo git_hub.sh >> .gitignore
        fi

    else
        echo "this script is running from bin" >/dev/null
    fi
}
check_gitignore

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
        echo
        git remote
        git remote -v
        echo

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
            read -p "Enter remote repository name you want to remove: " remove_remote_repository_name
            echo
            git remote rm $remove_remote_repository_name
            clear
            echo "$remove_remote_repository_name removed"
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

# check if there's a README.md file in the directory and if not ask if the user wants to create one
check_readme() {
    if (ls -a | grep "README.md" >/dev/null); then
        echo >/dev/null
    else
        read -p "There is no README.md file here, Do you want to create one? (y/n) " answer_readme
        if [ "$answer_readme" = "y" ]; then
            echo
            read -p "Enter the title of the project: " project_title
            echo
            echo "# $project_title" > README.md
            clear
            echo "README.md created"
            echo
        elif [ "$answer_readme" = "n" ]; then
            echo >/dev/null
        else
            echo "Invalid input, Please enter y or n"
            check_readme
        fi
    fi
}
check_readme

# check for unmodified files & uncommited changes
add_remove_restore_files() {

    missed_add_fun() {
        read -p "Missed files or made a typo? (y/n) " missed_add
        if [ "$missed_add" = "y" ]; then
            add_remove_restore_files
        elif [ "$missed_add" = "n" ]; then
            clear
        else
            clear
            echo "Invalid input, Please enter y or n"
            echo
            missed_add_fun
        fi
    }

    add_files() {
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
            clear
            echo "$file_name added successfully"
            echo
            missed_add_fun
        elif [ "$answer_add" = "n" ]; then
            clear
            echo "No files added"
	        echo
        else
            clear
            echo "Invalid input, Please enter a or s or n"
            echo
	        add_files
        fi
    }

    remove_files() {
        # remove all files or remove specific files or do nothing
        read -p "Do you want to remove (a)ll files or remove (s)pecific files or do (n)othing? (a/s/n) " answer_remove
        if [ "$answer_remove" = "a" ]; then
            git rm --cached -r --dry-run .
            clear
            echo "All files removed"
            echo
        elif [ "$answer_remove" = "s" ]; then
            clear
            read -p "Enter the file name you want to remove: " file_name
            git rm --cached $file_name
            clear
            echo "$file_name removed successfully"
            echo
            missed_add_fun
        elif [ "$answer_remove" = "n" ]; then
            clear
            echo "No files removed"
	        echo
        else
            clear
            echo "Invalid input, Please enter a or s or n"
            remove_files
        fi
    }

    restore_files() {
        # restore all files or restore specific files or do nothing (restore deleted files or discrad changes to files)
        read -p "Do you want to restore (a)ll files or restore (s)pecific files or do (n)othing? (a/s/n) " answer_restore
        if [ "$answer_restore" = "a" ]; then
            git restore --staged .
            clear
            echo "All files restored"
            echo
        elif [ "$answer_restore" = "s" ]; then
            clear
            read -p "Enter the file name you want to restore: " file_name
            git restore $file_name
            clear
            echo "$file_name restored successfully"
            echo
            missed_add_fun
        elif [ "$answer_restore" = "n" ]; then
            clear
            echo "No files restored">/dev/null
            echo
        else
            clear
            echo "Invalid input, Please enter a or s or n"
            restore_files
        fi
    }

    # add_remove_skip() {
    #     # do you want to add or files
    #     read -p "Do you want to (a)dd or (r)emove files to/from git repo or (s)kip this step? (a/r/s) " answer_add_remove
    #     if [ "$answer_add_remove" = "a" ]; then
    #         add_files
    #     elif [ "$answer_add_remove" = "r" ]; then
    #         remove_files
    #     elif [ "$answer_add_remove" = "s" ]; then
    #         clear
    #         echo "No files were added or removed"
    #         echo
    #     else
    #         clear
    #         echo "Invalid input, Please enter a or r or s"
    #         add_remove_files
    #     fi
    # }

    if [ "$(git status | grep "git add" | wc -l)" -gt 0 ]; then
        git status
	    echo
        add_files
    fi

    # check if there's deleted or modified files
    # if [ "$(git status | grep "deleted" | wc -l)" -gt 0 ]; then
    git status
    echo
    remove_files
    # fi

    if [ "$(git status | grep "git restore" | wc -l)" -gt 0 ]; then
        git status
	    echo
        restore_files
    fi
}

commit() {
    # commit the changes
    read -p "Commit the changes? (y/n) " answer_commit
    if [ "$answer_commit" = "y" ]; then
        read -p "Enter commit message: " commit_message
        git commit -m "$commit_message"
        clear
        echo "Commited successfully: $commit_message"
        echo
    elif [ "$answer_commit" = "n" ]; then
        clear
        echo "No changes committed"
	    echo
    else
        clear
        echo "Invalid input, Please enter y or n"
        commit
    fi
}

# check if there's changes to commit
if [ "$(git status --porcelain)" != "" ]; then
    add_remove_restore_files
    if [ "$(git status | grep "Changes to be committed" | wc -l)" -gt 0 ]; then
        commit
    fi
else
    echo "No changes/files to add, remove or commit"
    echo
fi

undo_commit_fun() {
    read -p "Do you want to undo the last commit? (y/n) " undo_commit

    if [ "$undo_commit" = "y" ]; then
        git reset --soft HEAD~1
        clear
        echo "Last commit undone"
    elif [ "$undo_commit" = "n" ]; then
        clear
        echo "Last commit remains"
    else
        clear
        echo "Invalid input, Please enter y or n"
        undo_commit_fun
    fi
}
undo_commit_fun

echo
git status
echo

remote_branch_vars() {
    # checking if the remote repository & branch variables are set
    if [ -z "$remote_repository_name" ]; then
        if [ -z "$branch_name" ]; then
            # echo "vars are empty"
            echo
            read -p "Enter the remote repository name you want to push/pull to (ex. origin): " remote_repository_name
            read -p "Enter the branch name you want to push/pull to (ex. main): " branch_name
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
        git pull $remote_repository_name $branch_name
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
	    clear
        echo "No changes pushed"
	    echo
    else
        clear
        echo "Invalid input, Please enter y or n"
        push
    fi
}
push

echo Made By Osama-Yusuf
echo My Linkedin: https://www.linkedin.com/in/osama--youssef/
echo GitHub Repo: https://github.com/Osama-Yusuf/Git-Repo-Pusher

# check if script is source or not
# if not reload bash to save changes like "cd dirctory"
# must be kept at the end of the script after the last command
if [ "$0" = "$BASH_SOURCE" ]; then
    # if not sourced
    $SHELL
fi

# Made by Osama-Yusuf
# GitHub Repo: https://github.com/Osama-Yusuf/Git-Repo-Pusher
# My Linkedin: https://www.linkedin.com/in/osama--youssef/
