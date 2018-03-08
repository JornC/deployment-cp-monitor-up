docker-compose -p WEBAPP-{{cp.pr.id}}-{{cp.pr.hash}} up -d

docker ps -a
echo "Replacing IPs.."

IPMock=$(docker ps -a | grep monitorup-mock:{{service.MONITORUP_MOCK.hash}} | cut -d ' ' -f 1 | xargs docker inspect | grep IPAddress | tail -1 | cut -d ':' -f 2 | cut -d '"' -f 2)

echo "IPMock is:"
echo $IPMock

replaceMock="sed -i -- 's/{{host.mock.ip}}/${IPMock}/g' site.conf"

eval $replaceMock

echo "Replacements complete."

cp site.conf /etc/apache2/sites-available/{{cp.pr.id}}-mock.conf
a2dissite {{cp.pr.id}}-mock
a2ensite {{cp.pr.id}}-mock
sudo /etc/init.d/apache2 reload
sudo /usr/sbin/service apache2 reload

echo "Site enabled"
