### Step 1: Update System Packages
First, update your system packages to ensure you have the latest software:

```bash
sudo yum update -y
```

### Step 2: Install Apache
Next, install the Apache HTTP Server package using the `yum` package manager:

```bash
sudo yum install httpd -y
```

### Step 3: Start and Enable Apache
Start the Apache service and enable it to start on boot:

```bash
sudo systemctl start httpd
sudo systemctl enable httpd
```

### Step 4: Configure Firewall
If you have a firewall running, you need to allow HTTP and HTTPS traffic. Use the `firewalld` commands to open the necessary ports:

```bash
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload
```

### Step 5: Verify Apache Installation
You can verify that Apache is running by accessing your server’s IP address in a web browser:

```
http://your_server_ip
```

You should see the Apache HTTP Server test page.

### Step 6: Configure Apache
Apache configuration files are located in the `/etc/httpd` directory. The main configuration file is `/etc/httpd/conf/httpd.conf`.

#### Virtual Hosts
To set up a virtual host, create a configuration file in the `/etc/httpd/conf.d` directory. For example, create a file named `mydomain.conf`:

```bash
sudo nano /etc/httpd/conf.d/mydomain.conf
```

Add the following content to the file:

```apache
<VirtualHost *:80>
    ServerAdmin webmaster@mydomain.com
    DocumentRoot /var/www/html/mydomain
    ServerName mydomain.com
    ErrorLog /var/log/httpd/mydomain_error.log
    CustomLog /var/log/httpd/mydomain_access.log combined
</VirtualHost>
```

#### Create Document Root
Create the document root directory and set appropriate permissions:

```bash
sudo mkdir -p /var/www/html/mydomain
sudo chown -R apache:apache /var/www/html/mydomain
```

### Step 7: Set SELinux Permissions
If SELinux is enabled, set the proper file context for the document root:

```bash
sudo semanage fcontext -a -t httpd_sys_content_t "/var/www/html/mydomain(/.*)?"
sudo restorecon -Rv /var/www/html/mydomain
```

### Step 8: Restart Apache
After making changes to the configuration files, restart the Apache service to apply the changes:

```bash
sudo systemctl restart httpd
```

### Step 9: Verify Apache Configuration
Check for any syntax errors in the Apache configuration:

```bash
sudo apachectl configtest
```

If the output is `Syntax OK`, your configuration is correct.

### Additional Configuration
- **Log Rotation**: Apache logs are managed by `logrotate`. The configuration file for Apache logs is located at `/etc/logrotate.d/httpd`.
- **Modules**: You can enable additional modules by creating symbolic links in the `/etc/httpd/conf.modules.d` directory or by adding `LoadModule` directives in the main configuration file.


>[!IMPORTANT]
> Setup of a domain is optional, as we can still generate logs for localhost.