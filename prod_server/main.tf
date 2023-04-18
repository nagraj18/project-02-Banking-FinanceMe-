resource "aws_instance" "prod_server" {
  ami           = "ami-06fc49795bc410a0c" 
  instance_type = "t2.micro"
  key_name = "awsmobakey"
  vpc_security_group_ids= ["sg-08290b52fa64c3be6"]
  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("./awsmobakey.pem")
    host     = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [ "echo 'wait to start instance' "]
  }
  tags = {
    Name = "prod_server"
  }
 provisioner "local-exec" {

        command = " echo ${aws_instance.prod-server.public_ip} > inventory "
 }
 
 provisioner "local-exec" {
 command = "ansible-playbook /var/lib/jenkins/workspace/Banking and Finance Domain/prod_server/prod_bank_playbook.yml "
  } 
}

output "prod-server_public_ip" {

  value = aws_instance.prod-server.public_ip
  
}