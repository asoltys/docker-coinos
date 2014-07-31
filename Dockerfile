FROM phusion/passenger-customizable:0.9.11
ENV HOME /root
CMD ["/sbin/my_init"]

ADD enable_repos.sh /build/enable_repos.sh
RUN chmod +x /build/enable_repos.sh
RUN /build/enable_repos.sh
RUN /build/nodejs.sh
RUN /build/redis.sh
RUN /build/python.sh

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD coinos.conf /etc/nginx/sites-enabled/coinos.conf
RUN mkdir /etc/nginx/ssl
ADD coinos.io.chained.crt /etc/nginx/ssl/coinos.io.chained.crt
ADD coinos.io.key /etc/nginx/ssl/coinos.io.key
RUN git clone https://github.com/thebitcoincoop/coinos /home/app/coinos
RUN cd /home/app/coinos && npm install
RUN /home/app/coinos/fetch_rates.sh

RUN rm -f /etc/service/nginx/down
RUN rm -f /etc/service/redis/down

EXPOSE 443
