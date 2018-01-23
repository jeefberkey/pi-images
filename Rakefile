require 'erb'
require 'pry'

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

PIS = [
  'raspi1',
  'raspi2',
  'raspi3',
]
ZEROS = {
  zero1: [ 'b8:27:eb:35:fb:a1','192.168.2.70' ],
  zero2: [ 'b8:27:eb:35:fb:a2','192.168.2.71' ],
  zero3: [ 'b8:27:eb:35:fb:a3','192.168.2.72' ],
  zero4: [ 'b8:27:eb:35:fb:a4','192.168.2.73' ],
  zero5: [ 'b8:27:eb:35:fb:a5','192.168.2.74' ],
}
DOMAIN = 'pi.jeef.me'

task :gen_cloud_init, [:hostname] do |t,args|
  PIS.each do |host|
    template = 'cloud-init-pi.yaml.erb'
    fqdn     = "#{host}.#{DOMAIN}"
    wifi     = true

    f = File.open("cloud-init/#{fqdn}.yaml", 'w')
    f << ERB.new(File.read(template), nil, '-').result(binding)
    f.close
  end
  ZEROS.each do |host, data|
    template = 'cloud-init-zero.yaml.erb'
    fqdn     = "#{host}.#{DOMAIN}"
    wifi     = false

    f = File.open("cloud-init/#{fqdn}.yaml", 'w')
    f << ERB.new(File.read(template), nil, '-').result(binding)
    f.close
  end

end

task :flash_pi, [:dev, :hostname] do |t,args|
  # flash --userdata sample/wlan-user-data.yaml
  #   --bootconf sample/no-uart-config.txt hypriotos-rpi-v1.7.1.img
  image = Dir.glob('images/*.{img,zip}').sort.first
  cmd  = './flash'
  cmd += " --device #{args[:dev]}"
  cmd += " --hostname #{args[:hostname]}.pi.jeef.me"
  cmd += " --ssid pi-net"
  cmd += " --password somethingeasy"
  cmd += " --bootconf bootconf/pi-config.txt"
  cmd += " --userdata cloud-init/#{args[:hostname]}.pi.jeef.me.yaml"
  cmd += " " + image

  sh cmd
end

task :flash_zero, [:dev, :hostname] do |t,args|
  # flash --userdata sample/wlan-user-data.yaml
  #   --bootconf sample/no-uart-config.txt hypriotos-rpi-v1.7.1.img
  image = Dir.glob('images/*.{img,zip}').sort.first
  cmd  = './flash'
  cmd += " --device #{args[:dev]}"
  cmd += " --hostname #{args[:hostname]}.pi.jeef.me"
  cmd += " --bootconf bootconf/zero-config.txt"
  cmd += " --cmdline bootconf/zero-cmdline.txt"
  cmd += " --userdata cloud-init/#{args[:hostname]}.pi.jeef.me.yaml"
  cmd += " " + image

  sh cmd
end
