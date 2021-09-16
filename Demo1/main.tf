terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  credentials = file("my_gcp.json")
  project = var.project
  region = var.region
  zone = "${var.region}-c"
}

resource "google_compute_instance" "vm_db_mongo" {
  name = "db-mongo"
  machine_type = "e2-small"

  boot_disk {
    initialize_params {
      image = "debian-10-buster-v20210721"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }

  provisioner "file" {
    source = "db_mongo.sh"
    destination = "/tmp/startup.sh"
    connection {
       host        = self.network_interface.0.access_config.0.nat_ip
       type        = "ssh"
       user        = var.user
       timeout     = "600s"
       private_key = file(var.privatekeypath)
     }
    }

    provisioner "remote-exec" {
      connection {
        host = self.network_interface.0.access_config.0.nat_ip
        type = "ssh"
        user = var.user
        timeout = "600s"
        private_key = file(var.privatekeypath)
      }
      inline = [
       "chmod a+x /tmp/startup.sh",
       "sudo /tmp/startup.sh"
      ]
    }

  metadata = {
    ssh-keys = "${var.user}:${file(var.publickeypath)}"
  }
}

resource "google_compute_instance" "vm_lb_nginx" {
  name = "lb-nginx"
  machine_type = "e2-small"
  tags = ["web","api"]

  boot_disk {
    initialize_params {
      image = "debian-10-buster-v20210721"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }

  provisioner "file" {
    source = "lb_nginx.sh"
    destination = "/tmp/startup.sh"
    connection {
      host        = self.network_interface.0.access_config.0.nat_ip
      type        = "ssh"
      user        = var.user
      timeout     = "600s"
      private_key = file(var.privatekeypath)
    }
  }

  provisioner "remote-exec" {
    connection {
      host = self.network_interface.0.access_config.0.nat_ip
      type = "ssh"
      user = var.user
      timeout = "600s"
      private_key = file(var.privatekeypath)
    }
    inline = [
      "chmod a+x /tmp/startup.sh",
      "sudo /tmp/startup.sh"
    ]
  }

  metadata = {
    ssh-keys = "${var.user}:${file(var.publickeypath)}"
  }
}

resource "google_compute_instance" "vm_be_js0" {
  name = "be-js-0"
  machine_type = "e2-highcpu-2"
  depends_on = [google_compute_instance.vm_db_mongo,google_compute_instance.vm_lb_nginx]

  boot_disk {
    initialize_params {
      image = "debian-10-buster-v20210721"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }

  provisioner "file" {
    source = ".htaccess"
    destination = "/tmp/.htaccess"
    connection {
      host        = self.network_interface.0.access_config.0.nat_ip
      type        = "ssh"
      user        = var.user
      timeout     = "600s"
      private_key = file(var.privatekeypath)
    }
  }

  provisioner "file" {
    source = "ch_env_ui.sh"
    destination = "/tmp/ch_env_ui.sh"
    connection {
      host        = self.network_interface.0.access_config.0.nat_ip
      type        = "ssh"
      user        = var.user
      timeout     = "600s"
      private_key = file(var.privatekeypath)
    }
  }

  provisioner "remote-exec" {
    connection {
      host = self.network_interface.0.access_config.0.nat_ip
      type = "ssh"
      user = var.user
      timeout = "600s"
      private_key = file(var.privatekeypath)
    }
    inline = [
      "chmod a+x /tmp/ch_env_ui.sh",
      "sudo mkdir /srv/scripts",
      "sudo mv /tmp/ch_env_ui.sh /srv/scripts/"
    ]
  }

  provisioner "file" {
    source = "tmp/be_api_env.sh"
    destination = "/tmp/env.sh"
    connection {
      host        = self.network_interface.0.access_config.0.nat_ip
      type        = "ssh"
      user        = var.user
      timeout     = "600s"
      private_key = file(var.privatekeypath)
    }
  }

  provisioner "remote-exec" {
    connection {
      host = self.network_interface.0.access_config.0.nat_ip
      type = "ssh"
      user = var.user
      timeout = "600s"
      private_key = file(var.privatekeypath)
    }
    inline = [
      "chmod a+x /tmp/env.sh",
      "sudo /tmp/env.sh"
    ]
  }

    provisioner "file" {
    source = "tmp/be_api.sh"
    destination = "/tmp/startup.sh"
    connection {
      host        = self.network_interface.0.access_config.0.nat_ip
      type        = "ssh"
      user        = var.user
      timeout     = "600s"
      private_key = file(var.privatekeypath)
    }
  }

  provisioner "remote-exec" {
    connection {
      host = self.network_interface.0.access_config.0.nat_ip
      type = "ssh"
      user = var.user
      timeout = "600s"
      private_key = file(var.privatekeypath)
    }
    inline = [
      "chmod a+x /tmp/startup.sh",
      "sudo -E /tmp/startup.sh"
    ]
  }

  metadata = {
    ssh-keys = "${var.user}:${file(var.publickeypath)}"
  }
}

resource "google_compute_instance" "vm_be_js1" {
  name = "be-js-1"
  machine_type = "e2-highcpu-2"
  depends_on = [google_compute_instance.vm_db_mongo,google_compute_instance.vm_lb_nginx]

  boot_disk {
    initialize_params {
      image = "debian-10-buster-v20210721"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }

  provisioner "file" {
    source = ".htaccess"
    destination = "/tmp/.htaccess"
    connection {
      host        = self.network_interface.0.access_config.0.nat_ip
      type        = "ssh"
      user        = var.user
      timeout     = "600s"
      private_key = file(var.privatekeypath)
    }
  }

  provisioner "file" {
    source = "ch_env_ui.sh"
    destination = "/tmp/ch_env_ui.sh"
    connection {
      host        = self.network_interface.0.access_config.0.nat_ip
      type        = "ssh"
      user        = var.user
      timeout     = "600s"
      private_key = file(var.privatekeypath)
    }
  }

  provisioner "remote-exec" {
    connection {
      host = self.network_interface.0.access_config.0.nat_ip
      type = "ssh"
      user = var.user
      timeout = "600s"
      private_key = file(var.privatekeypath)
    }
    inline = [
      "chmod a+x /tmp/ch_env_ui.sh",
      "sudo mkdir /srv/scripts",
      "sudo mv /tmp/ch_env_ui.sh /srv/scripts/"
    ]
  }

  provisioner "file" {
    source = "tmp/be_api_env.sh"
    destination = "/tmp/env.sh"
    connection {
      host        = self.network_interface.0.access_config.0.nat_ip
      type        = "ssh"
      user        = var.user
      timeout     = "600s"
      private_key = file(var.privatekeypath)
    }
  }

  provisioner "remote-exec" {
    connection {
      host = self.network_interface.0.access_config.0.nat_ip
      type = "ssh"
      user = var.user
      timeout = "600s"
      private_key = file(var.privatekeypath)
    }
    inline = [
      "chmod a+x /tmp/env.sh",
      "sudo /tmp/env.sh"
    ]
  }

  provisioner "file" {
    source = "tmp/be_api.sh"
    destination = "/tmp/startup.sh"
    connection {
      host        = self.network_interface.0.access_config.0.nat_ip
      type        = "ssh"
      user        = var.user
      timeout     = "600s"
      private_key = file(var.privatekeypath)
    }
  }

  provisioner "remote-exec" {
    connection {
      host = self.network_interface.0.access_config.0.nat_ip
      type = "ssh"
      user = var.user
      timeout = "600s"
      private_key = file(var.privatekeypath)
    }
    inline = [
      "chmod a+x /tmp/startup.sh",
      "sudo -E /tmp/startup.sh"
    ]
  }

  metadata = {
    ssh-keys = "${var.user}:${file(var.publickeypath)}"
  }
}

resource "google_compute_firewall" "rules-web" {
  project     = var.project
  name        = "allow-web"
  network     = "default"
  allow {
    protocol  = "tcp"
    ports     = ["80", "443"]
  }
  target_tags = ["web"]
}

resource "google_compute_firewall" "rules-api" {
  project     = var.project
  name        = "allow-api"
  network     = "default"
  allow {
    protocol  = "tcp"
    ports     = ["5000"]
  }
  target_tags = ["api"]
}

resource "random_password" "token" {
  length      = 16
  special     = false
}

resource "local_file" "be_api_env" {
  content = templatefile("be_api_env.sh.tpl", {
    API_PORT = var.api_port,
    JWT = random_password.token.result,
    MONGODB_IP = google_compute_instance.vm_db_mongo.network_interface.0.network_ip
  })
  filename = "tmp/be_api_env.sh"
}

resource "local_file" "be_api_startup" {
  content = templatefile("be_api.sh.tpl", {
    NODE_ENV = var.node_env,
    REPO_API = var.repo_api,
    REPO_UI = var.repo_ui,
    INI_EMAIL = var.initial_email,
    INI_PASSWD = var.initial_password,
    INI_USER = var.initial_username,
    API_PORT = var.api_port,
    JWT = random_password.token.result,
    MONGODB_IP = google_compute_instance.vm_db_mongo.network_interface.0.network_ip,
    NGINX_IP = google_compute_instance.vm_lb_nginx.network_interface.0.access_config.0.nat_ip
  })
  filename = "tmp/be_api.sh"
}

resource "local_file" "lb_nginx_conf" {
  content = templatefile("nginx.conf.tpl", {
    PORT = var.api_port,
    NODE0 = google_compute_instance.vm_be_js0.network_interface.0.network_ip,
    NODE1 = google_compute_instance.vm_be_js1.network_interface.0.network_ip
  })
  filename = "tmp/nginx.conf"
  depends_on = [google_compute_instance.vm_lb_nginx,google_compute_instance.vm_be_js0,google_compute_instance.vm_be_js1]

  provisioner "file" {
    source = "tmp/nginx.conf"
    destination = "/tmp/nginx.conf"
    connection {
      host        = google_compute_instance.vm_lb_nginx.network_interface.0.access_config.0.nat_ip
      type        = "ssh"
      user        = var.user
      timeout     = "600s"
      private_key = file(var.privatekeypath)
    }
  }

  provisioner "remote-exec" {
    connection {
      host = google_compute_instance.vm_lb_nginx.network_interface.0.access_config.0.nat_ip
      type = "ssh"
      user = var.user
      timeout = "600s"
      private_key = file(var.privatekeypath)
    }
    inline = [
      "sudo chown root:root /tmp/nginx.conf",
      "sudo mv /tmp/nginx.conf /etc/nginx/",
      "sudo rm /etc/nginx/sites-enabled/default",
      "sudo systemctl start nginx"
    ]
  }
}
