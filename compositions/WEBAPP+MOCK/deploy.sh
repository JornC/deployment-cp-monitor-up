docker-compose -p {{cp.pr.id}}-{{cp.pr.hash}} up -d

docker ps -a
echo "Replacing IPs.."

IPComponents=$(docker ps -a | grep monitorup-components:{{service.MONITORUP_COMPONENTS.hash}} | cut -d ' ' -f 1 | xargs docker inspect | grep IPAddress | tail -1 | cut -d ':' -f 2 | cut -d '"' -f 2)
IPMonitorup=$(docker ps -a | grep monitorup-wui:{{service.MONITORUP_WUI.hash}} | cut -d ' ' -f 1 | xargs docker inspect | grep IPAddress | tail -1 | cut -d ':' -f 2 | cut -d '"' -f 2)
IPMock=$(docker ps -a | grep monitorup-mock:{{service.MONITORUP_MOCK.hash}} | cut -d ' ' -f 1 | xargs docker inspect | grep IPAddress | tail -1 | cut -d ':' -f 2 | cut -d '"' -f 2)

echo "IPComponents is:"
echo $IPComponents
echo "IPMonitorup is:"
echo $IPMonitorup
echo "IPMock is:"
echo $IPMock

replaceMonitorup="sed -i -- 's/{{host.monitorup.ip}}/${IPMonitorup}/g' site.conf"
replaceComponents="sed -i -- 's/{{host.components.ip}}/${IPComponents}/g' site.conf"
replaceMock="sed -i -- 's/{{host.mock.ip}}/${IPMock}/g' site.conf"

eval $replaceMonitorup
eval $replaceComponents
eval $replaceMock

echo "Replacements complete."

cp site.conf /etc/apache2/sites-available/{{cp.pr.id}}.conf
a2dissite {{cp.pr.id}}
a2ensite {{cp.pr.id}}
sudo /etc/init.d/apache2 reload
sudo /usr/sbin/service apache2 reload

echo "Site enabled"

