# dicover project files in a git repository
read -p "Do you want to discover project files in a git repository? (y/n) " answer_init
if [ "$answer_init" = "y" ]; then
    git init
else
    echo 
fi

# check for unmodified files & uncommited changes
git status

echo

# add all files to the repository
read -p "Add all files to the repository? (y/n) " answer_add_all
if [ "$answer_add_all" = "y" ]; then
    git add .
else
    echo
    read -p "Add specific files to the repository? (y/n) " answer_add_specific
    if [ "$answer_add_specific" = "y" ]; then
        read -p "Enter files name: " file_name
        git add $file_name
    else 
        echo
        echo "No files added to the repository"
    fi
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

read -p "Do you want to switch to a different branch? (y/n) " answer_switch
if [ "$answer_switch" = "y" ]; then
    read -p "Enter branch name: " branch_name
    git checkout -b $branch_name
    git branch
else
    echo "No branch switched"
fi

echo

git remote
git remote -v

echo

read -p "Do you want to add or remove a remote repository? (y/n) " answer_remote
if [ "$answer_remote" = "y" ]; then
    read -p "what do you want to do add or remove a remote repository? (a/r) " answer_add_remove
    if [ "$answer_add_remove" = "a" ]; then
        read -p "Enter remote repository name: " remote_repository_name
        read -p "Enter remote repository URL: " remote_repository_URL
        git remote add $remote_repository_name $remote_repository_URL
    else
        if [ "$answer_add_remove" = "r" ]; then
            read -p "Enter remote repository name: " remote_repository_name
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
    git push -u $remote_url main
else
    echo
    echo "No changes pushed to github"
fi