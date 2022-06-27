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

# add the remote repository
read -p "Add the remote repository? (y/n) " answer_add_remote
if [ "$answer_add_remote" = "y" ]; then
    read -p "Enter remote repository name: " remote_name
    read -p "Enter remote repository url: " remote_url
    git remote add $remote_name $remote_url
else
    echo
    echo "No remote repository added"
fi

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