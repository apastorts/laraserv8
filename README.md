# Laraserv8 - Laravel Server to Go

- Docker image based on Ubuntu 20.04.
- PHP 8.0 & Nginx Server for Docker. 
- Easy to run your Laravel applications.

## How to use?

Run

`docker run -d -v [your projet directory]:/var/www/html apastorts/laraserv8`

And enjoy your project on your browser.

> **Note:** Do not forget to run `composer install` from within the Docker image:
> `docker exec [Container ID] composer install`
