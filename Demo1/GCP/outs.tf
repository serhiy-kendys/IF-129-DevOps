output "nginx_ext_ip" {
  value = google_compute_instance.vm_lb_nginx.network_interface.0.access_config.0.nat_ip
}