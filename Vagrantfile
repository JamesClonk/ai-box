#vm_name = File.basename(Dir.getwd)
vm_name = "ai-box"

# source host env vars for AWS identity provider
File.readlines(File.expand_path("~/.aws_identity_provider")).each do |line|
  key, value = line.strip.match(/^export\s+(\w+)=["']?(.+?)["']?$/)&.captures
  ENV[key] = value if key
end

Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-24.04"

  #config.vm.synced_folder ".", "/home/vagrant/projects", type: "virtualbox"
  config.vm.synced_folder File.expand_path("~/04_virt/projects"), "/home/vagrant/projects", type: "virtualbox"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "8192"
    vb.cpus = 4
    vb.gui = false
    vb.name = vm_name
    vb.customize ["modifyvm", :id, "--audio", "none"]
    vb.customize ["modifyvm", :id, "--usb", "off"]
  end

  ## use this in case any specific localhost:port access from VM->Host is needed
  # config.ssh.extra_args = [
  #   "-R", "9999:localhost:9999",
  #   "-R", "9090:localhost:9090",
  #   "-R", "9000:localhost:9000",
  #   "-R", "8080:localhost:8080",
  #   "-R", "3000:localhost:3000",
  #   "-R", "5432:localhost:5432"
  # ]

  ## or this for the other way around (Host->VM)
  #config.vm.network "forwarded_port", guest: 9999, host: 9999, auto_correct: true
  #config.vm.network "forwarded_port", guest: 8080, host: 8080, auto_correct: true
  #config.vm.network "forwarded_port", guest: 3000, host: 3000, auto_correct: true

  # root
  config.vm.provision "shell", inline: <<-SHELL
    export DEBIAN_FRONTEND=noninteractive

    # basics
    apt-get update
    apt-get install -y docker.io git unzip bzip2 neovim tmux ruby-dev python3-dev \
      curl wget jq ca-certificates apt-transport-https parallel util-linux \
      iputils-arping iputils-clockdiff iputils-ping iputils-tracepath iproute2 \
      cmake openssl dnsutils uuid-runtime netcat-openbsd gettext-base lsb-release psmisc \
      iptables ethtool wireguard net-tools traceroute apache2-utils openssh-client \
      libreadline-dev libtool libssl-dev libffi-dev libyaml-dev libz-dev chrony \
      bsdextrautils

    # kubectl
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.34/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.34/deb/ /' > /etc/apt/sources.list.d/kubernetes.list
    apt-get update
    apt-get install -y kubectl

    usermod -aG docker vagrant
    chown -R vagrant:vagrant /home/vagrant/projects
  SHELL

  # vagrant
  config.vm.provision "shell", privileged: false,
    env: {
      "AWS_IDENTITY_PROVIDER_URL" => ENV.fetch("AWS_IDENTITY_PROVIDER_URL"),
      "AWS_REGION" => ENV.fetch("AWS_REGION")
    },
    inline: <<-SHELL
    export PATH="$HOME/.local/bin:$PATH"
    grep 'PATH="$HOME/.local/bin:$PATH"' ~/.bashrc 1>/dev/null || echo 'PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc

    # taskfile
    curl -1sLf 'https://dl.cloudsmith.io/public/task/task/setup.deb.sh' | sudo -E bash

    # mise-en-place
    curl https://mise.run | sh
    mise --version
    eval "$(mise activate bash)"
    grep 'eval "$(mise activate bash)"' ~/.bashrc 1>/dev/null || echo 'eval "$(mise activate bash)"' >> ~/.bashrc

    # mise languages
    mise install golang@1.22.12
    mise install golang@1.24.12
    mise use --global golang@1.25.6
    mise use --global ruby@3.2.10
    mise use --global python@3.13.11
    mise use --global node@22

    # install venv & ansible
    pip install --user virtualenv
    pip install --user ansible

    # install bundler
    gem install bundler

    # install useful ruby gems
    gem install httparty
    gem install rest-client
    gem install deep_merge
    gem install hashdiff
    gem install fugit
    gem install chronic
    gem install json
    gem install rexml

    # claude
    npm install -g @anthropic-ai/claude-code --no-audit
    claude --version

    # kiro
    curl -fsSL https://cli.kiro.dev/install | bash || true
    kiro-cli --version
    grep 'kiro()' ~/.bashrc 1>/dev/null || cat >> ~/.bashrc << EOF
kiro() {
  if ! kiro-cli whoami &>/dev/null; then
    kiro-cli login --identity-provider ${AWS_IDENTITY_PROVIDER_URL} --region ${AWS_REGION} --use-device-flow
  fi
  kiro-cli "\\$@"
}
EOF
  SHELL

end
