server {
    listen [::]:80;
    listen 80;

    # The host name to respond to
    server_name example.com;

    # Site folder root
    root /var/www/example.com/public;

    # Specify a charset
    charset utf-8;

    index index.php index.html index.htm;

    location / {
        try_files $uri $uri/ index.php?query_string;
    }

    location ~ \.php$ {
        try_files $uri /index.php =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/run/php/php7.0-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include custom/fastcgi/fastcgi_params;
    }

    include h5bp/location/protect-system-files.conf;

    # Apply h5bp only to the css, js and images folder
    location ~ ^/(css|img|js|build)/ {
        include h5bp/basic.conf;
    }
}