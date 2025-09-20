#!/bin/bash
rsync -avz --delete -e "ssh -i ~/.ssh/aws-key.pem" ./static_site/ ubuntu@<EC2_PUBLIC_IP>:/var/www/mysite
ssh -i ~/.ssh/aws-key.pem ubuntu@<EC2_PUBLIC_IP> "sudo systemctl reload nginx"

echo "Static site deployment is done!"
exit 0