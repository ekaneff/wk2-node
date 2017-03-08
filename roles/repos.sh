#!/bin/sh

cd /var
mkdir repos
cd repos
mkdir node.git
cd node.git
git init --bare
cd /var

cd /var/repos/node.git/hooks

touch post-receive
FILE=post-receive
echo "#!/bin/sh" > $FILE
echo "GIT_WORK_TREE=/var/www/html/node git checkout -f" >> $FILE

cd /