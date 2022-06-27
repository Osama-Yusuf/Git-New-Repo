# dicover project files in a git repository
read -p "Did you execute git init command here before? (y/n) " answer_init
if [ "$answer_init" = "n" ]; then
    git init
else
    echo
fi

# check for unmodified files & uncommited changes
git status

echo

# add all files or add specific files or do nothing
read -p "Do you want to add all files or add specific files or do nothing? (a/s/n) " answer_add
if [ "$answer_add" = "a" ]; then
    git add .
elif [ "$answer_add" = "s" ]; then
    read -p "Enter the file name you want to add: " file_name
    git add $file_name
elif [ "$answer_add" = "n" ]; then
    echo "No files added"
else
    echo
fi

echo

# commit the changes
read -p "Commit the changes? (y/n) " answer_commit
if [ "$answer_commit" = "y" ]; then
    read -p "Enter commit message: " commit_message
    git commit -m "$commit_message"
else
    echo
    echo "No changes committed"
fi

echo

# check which branch you are on
git branch

echo

# to create a new branch type "git branch <branch_name>"

read -p "Do you want to switch to a different branch or remove a branch? (y/n) " answer_switch
if [ "$answer_switch" = "y" ]; then
    echo
    read -p "what do you want to do switch or remove a remote a branch? (s/r) " answer_add_remove
    if [ "$answer_add_remove" = "s" ]; then
        echo
        read -p "Enter the branch name you want to switch to: " branch_name
        git checkout $branch_name
    elif [ "$answer_add_remove" = "r" ]; then
        read -p "Enter the branch name you want to delete: " branch_name

        echo
        git branch -d $branch_name
    else
        echo "No branch added or removed"
    fi
else
    echo "No branch added or removed"
fi

echo

git remote
git remote -v

echo

read -p "Do you want to add or remove a remote repository? (y/n) " answer_remote
if [ "$answer_remote" = "y" ]; then
    read -p "what do you want to do add or remove a remote repository? (a/r) " answer_add_remove
    if [ "$answer_add_remove" = "a" ]; then
        echo
        read -p "Enter remote repository name you want to add: " remote_repository_name
        read -p "Enter remote repository URL you want to add: " remote_repository_URL
        echo
        git remote add $remote_repository_name $remote_repository_URL
    else
        if [ "$answer_add_remove" = "r" ]; then
            read -p "Enter remote repository name you want to remove: " remote_repository_name
            git remote rm $remote_repository_name
        else
            echo "No remote repository added or removed"
        fi
    fi
fi

git remote
git remote -v

echo

git status

echo

# push new changes to github
read -p "Push new changes to github? (y/n) " answer_push
if [ "$answer_push" = "y" ]; then
    git config credential.helper store
    # checking if the remote repository & branch variables are set
    if [ -z "$remote_repository_name" ]; then
        if [ -z "$branch_name" ]; then
            # echo "vars are empty"
            read -p "Enter the remote repository name you want to push to (ex. origin): " remote_repository_name
            read -p "Enter the branch name you want to push to (ex. main): " branch_name
            git push -u $remote_repository_name $branch_name
        else
            # echo "vars are NOT empty and has: $remote_repository_name $branch_name"
            git push -u $remote_repository_name $branch_name
        fi
    else
        # echo "vars are NOT empty and has: $remote_repository_name $branch_name"
        git push -u $remote_repository_name $branch_name
    fi

else
    # echo
    echo "No changes pushed to github"
fi
