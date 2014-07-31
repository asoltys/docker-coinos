FROM phusion/passenger-customizable:0.9.11
ENV HOME /root
CMD ["/sbin/my_init"]

ADD enable_repos.sh /build/enable_repos.sh
RUN chmod +x /build/enable_repos.sh
RUN /build/enable_repos.sh
RUN /build/nodejs.sh
RUN /build/redis.sh

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD coinos.conf /etc/nginx/sites-enabled/coinos.conf
RUN git clone https://github.com/thebitcoincoop/coinos /home/app/coinos

RUN rm -f /etc/service/nginx/down
RUN rm -f /etc/service/redis/down

EXPOSE 443
