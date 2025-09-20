# Static Site Server
A basic linux server configured to serve a static site.

## Setup
### 1. Provision a Remote Linux Server (AWS EC2)

1. Log in to [AWS Management Console](https://aws.amazon.com/console/).

2. Go to EC2 and launch a new instance:

    - Choose Ubuntu 22.04 LTS (or latest stable version).

    - Select a free-tier eligible instance type (e.g., `t3.micro`).

    - Configure networking → allow inbound traffic on ports 22 (SSH), 80 (HTTP), and optionally 443 (HTTPS).

    - Create and download your key pair (e.g., `aws-key.pem`).

    - Launch the instance.

3. Locate and copy your instance Public DNS in the EC2 dashboard.
#### 2. Connect via SSH
On your local machine:
```bash
chmod 400 aws-key.pem
ssh -i aws-key.pem ubuntu@<EC2_PUBLIC_IP>
```
### 3. Install and Configure Nginx
```bash
sudo apt update && sudo apt install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx
```
> **Note**: Nginx default page is at http://<EC2_PUBLIC_IP>.
### 4. Set Up Your Static Site
On the server:
```bash
sudo mkdir -p /var/www/mysite
sudo chown -R $USER:$USER /var/www/mysite
```

### 5. Upload Your Static Site Files
On your local machine (not inside SSH):
```bash
scp -i aws-key.pem /path/to/your/static-site/* ubuntu@<EC2_PUBLIC_IP>:/var/www/mysite/
```
>**Note:** For repeated deploys use the `deploy.sh` script instead.
### 6. Configure Nginx to Serve the Site
On the server:
Create a new server block:
```bash
sudo nano /etc/nginx/sites-available/mysite
```
```nginx
server {
    listen 80;
    server_name <YOUR_DOMAIN_OR_IP>;

    root /var/www/mysite;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
```

Enable config and reload:
```bash
sudo ln -s /etc/nginx/sites-available/mysite /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```
### 7. Point Domain (Optional)

- Update your DNS provider to point your domain’s A record to your server’s public IP.

- Nginx will automatically respond if server_name is set correctly.

### 8. Deploy with rsync (Optional, Linux users)
On your local machine, update `deploy.sh`:
```bash
#!/bin/bash
rsync -avz --delete -e "ssh -i ~/.ssh/aws-key.pem" ./static_site/ ubuntu@<EC2_PUBLIC_IP>:/var/www/mysite
ssh -i ~/.ssh/aws-key.pem ubuntu@<EC2_PUBLIC_IP> "sudo systemctl reload nginx"
```
Change the following:
- `./static_site/` : your local folder containing `index.html`, `style.css`, `images`, etc.
- `aws-key.pem` : your private key file for SSH access.
- `<EC2_PUBLIC_IP>`: Your server’s public DNS.
> **Note**: Make sure `deploy.sh` is executable: `chmod +x deploy.sh`.

Now you can deploy with:
```bash
./deploy.sh
```

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/MGhaith/Static-Site-Server/blob/main/LICENSE) file for details.
