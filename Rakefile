require 'erb'
require 'pry'
require 'yaml'

require 'rake/clean'
host_files = Rake::FileList.new('**/*.retry', 'provisioning/**/*.{yaml,txt}') do |fl|
  fl.exclude do |f|
    !`git ls-files #{f}`.empty?
  end
end
CLEAN.include(host_files)

hosts = YAML.load_file('hosts.yaml')['all']['children']
PIS   = hosts['pis']['hosts']
ZEROS = hosts['zeros']['hosts'] || []

task :ansible_ping_pis do
  sh 'ansible -i hosts.yaml pis -m ping'
end

task :gen_cloud_init, [:hostname] do |t,args|
  PIS.each do |host, data|
    f = File.open("provisioning/cloud-init/#{host}.yaml", 'w')
    f << ERB.new(File.read('provisioning/templates/cloud-init.yaml.erb'), nil, '-').result(binding)
    f.close
  end
  ZEROS.each do |host, data|
    f = File.open("provisioning/cloud-init/#{host}.yaml", 'w')
    f << ERB.new(File.read('provisioning/templates/cloud-init.yaml.erb'), nil, '-').result(binding)
    f.close

    c = File.open("provisioning/bootconf/#{host}.txt", 'w')
    c << ERB.new(File.read('provisioning/templates/cmdline.txt.erb'), nil, '-').result_with_hash(data)
    c.close
  end
end

task :flash_pi, [:dev, :hostname] do |t,args|
  image = Dir.glob('images/hypriot*.{img,zip}').sort.first

  cmd  = './provisioning/flash'
  cmd += " --device #{args[:dev]}"
  cmd += " --hostname #{args[:hostname]}.pi.jeef.me"
  cmd += " --bootconf provisioning/bootconf/pi-config.txt"
  cmd += " --userdata provisioning/cloud-init/#{args[:hostname]}.pi.jeef.me.yaml"
  cmd += " " + image

  sh cmd
end

task :flash_zero, [:dev, :hostname] do |t,args|
  # https://github.com/alexellis/docker-arm/blob/master/OTG.md
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
