which gsutil
exit
sudo -iu www-data bash -c "mkdir -p /var/www/.gcp/.ilm/"
sudo mkdir -p /var/www/.gcp/.ilm/ && sudo chown -R www-data:www-data /var/www/.gcp
cd /var/www/.gcp
ls -la
ls -al
cd .csi/
exit
sudo mv -v ~/ilm-opa-tst-sa-compute-instance.json /var/www/
sudo mkdir -p /var/www/.gcp/.ilm/ && sudo chown -R www-data:www-data /var/www/.gcp
sudo mv -v /var/www/ilm-opa-tst-sa-compute-instance.json /var/www/.gcp/.ilm/
sudo mkdir -p /var/www/.gcp/.ilm/ && sudo chown -R www-data:www-data /var/www/.gcp
sudo updatedb
sudo locate settings.php
sudo vim /var/www/html/wp-settings.php
sudo systemctl status nginx
sudo systemctl restart nginx
fg
sudo less  /var/www/html/wp-settings.php
sudo find /var/log/nginx/
sudo less /var/log/nginx/error.log
sudo less /var/log/nginx/access.log

fg
sudo locate wp-config.php
fgg
fg
sudo less /var/www/html/wp-settings.php
sudo less /var/www/html/wp-config.php
fg
# Restart PHP-FPM
sudo systemctl restart php7.4-fpm
# Restart Nginx
sudo systemctl restart nginx
sudo find /var/log/nginx/
sudo less /var/log/nginx/error.log
fg
sudo less /var/log/nginx/error.log
sudo less /var/www/html/wp-config.php
curl "http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/email" -H "Metadata-Flavor: Google"
gsutil ls gs://ilm-opa-tst-site
echo "This is a test file." > /tmp/testfile.txt
gsutil cp /tmp/testfile.txt gs://ilm-opa-tst-site/
gsutil ls gs://ilm-opa-tst-site/testfile.txt
# Restart PHP-FPM
sudo systemctl restart php7.4-fpm
# Restart Nginx
sudo systemctl restart nginx
sudo less /var/www/html/wp-content/debug.log
sudo touch /var/www/html/wp-content/debug.log
sudo chown www-data:www-data /var/www/html/wp-content/debug.log
sudo chmod 664 /var/www/html/wp-content/debug.log
sudo mkdir -p /var/www/html/wp-content/
sudo touch /var/www/html/wp-content/debug.log
sudo chown www-data:www-data /var/www/html/wp-content/debug.log
sudo chmod 664 /var/www/html/wp-content/
sudo chown www-data:www-data /var/www/html/wp-content/
sudo less /var/www/html/wp-content/debug.log
sudo vim /var/www/html/wp-config.php
wp plugin status advanced-custom-fields
cd /var/www/html/
wp plugin status advanced-custom-fields
wp plugin activate advanced-custom-fields
