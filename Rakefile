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

namespace :provisioning do
  desc 'Generate the cloud-init yaml files for hypriot'
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

  desc 'Use my modified hypriot flash script to flash rpis'
  task :flash_pi, [:dev, :hostname] do |t,args|
    image = Dir.glob('images/hypriot*.{img,zip}').sort[1]

    cmd  = './provisioning/flash'
    cmd += " --device #{args[:dev]}"
    cmd += " --hostname #{args[:hostname]}.pi.jeef.me"
    cmd += " --bootconf provisioning/bootconf/pi-config.txt"
    cmd += " --userdata provisioning/cloud-init/#{args[:hostname]}.pi.jeef.me.yaml"
    cmd += " " + image

    sh cmd
  end

  desc 'flash intended for zeroes; unused'
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
end

namespace :docker do
  desc 'build ruby:2.5.1-alpine on arm'
  task :ruby do
    dockerfile_url = 'https://raw.githubusercontent.com/docker-library/ruby/c9644fe5c95cd71913db348baa41240f05d882b3/2.5/alpine3.7/Dockerfile'
    tag = 'us.gcr.io/jeefme-185614/ruby:2.5.1-alpine'
    sh 'docker build -t ruby-2.5.1-alpine-arm ' + dockerfile_url
    sh 'docker tag ruby-2.5.1-alpine-arm ' + tag
  end

  desc 'build the octobox on arm'
  task :octobox do
    dockerfile_url = 'https://github.com/octobox/octobox.git'
    tag = 'us.gcr.io/jeefme-185614/octobox:latest'
    sh 'docker build -t octobox-arm ' + dockerfile_url
    sh 'docker tag octobox ' + tag
  end
end
