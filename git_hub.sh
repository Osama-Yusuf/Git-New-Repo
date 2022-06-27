# dicover project files in a git repository
git init

# check for unmodified files & uncommited changes
git status

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


# commit the changes
git commit -m "initial commit"

# add the remote repository
git remote add origin URL

git status

git push -u origin main