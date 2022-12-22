# Check if file .deploy exists 
if [ ! -f ".deploy" ]; then
    echo "❌ Cannot deploy files: .deploy file not found in $PWD. Run setup-deployment.bash to create it"
    exit 1
fi

source .deploy

echo "📦 Uploading files to $devSiteUrl"
# Print all entries of $targetDirs
for targetDir in "${targetDirs[@]}"
do
    echo "📦 Uploading files to $targetDir"
done
