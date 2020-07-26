require 'serverspec'

# Required by serverspec
set :backend, :exec

describe package('nginx'), :if => os[:family] == 'redhat' do
  it { should be_installed }
end

describe package('nginx-light'), :if => os[:family] == 'ubuntu' do
  it { should be_installed }
end

describe service('nginx'), :if => os[:family] == 'redhat' do
  it { should be_enabled }
  it { should be_running }
end

describe service('nginx'), :if => os[:family] == 'ubuntu' do
  it { should be_enabled }
  it { should be_running }
end

describe service('org.nginx.httpd'), :if => os[:family] == 'darwin' do
  it { should be_enabled }
  it { should be_running }
end

#describe port(80) do
#  it { should be_listening }
#end

describe port(443) do
  it { should be_listening }
end

describe file('/etc/nginx/harden-nginx-common') do
  it { should be_file }
end
describe file('/etc/nginx/harden-nginx-https') do
  it { should be_file }
end
describe file('/etc/nginx/sites-enabled/https'), :if => os[:family] == 'ubuntu' do
  it { should be_file }
end

describe command('curl -vk https://localhost') do
  its(:stdout) { should match /<title>Welcome to nginx!<\/title>/ }
  its(:stderr) { should match /SSL connection using TLSv1.2/ }
  its(:stderr) { should match /HTTP\/.* 200/ }
  its(:exit_status) { should eq 0 }
end
describe command('curl -vk https://localhost/nonexistent') do
  its(:stdout) { should match /<title>404 Not Found<\/title>/ }
  its(:stderr) { should match /HTTP\/.* 404/ }
  its(:exit_status) { should != 0 }
end
describe command('curl -vk -X OPTIONS https://localhost') do
  its(:stdout) { should match /<title>405 Not Allowed<\/title>/ }
  its(:stderr) { should match /HTTP\/.* 405/ }
  its(:exit_status) { should != 0 }
end

describe command('openssl s_client -connect localhost:443 < /dev/null 2>/dev/null | openssl x509 -text -in /dev/stdin') do
  its(:stdout) { should match /sha256/ }
  its(:stdout) { should match /Public-Key: \(4096 bit\)/ }
end
## enumerate ciphers? multiple openssl s_client, nmap, sslscan, ...
#http://superuser.com/questions/109213/how-do-i-list-the-ssl-tls-cipher-suites-a-particular-website-offers

