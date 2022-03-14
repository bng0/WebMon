# WebMon

#**Setup Instruction**
1. Install **docker.io** and **docker-compose**  [apt install docker.io docker-compose (**for debian**)]
2. git clone https://github.com/bng0/WebMon.git
3. cd WebMon
4. sh run.sh - WebMon will be up and running!!
5. Setup connection to kong for Konga GUI (http://172.20.0.1:1337).
6. Setup services & routes for backend using Konga GUI.
7. Start and Stop services using **mon_start** and **mon_stop**.


The core components of the setup consists of: Modsecurity WAF, L7 routing gateway, Konga GUI for kong administration and ELK stack for log processing, visualization & storage and filebeats for log shipping.

Traffic flow:

1. Modsecurity receives HTTP(s) request and analyzes data sent using OWASP's core rule set and then forwards the traffic to the kong gateway.
2. Kong checks for the match condition to route the traffic to the respective backend and logs the request and response data.
3. Modsecurity logs request and response if any anomalies occured.
4. Logs are shipped to logstash using filebeat.
5. Logstash processes logs from modsecurity and kong gateway and creates indices to store them in elasticsearch.
6. Kibana is used to visualize logs stored in elasticsearch.

