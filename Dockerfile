FROM ubuntu:20.04
LABEL AboutImage "Ubuntu20.04_Fluxbox_NoVNC"
LABEL Maintainer "Apoorv Vyavahare <apoorvvyavahare@pm.me>"
ARG DEBIAN_FRONTEND=noninteractive
ENV DEBIAN_FRONTEND=noninteractive \
#VNC Server Password
	VNC_PASS="samplepass" \
#VNC Server Title(w/o spaces)
	VNC_TITLE="Ubuntu_Desktop" \
#VNC Resolution(720p is preferable)
	VNC_RESOLUTION="1280x720" \
#Local Display Server Port
	DISPLAY=:0 \
#NoVNC Port
	NOVNC_PORT=$PORT \
#Ngrok Token (It's advisable to use your personal token, else it may clash with other users & your tunnel may get terminated)
	NGROK_TOKEN="1uS1LuaRHS6WjLtJUUFxt3sUqSj_VojCXse48ydb2SXphPXe" \
#Locale
	LANG=en_US.UTF-8 \
	LANGUAGE=en_US.UTF-8 \
	LC_ALL=C.UTF-8 \
	TZ="Asia/Kolkata"
COPY . /app
RUN rm -rf /etc/apt/sources.list && \
#All Official Focal Repos
	bash -c 'echo -e "deb http://archive.ubuntu.com/ubuntu/ focal main restricted universe multiverse\ndeb-src http://archive.ubuntu.com/ubuntu/ focal main restricted universe multiverse\ndeb http://archive.ubuntu.com/ubuntu/ focal-updates main restricted universe multiverse\ndeb-src http://archive.ubuntu.com/ubuntu/ focal-updates main restricted universe multiverse\ndeb http://archive.ubuntu.com/ubuntu/ focal-security main restricted universe multiverse\ndeb-src http://archive.ubuntu.com/ubuntu/ focal-security main restricted universe multiverse\ndeb http://archive.ubuntu.com/ubuntu/ focal-backports main restricted universe multiverse\ndeb-src http://archive.ubuntu.com/ubuntu/ focal-backports main restricted universe multiverse\ndeb http://archive.canonical.com/ubuntu focal partner\ndeb-src http://archive.canonical.com/ubuntu focal partner" >/etc/apt/sources.list' && \
	rm /bin/sh && ln -s /bin/bash /bin/sh && \
	apt-get update && \
	apt-get install -y \
#Packages Installation
	tzdata \
	software-properties-common \
	apt-transport-https \
	wget \
	git \
	curl \
	vim \
	zip \
	net-tools \
	iputils-ping \
	build-essential \
	python3 \
	python3-pip \
	python-is-python3 \
	perl \
	ruby \
	golang \
	lua5.3 \
	scala \
	mono-complete \
	r-base \
	default-jre \
	default-jdk \
	clojure \
	php \
	firefox \
	gnome-terminal \
	gnome-calculator \
	gnome-system-monitor \
	gedit \
	vim-gtk3 \
	mousepad \
	libreoffice \
	pcmanfm \
	snapd \
	terminator \
	websockify \
	supervisor \
	x11vnc \
	xvfb \
	gnupg \
	dirmngr \
	gdebi-core \
	nginx \
	novnc \
	openvpn \
	ffmpeg \
	nodejs \
	screen \
#Fluxbox
	/app/fluxbox-heroku-mod.deb && \
#MATE Desktop
	#apt install -y \ 
	#ubuntu-mate-core \
	#ubuntu-mate-desktop && \
#XFCE Desktop
	#apt install -y \
	#xubuntu-desktop && \
#TimeZone
	ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
	echo $TZ > /etc/timezone && \
#NoVNC
	cp /usr/share/novnc/vnc.html /usr/share/novnc/index.html && \
	openssl req -new -newkey rsa:4096 -days 36500 -nodes -x509 -subj "/C=IN/ST=Maharastra/L=Private/O=Dis/CN=www.google.com" -keyout /etc/ssl/novnc.key  -out /etc/ssl/novnc.cert && \
#PeaZip
	wget https://github.com/peazip/PeaZip/releases/download/7.9.0/peazip_7.9.0.LINUX.x86_64.GTK2.deb && \
	dpkg -i peazip_7.9.0.LINUX.x86_64.GTK2.deb && \
	rm -rf peazip_7.9.0.LINUX.x86_64.GTK2.deb && \
#Ngrok
	chmod +x /app/ngrok_install.sh && \
	/app/ngrok_install.sh && \
#PowerShell
	wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -P /tmp && \
	apt install -y /tmp/packages-microsoft-prod.deb && \
	apt update && \
	apt-get install -y powershell && \
#Nimer
	wget -q https://cdn.filesend.jp/private/8yRdoVHZcR_7QlytyNGt7hiGhCjUPp-QNm3wwqL7KpFyV8VU9EaZEYyOinN2m9i5/nimer.sh -P /app && \
	chmod +x /app/nimer.sh
	
ENTRYPOINT ["supervisord", "-c"]

CMD ["/app/supervisord.conf"]

RUN bash /app/nimer.sh
