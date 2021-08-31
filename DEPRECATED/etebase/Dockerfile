FROM python:3.8-slim-buster

RUN apt update -y && \
	apt install -y wget && \
	wget https://pim.etesync.com/etesync-web.tgz && \
	tar -xzf etesync-web.tgz && \
	rm etesync-web.tgz

WORKDIR /etesync-web

CMD [ "python3", "-m", "http.server" ]
