provider "aws" {
 region = "ap-south-1"
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.test-server.id
  allocation_id = "eipalloc-0604226a57fe8b921"
}
resource "aws_instance" "test-server" {
  ami           = "ami-07d3a50bd29811cd1" 
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
    Name = "test-server"
  }
 provisioner "local-exec" {

        command = " echo ${aws_instance.test-server.public_ip} > inventory "
 }
 
 provisioner "local-exec" {
 command = "ansible-playbook /var/lib/jenkins/workspace/Banking and Finance Domain/test_server/test_bank_playbook.yml "
  } 
}

output "test-server_public_ip" {

  value = aws_eip_association.eip_assoc.public_ip
  
}
