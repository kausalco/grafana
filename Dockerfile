FROM grafana/grafana:4.6.2
ADD ./bin/grafana-server /usr/sbin/grafana-server
ADD ./public/ /usr/share/grafana/public/
