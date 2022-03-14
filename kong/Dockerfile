FROM kong:alpine
USER root
WORKDIR /tmp/
RUN bash -c 'git clone https://github.com/wshirey/kong-plugin-file-log-extended.git'
WORKDIR /tmp/kong-plugin-file-log-extended/
RUN luarocks make kong-plugin-file-log-extended-1.2-1.rockspec
WORKDIR /tmp/
RUN bash -c 'rm -rf kong-plugin-file-log-extended'
WORKDIR /usr/local/kong/
