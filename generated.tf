# __generated__ by Terraform
resource "aws_instance" "Unix-vm-imported" {
  ami                                  = "ami-0b6d9d3d33ba97d99"
  associate_public_ip_address          = true
  availability_zone                    = "us-east-1a"
  disable_api_stop                     = false
  disable_api_termination              = false
  ebs_optimized                        = true
  enable_primary_ipv6                  = null
  force_destroy                        = false
  get_password_data                    = false
  hibernation                          = false
  host_id                              = null
  host_resource_group_arn              = null
  iam_instance_profile                 = null
  instance_initiated_shutdown_behavior = "stop"
  instance_type                        = "t3.micro"
  ipv6_addresses                       = []
  key_name                             = "test-vm-key"
  monitoring                           = false
  placement_group                      = null
  placement_group_id                   = null
  placement_partition_number           = 0
  private_ip                           = "172.31.0.222"
  region                               = "us-east-1"
  secondary_private_ips                = []
  security_groups                      = ["launch-wizard-7"]
  source_dest_check                    = true
  subnet_id                            = "subnet-0f7e83b30f2bab03d"
  tags = {
    Name = "linux-cmd-test-vm"
  }
  tags_all = {
    Name = "linux-cmd-test-vm"
  }
  tenancy                     = "default"
  user_data                   = null
  user_data_base64            = null
  user_data_replace_on_change = null
  volume_tags                 = null
  vpc_security_group_ids      = ["sg-0b1ee43c9ab4f9cd8"]
  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }
  cpu_options {
    amd_sev_snp           = null
    core_count            = 1
    nested_virtualization = null
    threads_per_core      = 2
  }
  credit_specification {
    cpu_credits = "unlimited"
  }
  ebs_block_device {
    delete_on_termination = false
    device_name           = "/dev/sdf"
    encrypted             = true
    iops                  = 3000
    kms_key_id            = "arn:aws:kms:us-east-1:144273780530:key/10468cfb-2313-4c5a-ab5e-323911068c2d"
    snapshot_id           = null
    tags = {
      Name = "Test-vol"
    }
    tags_all = {
      Name = "Test-vol"
    }
    throughput  = 125
    volume_size = 5
    volume_type = "gp3"
  }
  enclave_options {
    enabled = false
  }
  maintenance_options {
    auto_recovery = "default"
  }
  metadata_options {
    http_endpoint               = "enabled"
    http_protocol_ipv6          = "disabled"
    http_put_response_hop_limit = 2
    http_tokens                 = "required"
    instance_metadata_tags      = "disabled"
  }

  private_dns_name_options {
    enable_resource_name_dns_a_record    = true
    enable_resource_name_dns_aaaa_record = false
    hostname_type                        = "ip-name"
  }
  root_block_device {
    delete_on_termination = true
    encrypted             = false
    iops                  = 3000
    kms_key_id            = null
    tags                  = {}
    tags_all              = {}
    throughput            = 125
    volume_size           = 8
    volume_type           = "gp3"
  }
}
