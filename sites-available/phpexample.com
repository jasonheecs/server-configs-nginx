server {
    listen [::]:80;
    listen 80;

    # The host name to respond to
    server_name example.com;

    # Site folder root
    root /var/www/example.com;

    # Specify a charset
    charset utf-8;

    index index.php index.html index.htm;

    location / {
        try_files $uri $uri/ =404;
    }

    location ~ \.php$ {
        include custom/fastcgi/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php7.0-fpm.sock;
    }

    include h5bp/location/protect-system-files.conf;

    # Apply h5bp only to the css, js and images folder
    location ~ ^/(css|images|js)/ {
        include h5bp/basic.conf;
    }
}