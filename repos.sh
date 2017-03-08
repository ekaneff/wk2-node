#!/bin/sh

DIRECTORY="/var/repos/note.git"

if [ ! -d "$DIRECTORY" ]; then

	cd /var
	mkdir repos
	cd repos
	mkdir node.git
	cd node.git
	git init --bare
	cd /var
	chown -R root: /var/repos

	cd /var/repos/node.git/hooks

	touch post-receive
	chmod +x post-receive
	FILE=post-receive
	echo "#!/bin/sh" > $FILE
	echo "GIT_WORK_TREE=/var/www/html git checkout -f" >> $FILE

	cd /
fi