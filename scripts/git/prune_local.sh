git fetch --prune

for branch in $(git branch -vv | grep ': gone]' | awk '{print $1}'); do
    git branch -d $branch
done
