server {
    listen [::]:80;
    listen 80;

    root /var/www/example.com;

    index index.php index.html index.htm index.nginx-debian.html;

    server_name example.com;

    try_files $uri $uri/ @app;
    error_page 404 = @app;

    location @app {
        include custom/fastcgi/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php7.0-fpm.sock;
        fastcgi_param   SCRIPT_FILENAME     $document_root/index.php;
        fastcgi_param   SCRIPT_NAME         $document_root/index.php;
        fastcgi_param   DOCUMENT_URI        /index.php;
    }

    include h5bp/basic.conf;
}