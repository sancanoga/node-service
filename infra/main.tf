resource "digitalocean_droplet""web" {
  image              = "69142175"
  name               = "digitalocean"
  region             = "nyc3"
  size               = "1gb"
  ssh_keys           = [28221442]
  user_data          = <<EOF
#cloud-config
coreos:
    units:
      - name: "devopsdemo.service"
        command: "start"
        content: |
          [Unit]
          Description=devops demo
          After=docker.service

          [Service]
          ExecStart=/usr/bin/docker run -d -p 3000:3000 nodeservice
EOF
}

