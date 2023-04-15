terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web-server" {
  ami           = "ami-024614f01f42eeb66"
  instance_type = "t2.micro"
  key_name = "/media/paulo/DATA/chaves_ssh/terraform"
  vpc_security_group_ids = [ "sg-08a0b00e075713d03" ]

  user_data = <<-EOF
    <powershell>
      # Configuring WinRM
      winrm quickconfig -q
      winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="300"}'
      winrm set winrm/config '@{MaxTimeoutms="1800000"}'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
      winrm set winrm/config/service '@{AllowUnencrypted="true"}'
      winrm set winrm/config/service/auth '@{Basic="true"}'

      # Opening WinRM port in Windows Firewall
      netsh advfirewall firewall add rule name="WinRM-HTTP" dir=in localport=5985 protocol=TCP action=allow
      netsh advfirewall firewall add rule name="WinRM-HTTPS" dir=in localport=5986 protocol=TCP action=allow
    </powershell>
  EOF
 
  tags = {
    Name = "Web-Server"
}

}

output "public_ip" {
  value = aws_instance.web-server.public_ip
}