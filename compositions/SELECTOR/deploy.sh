docker-compose -p SELECTOR-{{cp.pr.id}}-{{cp.pr.hash}} up -d

docker ps -a
echo "Replacing IPs.."

IPSelector=$(docker ps -a | grep monitorup-selector:{{service.MONITORUP_SELECTOR.hash}} | cut -d ' ' -f 1 | xargs docker inspect | grep IPAddress | tail -1 | cut -d ':' -f 2 | cut -d '"' -f 2)

echo "IPSelector is:"
echo $IPSelector

replaceSelector="sed -i -- 's/{{host.selector.ip}}/${IPSelector}/g' site.conf"

eval $replaceSelector

echo "Replacements complete."

cp site.conf /etc/apache2/sites-available/{{cp.pr.id}}-selector.conf
a2dissite {{cp.pr.id}}-selector
a2ensite {{cp.pr.id}}-selector
sudo /etc/init.d/apache2 reload
sudo /usr/sbin/service apache2 reload

echo "Site enabled"
