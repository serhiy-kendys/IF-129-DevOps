variable "region" {
    type = string
}
variable "project" {
    type = string
}

variable "user" {
    type = string
}

variable "privatekeypath" {
    type = string
    default = "~/.ssh/id_rsa"
}

variable "publickeypath" {
    type = string
    default = "~/.ssh/id_rsa.pub"
}

variable "node_env" {
    type = string
    default = "production"
}

variable "initial_email" {
    type = string
    default = "raketa@tele.ga"
}

variable "initial_password" {
    type = string
    default = "IchBinGroot12"
}

variable "initial_username" {
    type = string
    default = "iamgroot"
}

variable "api_port" {
    type = string
    default = "5000"
}

variable "repo_api" {
    type = string
    default = "https://s75@bitbucket.org/s75/digichlist-api.git"
}

variable "repo_ui" {
    type = string
    default = "https://s75@bitbucket.org/s75/digichlist-admin-ui.git"
}
