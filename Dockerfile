FROM base/archlinux
MAINTAINER thermionix

RUN curl -o /etc/pacman.d/mirrorlist.backup "https://www.archlinux.org/mirrorlist/?country=all&use_mirror_status=on"
RUN sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist.backup
RUN rankmirrors -n 6 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist

RUN pacman-key --refresh-keys
RUN pacman -Syu --noconfirm
RUN pacman-db-upgrade

RUN	pacman -S --needed supervisor git nginx php-fpm sqlite php-sqlite --noconfirm
RUN	pacman -Scc --noconfirm

RUN	sed -i "s,;date.timezone =.*,date.timezone = Australia/Melbourne,g" /etc/php/php.ini
RUN sed -i 's,;extension=pdo_sqlite.so,extension=pdo_sqlite.so,g' /etc/php/php.ini

RUN	git clone https://github.com/marienfressinaud/FreshRSS.git /srv/http/freshrss

RUN	chown -R http:http /srv/http

ADD	nginx.conf /etc/nginx/nginx.conf
ADD	freshrss.conf /etc/nginx/sites-enabled/freshrss.conf

ADD nginx.ini /etc/supervisor.d/nginx.ini
ADD php-fpm.ini /etc/supervisor.d/php-fpm.ini


VOLUME ["/srv/http/freshrss/data"]

EXPOSE 80

CMD ["supervisord", "-c", "/etc/supervisord.conf", "-n"]
