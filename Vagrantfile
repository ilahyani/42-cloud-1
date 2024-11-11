Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-22.04"

  config.vm.provision "shell", path: "init.sh", env: {
    "AWS_ACCESS_KEY_ID" => ENV['AWS_ACCESS_KEY_ID'],
    "AWS_SECRET_ACCESS_KEY" => ENV['AWS_SECRET_ACCESS_KEY'],
    "AWS_REGION" => ENV['AWS_REGION']
  }

  config.vm.synced_folder ".", "/cloud"
end
