# Container implementation for ORSEE - https://orsee.org

## Quickstart

    git clone https://github.com/matthewtolhurst/orsee-container.git
    cd orsee-container
    cp .env-example .env
    curl https://raw.githubusercontent.com/orsee/orsee/master/install/install.sql -o db/docker-entrypoint-initdb.d/install.sql
    docker compose up -d

Wait a few seconds then navigate to http://localhost:8080/orsee/public/

## Configuration
You can configure your ORSEE either using environment variables via `.env`, or by inserting config files into the image build process. `.env-exmaple` is given as a guide.

Supported variables and their defaults:

    SERVER_URL=localhost:8080
    SERVER_PROTOCOL=http://
    MYSQL_USER=orsee_user
    MYSQL_DATABASE=orsee_db
    MYSQL_PASSWORD=orsee_pw
    MYSQL_HOST=localhost
    MYSQL_TABLE_PREFIX=or_
    TIMEZONE=Australia/Sydney
    SMTP_HOST=host.docker.internal
    SMTP_PORT=25
    SMTP_SECURE=            # <|tls|ssl>
    SMTP_AUTH_TYPE=none     # <none|password>
    SMTP_USERNAME=
    SMTP_PASSWORD=

Required at build-time:

    ROOT_DIRECTORY=/orsee
    ORSEE_VERSION_TAG=orsee_3.4.0

Used only during database initialisation:  

    MYSQL_ROOT_PASSWORD=

Add any additional files you need to include in your image to `web/` - for example, style files to `web/var/www/html/orsee/style/mystyle`

If you include config files in the image, they will override environment variables. This is useful if you need something the environment variables don't provide.
- `web/var/www/html/orsee/config/settings.php`  
    Example file is in the ORSEE distibution as settings-dist.php  

## Live environments

This should provide a relatively cromulent ORSEE distribution. If you plan on running this in production, I leave it to you on how to deal with:
- Database backups (Hint: `docker exec orsee-container-db-1 bash -c 'mariadb-dump -u $MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE' > orseedump.sql`)
- Apache/PHP version updates (Hint: regularly rebuild your container image and redeploy)
- Cron (Hint: `docker exec orsee-container-web-1 bash -c "cd /var/www/html/orsee/admin && /usr/local/bin/php /var/www/html/orsee/admin/cron.php"`
