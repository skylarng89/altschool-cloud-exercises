# Mini Project
<br>

- Set timezone
- Set system locale
- Update && Upgrade cache
- Change default SSH port to 5136
- Install ufw
- Allow in 5136 (IPv4 & IPv6) in UFW
- Deny in 22 (IPv4 & IPv6) in UFW
- Allow DNS, IMAP, IMAPS, POP3, POP3S, OpenSSH, SMTP, SSH, WWW Full in UFW
- Install Apache: ```apt install -y apache2 apache2-utils```
- Install elinks to view full Apache status: ```apt -y install elinks```
- Install PHP 8.1 FPM and all modules
  - Install required packages: ```apt install -y lsb-release ca-certificates apt-transport-https software-properties-common gnupg2```
  - Add Sury PPA: ```echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/sury-php.list```
  - Import GPG Key: ```curl -fsSL  https://packages.sury.org/php/apt.gpg| sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/sury-keyring.gpg```
  - Update & Upgrade Cache: ```apt -y update && apt -y upgrade```
  - Install PHP 8.1 FPM, PHP 8.1 Apache modules and other PHP 8.1 modules: ```apt install -y php8.1-fpm libapache2-mod-php8.1 php8.1-cli php8.1-common php8.1-mysql php8.1-xml php8.1-xmlrpc php8.1-curl php8.1-gd php8.1-imagick php8.1-cli php8.1-dev php8.1-imap php8.1-mbstring php8.1-opcache php8.1-soap php8.1-zip php8.1-intl php8.1-bcmath```
  - Enable PHP8.1-FPM config: ```a2enconf php8.1-fpm```
  - Reload Apache: ```systemctl reload apache2```
- Install Git: ```apt install git```
- Install composer globally
  - ```php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"```
  - ```php -r "if (hash_file('sha384', 'composer-setup.php') === '55ce33d7678c5a611085589f1f3ddf8b3c52d662cd01d4ba75c0ee0459970c2200a51f492d557530c71c15d8dba01eae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"```
  - ```php composer-setup.php```
  - ```php -r "unlink('composer-setup.php');"```
  - ```mv composer.phar /usr/local/bin/composer```
- Install MySQL
  - ```wget https://dev.mysql.com/get/mysql-apt-config_0.8.24-1_all.deb```
  - ```dpkg -i mysql-apt-config_0.8.24-1_all.deb```
  - Update Cache: ```apt -y update && apt -y upgrade```
  - ```apt install mysql-server```
- Root Pass: ```E4#mdKosC!&j*U```
- Secure MySQL: ```mysql_secure_installation```
- Create MySQL user, database, grant privileges
  - Login to MySQL: ```mysql -u root -p```
  - Create Database: ```CREATE DATABASE miniapp;```
  - Create User: ```CREATE USER 'miniapp'@'localhost' IDENTIFIED BY "Y7J*ig4c&!ppzZ";```
  - Grant user privileges: ```GRANT ALL PRIVILEGES ON miniapp.* TO 'miniapp'@'localhost';```
  - ```FLUSH PRIVILEGES;```
  - ```QUIT```
- Clone Git Repo to "/var/www": ```git clone https://github.com/f1amy/laravel-realworld-example-app.git```
- Rename git folder: ```mv laravel-realworld-example-app/ miniapp```
- Configure .env
  - ```cp .env.example .env```
  - ```nano .env```
- Install composer dependencies: ```composer create-project```
- Enable Laravel Frontend
  - cd into project folder and run: ```nano routes/web.php```
  - Uncomment: 
  <pre>/*Route::get('/', function () {
    return view('welcome');
  });*/</pre>
- Grant folder permissions
  - ```chown -R www-data:www-data /var/www/miniapp```
  - ```chmod -R 775 /var/www/miniapp```
  - ```chmod -R 775 /var/www/miniapp/storage```
  - ```chmod -R 775 /var/www/miniapp/bootstrap/cache```
- Run migration: ```php artisan migrate --seed```
- Configure Virtual Host: ```nano /etc/apache2/sites-available/miniapp.conf```
<br>

```
<VirtualHost *:80>
    ServerAdmin hello@patrickaziken.me
    ServerName miniapp.patrickaziken.me
    ServerAlias *.patrickaziken.me
    DocumentRoot /var/www/miniapp/public

    <Directory /var/www/miniapp/public>
        Options Indexes MultiViews
        AllowOverride None
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```
- Enable mod_rewrite: ```a2enmod rewrite```
- Enable site config: ```a2ensite miniapp.conf```
- Disable default site: ```a2dissite 000-default.conf```
- Test apache config: ```apachectl configtest```
- Reload Apache: ```systemctl reload apache2```
- Create .htaccess in project root:
```
<IfModule mod_rewrite.c>
  RewriteEngine On
  
  RewriteCond %{HTTPS} off
  RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]
    
  RewriteCond %{REQUEST_URI} !^/public/
  RewriteCond %{REQUEST_FILENAME} !-d
  RewriteCond %{REQUEST_FILENAME} !-f
  
  RewriteRule ^(.*)$ /public/$1
  RewriteRule ^(/)?$ public/index.php [L]
</IfModule>
```
- Install SSL with Let's Encrypt
  - Install Snapd:
    - ```apt update```
    - ```apt install snapd```
    - ```snap install core```
    - ```snap refresh core```
    - ```snap install --classic certbot```
    - ```ln -s /snap/bin/certbot /usr/bin/certbot```
  - Install SSL to Apache and domains: ```certbot --apache --agree-tos --redirect -m hello@patrickaziken.me -d miniapp.patrickaziken.me```