#!/bin/bash
rsync -avz --delete ./static_site/ ubuntu@<EC2_PUBLIC_IP>:/var/www/mysite/
ssh ubuntu@<EC2_PUBLIC_IP> "sudo systemctl reload nginx"