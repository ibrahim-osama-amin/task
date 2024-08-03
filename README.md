I could not use Let's Encrypt as it requires a public domain and when I tried to use it with AWS public domain instance it refused 

Please enter the domain name(s) you would like on your certificate (comma and/or
space separated) (Enter 'c' to cancel): ec2-35-180-225-109.eu-west-3.compute.amazonaws.com
Requesting a certificate for ec2-35-180-225-109.eu-west-3.compute.amazonaws.com
An unexpected error occurred:
Error creating new order :: Cannot issue for "ec2-35-180-225-109.eu-west-3.compute.amazonaws.com": The ACME server refuses to issue a certificate for this domain name, because it is forbidden by policy
Ask for help or search for solutions at https://community.letsencrypt.org. See the logfile /var/log/letsencrypt/letsencrypt.log or re-run Certbot with -v for more details.


I created a self signed certificate and I uploaded it to the ubuntu as an alternative for this problem.

I created apache webserver and made the Reverse proxy redirect traffic to it

console.log (applying the playbook results)
