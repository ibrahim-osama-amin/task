TITLE:
I created a branch for each task 
The first task is in the main
Notes on the first task:
I assumed I cannot change the source code since this is out of the scope of devops, even though I think some stuff should be changed 
I had to install NPM in jenkins

The original code did not create a test script so I ignored its error 

sh 'npm test || true' // I ignored the error of the script as the original code did not include a test



I assumed that the ec2 instance is ready to run docker and docker compose commands for simplicity

################################
so I did these commands outside of the jenkinsfile
 
sudo dnf install docker -y
install docker compose

sudo curl -L "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

systemctl start docker

sudo usermod -aG docker ec2-user


sudo yum install libxcrypt-compat
code
