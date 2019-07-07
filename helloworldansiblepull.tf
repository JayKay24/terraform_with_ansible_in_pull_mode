# Provider configuration for AWS
provider "aws" {
  region = "us-east-1"
  shared_credentials_file = "~/.aws/personal_creds"
}

# Resource Configuration for AWS
resource "aws_instance" "myserver" {
  ami = "ami-cfe4b2b0"
  instance_type = "t2.micro"
  key_name = "EffectiveDevOpsAWS"
  vpc_security_group_ids = ["sg-0d5c720086395e76d"]

  tags = {
    Name = "helloworld"
  }

  # Provisioner for applying Ansible playbook in pull mode
  provisioner "remote-exec" {
    connection {
      user = "ec2-user"
      private_key = "${file("../../.ssh/EffectiveDevOpsAWS.pem")}"
      host = "${self.public_ip}"
    }
    inline = [
      "sudo yum install --enablerepo=epel -y ansible git",
      "sudo ansible-pull -U https://github.com/JayKay24/ansible helloworldyml -i localhost.",
    ]
  }
}

# IP address of newly created ec2 instance
output "myserver" {
  value = "${aws_instance.myserver.public_ip}"
}