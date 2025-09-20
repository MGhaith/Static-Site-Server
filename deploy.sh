#!/bin/bash
rsync -avz --delete ./static_site/ ubuntu@<EC2_PUBLIC_DNS>:/var/www/mysite
ssh ubuntu@<EC2_PUBLIC_DNS> "sudo systemctl reload nginx"
