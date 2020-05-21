terraform {
  backend "local" {
    path = "/tmp/terraform/workspace/terraform.tfstate"
  }

}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "backend" {
  ami                    = "ami-0fd7e4b8e94538bef"
  instance_type          = "t2.micro"
  key_name               = "${var.key_name}"
  vpc_security_group_ids = ["${var.sg-id}"]

}

resource "null_resource" "remote-exec-1" {
    connection {
    user        = "ubuntu"
    type        = "ssh"
    private_key = "${file(var.pvt_key)}"
    host        = "${aws_instance.backend.public_ip}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update; sleep 10",
      "sudo apt-get install python sshpass -y",
    ]
  }
}

resource "null_resource" "ansible-main" {
provisioner "local-exec" {
  command = <<EOT
        sleep 100;
        > jenkins-ci.ini;
        echo "[jenkins-ci]"| tee -a jenkins-ci.ini;
        export ANSIBLE_HOST_KEY_CHECKING=False;
        echo "${aws_instance.backend.public_ip}" | tee -a jenkins-ci.ini;
        ansible-playbook  --key=${var.pvt_key} -i jenkins-ci.ini ./ansible-code/05-Tomcat/playbook.yaml -u ubuntu -v
    EOT
}
}

