# Deployment of Node Project to Staging VPS (Multiple Pipelines Assignment)
#### By Emily Kaneff

For this tutorial, we will be using a simple server.js file to demonstrate the process of deploying a Node application to a virtual private server that was set up using Ansible through the use of remote git repositories.

If you have not done so already, follow the tutorial for setting up the VPS using Digital Ocean and Ansible [here](setup.md). 

>Note: This is only one of the three pipelines feeding into our servers. The others with setup and deployment instructions can be found at: <br>
>[https://github.com/ekaneff/wk2-php](https://github.com/ekaneff/wk2-php) <br>
>[https://github.com/ekaneff/wk2-static](https://github.com/ekaneff/wk2-static)

##Table of Contents

* [Create server.js File](#one)
* [Add Git Remote](#two)
* [Push to Git Remote](#three)
* [Start pm2](#four)

<a name="one"></a>
##Step One: Create server.js File

This project is set up to handle Node.js applications. Therefore, you can simply move or create your node project in the same directory as the ansible files.

For this tutorial we will simply create an `server.js` file with a simple setup to return a `hello world` message. 

To create this file, simply run in the root directory: 

```shell
nano server.js
```

and insert: 

```shell
var http = require('http');
var server = http.createServer(function (request, response) {
  response.writeHead(200, {"Content-Type": "text/plain"});
  response.end("Hello, World!");
});
server.listen(3000);
console.log('Running Node app on port 3000.');
```

This set up does not require any additional node_modules to be installed on your machine, however that is very unconventional. For a more conventional method of doing this, look through this [tutorial](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-node-js-application-for-production-on-ubuntu-16-04)

Save and close the file. 

<a name="two"></a>
## Step Two: Adding Remote Connection

When setting up our servers, the automation script went through the process of initializing a bare repository on each server. This repository contains a post-receive hook that will push the files we send to the correct live folder based on the pipeline the files are running through. 

In order to send these files, we need to create a connection locally to that remote repository. We can do this through the Git commands: 

```shell
git remote add NodeStaging ssh://root@[staging ip]:/var/repos/node.git

git remote add NodeProduction ssh://root@[production ip]:/var/repos/node.git
```

>Note that the file path at the end must remain the same as I have listed it as that is the naming convention used in the playbook. You can change this if you so wish, you just need to edit the correct line in `repos.sh`. 

## Step Three: Push to Remote

Now that the connection has been created, we can push files up to the server as we please. This is done through the command: 

```shell
git push NodeStaging [local branch]:[remote branch]
```

The local branch in this line will be whatever branch you use in your workflow that contains the version of your files ready for release. 

The remote branch is the branch on your remote repository that you want to hold the files you send. If the branch does not exit, it will be created. 

The `post-receive` hook located in the remote repository (created in our automation script) will handle the transfer of files from the repository to the live folders, so there is no need for you to go in and do it manually. 

Also note that we only pushed to the staging server, and not the production one. Pushing to production would be the same command but with the name of the connection to your remote production repository instead. In our workflow, pushing to production only happens after everything is functional on staging. 

## Step Four: Start pm2

If you have ever worked with a Node application before, you know that typically you run something like `npm start` to run your server and open the files in the browser. However, once you close your terminal, the server quits and that's the end of that session. 

To work around this, there is a package called `pm2` that will allow us to keep our session going within our VPS. Our automation script installs the package for us, but we will need to go into our server and begin the process. 

To do this, ssh into your Staging server as root: 

```shell
ssh root@[staging server ip]
``` 

and navigate to the folder where the files will be served live: 

```shell
cd /var/www/html/node
```

Once there, simply run the command: 

```shell
pm2 start server.js
```

Exit out of your server. 

You should now be able to navigate to `node.[your stage ip].xip.io` and be greeted by your `hello world` text.