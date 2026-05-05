SETTINGS_TEMPLATE=/var/www/html$ROOT_DIRECTORY/install/settings-dist.php
SETTINGS_DESTINATION=/var/local/settings.php
SETTINGS_ORIGINAL_LOCATION=/var/www/html$ROOT_DIRECTORY/config/settings.php

if [ -f "$SETTINGS_ORIGINAL_LOCATION" ]; then
    #We already have a settings file
    echo "Found custom $SETTINGS_ORIGINAL_LOCATION"
    exit 0
fi

#Copy from template
cat $SETTINGS_TEMPLATE > $SETTINGS_DESTINATION

#Always set these
sed -i "s/^\$settings__root_to_server=\".*/\$settings__root_to_server=\"\/var\/www\/html\";/" $SETTINGS_DESTINATION
sed -i "s/^\$settings__server_url=\".*/\$settings__server_url=\"localhost:8080\";/" $SETTINGS_DESTINATION
sed -i "s/^\$settings__mail_transport=\".*/\$settings__mail_transport=\"phpmailer\";/" $SETTINGS_DESTINATION

#Set remaining options...
if [ -n "$ROOT_DIRECTORY" ]; then
    echo "Got ROOT_DIRECTORY=$ROOT_DIRECTORY"
    if [ $ROOT_DIRECTORY = '/' ]; then ROOT_DIRECTORY="";fi
    sed -i "s#^\$settings__root_directory=\".*#\$settings__root_directory=\"$ROOT_DIRECTORY\";#" $SETTINGS_DESTINATION
fi

if [ -n "$SERVER_URL" ]; then
    echo "Got SERVER_URL=$SERVER_URL"
    sed -i "s/^\$settings__server_url=\".*/\$settings__server_url=\"$SERVER_URL\";/" $SETTINGS_DESTINATION
fi

if [ -n "$SERVER_PROTOCOL" ]; then
    echo "Got SERVER_PROTOCOL=$SERVER_PROTOCOL"
    sed -i "s#^\$settings__server_protocol=\".*#\$settings__server_protocol=\"$SERVER_PROTOCOL\";#" $SETTINGS_DESTINATION
fi

if [ -n "$MYSQL_HOST" ]; then
    echo "Got MYSQL_HOST=$MYSQL_HOST"
    sed -i "s/^\$site__database_host=\".*/\$site__database_host=\"$MYSQL_HOST\";/" $SETTINGS_DESTINATION
fi

if [ -n "$MYSQL_DATABASE" ]; then
    echo "Got MYSQL_DATABASE=$MYSQL_DATABASE"
    sed -i "s/^\$site__database_database=\".*/\$site__database_database=\"$MYSQL_DATABASE\";/" $SETTINGS_DESTINATION
fi

if [ -n "$MYSQL_USER" ]; then
    echo "Got MYSQL_USER=$MYSQL_USER"
    sed -i "s/^\$site__database_admin_username=\".*/\$site__database_admin_username=\"$MYSQL_USER\";/" $SETTINGS_DESTINATION
fi

if [ -n "$MYSQL_PASSWORD" ]; then
    sed -i "s/^\$site__database_admin_password=\".*/\$site__database_admin_password=\"$MYSQL_PASSWORD\";/" $SETTINGS_DESTINATION
fi

if [ -n "$MYSQL_TABLE_PREFIX" ]; then
    echo "Got MYSQL_TABLE_PREFIX=$MYSQL_TABLE_PREFIX"
    sed -i "s/^\$site__database_table_prefix=\".*/\$site__database_table_prefix=\"$MYSQL_TABLE_PREFIX\";/" $SETTINGS_DESTINATION
fi

if [ -n "$TIMEZONE" ]; then
    echo "Got TIMEZONE=$TIMEZONE"
    sed -i "s#^date_default_timezone_set.*#date_default_timezone_set\('$TIMEZONE'\);#" $SETTINGS_DESTINATION
fi

if [ -n "$SMTP_HOST" ]; then
    echo "Got SMTP_HOST=$SMTP_HOST"
    sed -i "s/^\$settings__phpmailer_host=\".*/\$settings__phpmailer_host=\"$SMTP_HOST\";/" $SETTINGS_DESTINATION
fi

if [ -n "$SMTP_PORT" ]; then
    echo "Got SMTP_PORT=$SMTP_PORT"
    sed -i "s/^\$settings__phpmailer_port=.*/\$settings__phpmailer_port=$SMTP_PORT;/" $SETTINGS_DESTINATION
fi

if [ -v $SMTP_SECURE ]; then
    echo "Got SMTP_SECURE=$SMTP_SECURE"
    sed -i "s/^\$settings__phpmailer_smtp_secure=\".*/\$settings__phpmailer_smtp_secure=\"$SMTP_SECURE\";/" $SETTINGS_DESTINATION
fi

if [ -n "$SMTP_AUTH_TYPE" ]; then
    echo "Got SMTP_AUTH_TYPE=$SMTP_AUTH_TYPE"
    sed -i "s/^\$settings__phpmailer_smtp_auth_type=\".*/\$settings__phpmailer_smtp_auth_type=\"$SMTP_AUTH_TYPE\";/" $SETTINGS_DESTINATION
fi

if [ -n "$SMTP_USERNAME" ]; then
    echo "Got SMTP_USERNAME=$SMTP_USERNAME"
    sed -i "s/^\$settings__phpmailer_username=\".*/\$settings__phpmailer_username=\"$SMTP_USERNAME\";/" $SETTINGS_DESTINATION
fi

if [ -n "$SMTP_PASSWORD" ]; then
    echo "Got SMTP_PASSWORD=$SMTP_PASSWORD"
    sed -i "s/^\$settings__phpmailer_password=\".*/\$settings__phpmailer_password=\"$SMTP_PASSWORD\";/" $SETTINGS_DESTINATION
fi
