resource "digitalocean_droplet""devops_test" {
  count              = 2
  image              = var.image_id
  name               = "digitalocean"
  region             = "nyc3"
  size               = "1gb"
  ssh_keys           = [28221442]
  tags               = [digitalocean_tag.devops_test.id]

  lifecycle {
    create_before_destroy = true
  }

  provisioner "local-exec" {
    command = "sleep 160 && curl ${self.ipv4_address}:3000"
  }

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

resource "digitalocean_tag" "devops_test" {
  name = "node_service"
}

resource "digitalocean_loadbalancer" "devops_test" {
  name   = "nodeservice"
  region = "nyc3"

  forwarding_rule {
    entry_port     = 80
    entry_protocol = "http"

    target_port     = 3000
    target_protocol = "http"
  }

  healthcheck {
    port     = 3000
    protocol = "http"
    path     = "/"
  }

  droplet_tag = digitalocean_tag.devops_test.name
}