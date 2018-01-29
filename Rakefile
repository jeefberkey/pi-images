require 'erb'
require 'pry'
require 'yaml'

# inits = Rake::FileList['cloud-init/*.yaml']
#
# task :default => :image
# task :image => inits.ext('.img')
#
# rule '.img' => '.yaml' do |t|
#   hostname = File.basename t.source, '.*'
#   cmd  = 'flash'
#   cmd += " --hostname #{hostname}"
#   cmd += " --userdata #{t.source}"
#   cmd += " images/#{hostname}.img"
#
#   sh cmd
# end

# normal_pis = Rake::FileList['cloud-init/raspi*.yaml']
# pi_zeros = Rake::FileList['cloud-init/zero*.yaml']

hosts = YAML.load_file('hosts.yaml')['all']['children']
PIS   = hosts['pis']['hosts']
ZEROS = hosts['zeros']['hosts']

task :ansible_ping_pis do
  sh 'ansible -i hosts.yaml pis -m ping'
end

task :gen_cloud_init, [:hostname] do |t,args|
  PIS.each do |host, data|
    wifi = false

    f = File.open("provisioning/cloud-init/#{host}.yaml", 'w')
    f << ERB.new(File.read('provisioning/templates/cloud-init-pi.yaml.erb'), nil, '-').result(binding)
    f.close
  end
  ZEROS.each do |host, data|
    mac = data['mac']

    f = File.open("provisioning/cloud-init/#{host}.yaml", 'w')
    f << ERB.new(File.read('provisioning/templates/cloud-init-zero.yaml.erb'), nil, '-').result(binding)
    f.close

    c = File.open("provisioning/bootconf/#{host}.txt", 'w')
    c << ERB.new(File.read('provisioning/templates/cmdline.txt.erb'), nil, '-').result(binding)
    c.close
  end
end

task :flash_pi, [:dev, :hostname] do |t,args|
  image = Dir.glob('images/hypriot*.{img,zip}').sort.first
  cmd  = './provisioning/flash'
  cmd += " --device #{args[:dev]}"
  cmd += " --hostname #{args[:hostname]}.pi.jeef.me"
  # cmd += " --ssid pi-net"
  # cmd += " --password somethingeasy"
  cmd += " --bootconf provisioning/bootconf/pi-config.txt"
  cmd += " --userdata provisioning/cloud-init/#{args[:hostname]}.pi.jeef.me.yaml"
  cmd += " " + image

  sh cmd
end
task :flash_zero, [:dev, :hostname] do |t,args|
  # https://gist.github.com/gbaman/975e2db164b3ca2b51ae11e45e8fd40a
  image = Dir.glob('images/hypriot*.{img,zip}').sort.first
  cmd  = './provisioning/flash'
  cmd += " --device #{args[:dev]}"
  cmd += " --hostname #{args[:hostname]}.pi.jeef.me"
  cmd += " --bootconf provisioning/bootconf/zero-config.txt"
  cmd += " --cmdline provisioning/bootconf/#{args[:hostname]}.pi.jeef.me.txt"
  cmd += " --userdata provisioning/cloud-init/#{args[:hostname]}.pi.jeef.me.yaml"
  cmd += " " + image

  sh cmd
end
