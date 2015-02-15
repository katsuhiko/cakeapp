#
# Cookbook Name:: phpenv
# Recipe:: default
#
# Copyright 2015, Katsuhiko Nagashima
#
# All rights reserved - Do Not Redistribute
#

mysql_service 'default' do
  version '5.6'
  initial_root_password 'password'
  action [:create, :start]
end

httpd_service 'default' do
  mpm 'prefork'
  action [:create, :start]
end

%w[ssl].each do |m|
  httpd_module m do
    action :create
  end
end

%w[gd gd-devel].each do |p|
  package p do
    action :install
  end
end

# php インストール
%w[php php-devel php-common php-cli php-pear php-pdo php-mysqlnd php-xml php-process php-mbstring php-gd php-mcrypt php-pecl-xdebug].each do |p|
  package p do
    action :install
    options "--enablerepo=remi --enablerepo=remi-php55"
  end
end

# php設定
template "php.ini" do
  path "/etc/php.ini"
  source "php.ini.erb"
  mode 0644
end
