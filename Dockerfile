FROM ruby
RUN apt-get update \
&& echo "gem: --no-document" >> ~/.gemrc \
&& apt-get -y install gcc postgresql libpq-dev wget $(apt-cache search libicu[0-9][0-9]|cut -d' ' -f 1) rsync libunwind-dev $(apt-cache search libssl1.0.[0-9]|cut -d' ' -f 1) \
&& gem install knife-ec-backup \
&& gem install knife-tidy \
&& wget -O azcopy.tar.gz https://aka.ms/downloadazcopylinux64 \
&& tar -xf azcopy.tar.gz \
&& ./install.sh \
&& rm -rf azcopy azcopy.tar.gz
RUN mkdir -p /root/.chef /etc/chef/trusted_certs 
COPY knife.rb /root/.chef/knife.rb
COPY admin.pem /root/.chef/admin.pem
COPY scripts/* /root/
RUN chmod 755 /root/*.sh
