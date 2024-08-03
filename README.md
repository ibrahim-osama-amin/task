TITLE:
I created a branch for each task 
The first task is in the main
Notes on the first task:
The container image of the application does not work because the application itself cannot contact the database.
I tried several times to edit the source code (config/default.json) to make the application able to reach the databases but it still does not work.

I had to install NPM in jenkins

The original code did not create a test script so I ignored its error 

sh 'npm test || true' // I ignored the error of the script as the original code did not include a test

###################################################

I assumed that the ec2 instance is ready to run docker and docker compose commands for simplicity
so I did these commands outside of the jenkinsfile
 
sudo dnf install docker -y
install docker compose

sudo curl -L "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

systemctl start docker

sudo usermod -aG docker ec2-user


sudo yum install libxcrypt-compat


###################################################
I uploaded jenkins build console output so you can confirm the build was ran successfully.
