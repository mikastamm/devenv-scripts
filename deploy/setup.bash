#!/bin/bash
# Setup connection to the production site

#check if ~/.ssh/prod.pem exists
if [ -f ~/.ssh/prod.pem ]; then
    echo "🔑 Production key found"
else
    echo "🔑 Production key not found"
    echo "➡️ Enter path to production key"
    read prodKeyPath
    cp $prodKeyPath ~/.ssh/prod.pem
fi

#Create ssh config file from ssh string (eg. "user@host")
prodSiteSshUser=$(echo $prodSiteSsh | cut -d@ -f1)
prodSiteSshHost=$(echo $prodSiteSsh | cut -d@ -f2)
if ! [ -z $prodSiteSshDir ]; then
    cdDirective=$(cat <<EOF 
    RemoteCommand cd $prodSiteSshDir && exec bash --login
    RequestTTY yes
EOF
)
else
    cdDirective=""
fi
cat >> ~/.ssh/config <<EOF
Host prod
    HostName $prodSiteSshHost
    User $prodSiteSshUser
    IdentityFile ~/.ssh/prod.pem
    $cdDirective

Host $prodSiteSshHost
    HostName $prodSiteSshHost
    User $prodSiteSshUser
    IdentityFile ~/.ssh/prod.pem
EOF


echo "✅ Done, you can now use ssh prod to connect to the production site and run dev db pull and dev deploy commands"