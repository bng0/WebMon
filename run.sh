docker build -t custom/kong:1 . -f ./kong/Dockerfile
if [ ! -f "./tmp/modsec_audit.log" ]; then
  touch ./tmp/modsec_audit.log
  chmod -Rf 777 ./tmp/
fi
if [ ! -f "./tmp/kong.log" ]; then
  touch ./tmp/kong.log
  chmod -Rf 777 ./tmp/
fi
docker-compose up -d
dashboard() {
  status=$(curl 172.20.0.1:5601/app/home/ -I -w "%{http_code}" -s -o /dev/null)
}

while true; do
  sleep 5
  dashboard
  if [ "$status" = "200" ]; then
    curl -s http://172.20.0.1:5601/api/saved_objects/_import?overwrite=true -H "kbn-xsrf: true" --form file=@./kibana/saved_objects.ndjson 1>/dev/null
    echo -e "\nkibana dashboard installed"
    break
  else
    echo "Waiting for kibana to start - status code - " $status
  fi
done

file_log_extended() {
  status=$(curl 172.20.0.1:8001 -I -s -w "%{http_code}" -o /dev/null)
}
while true; do
  sleep 5
  file_log_extended
  if [ "$status" = 200 ]; then
    st_code=$(curl -s -XPOST 172.20.0.1:8001/plugins/ --data "name=file-log-extended" --data "config.path=/tmp/kong.log" -w "%{http_code}" -o /dev/null)
    if [ "$st_code" = 200 ]; then
      echo -e "\nfile-log-extended configured"
    else
      echo -e "\nfile-log-extended is already installed"
    fi
    break
  else
    echo "Waiting for kong to start - status code - " $status
  fi
done

check_start=$(grep mon_start ~/.bashrc | awk 'END{print NR}')
if [ "$check_start" = 0 ]; then
  echo "alias mon_start='docker start db_api kong_api konga_api modsec_api elasticsearch_api logstash_api kibana_api filebeat_modsec_api filebeat_kong_api'" >> ~/.bashrc
fi
check_stop=$(grep mon_stop ~/.bashrc | awk 'END{print NR}')
if [ "$check_stop" = 0 ]; then
  echo "alias mon_stop='docker stop filebeat_kong_api filebeat_modsec_api kibana_api logstash_api elasticsearch_api modsec_api konga_api kong_api db_api'" >> ~/.bashrc
fi
source ~/.bashrc
echo -e "\nSetup is complete, now start and stop the application with command \033[0;31mmon_start\033[0m and \033[0;31mmon_stop\033[0m\n"
