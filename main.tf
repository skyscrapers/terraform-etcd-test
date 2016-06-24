provider "aws" {
  access_key  = "${var.access_key}"
  secret_key  = "${var.secret_key}"
  region = "${var.aws_region}"
}

module "vpc" {
    source = "github.com/skyscrapers/terraform-vpc"
    cidr_block = "${var.vpc_cidr_block}"
    environment = "test"
    aws_region = "eu-west-1"
    subnets_cidr_block = "${var.vpc_subnets_cidr_block}"
    amount_subnets = "3"
}

module "sg_all" {
    source = "github.com/skyscrapers/terraform-skyscrapers/securitygroup"
    environment = "production"
    vpc_id = "${module.vpc.vpc_id}"
}

resource "aws_key_pair" "deployer" {
  key_name = "sam_2"
  public_key = "${var.public_key_sam}"
}


resource "aws_instance" "etcd_master" {
  ami = "${var.coreos_ami}"
  instance_type = "${var.etcd_type}"
  subnet_id = "${element(split(",", module.vpc.subnets), count.index)}"
  key_name  = "${aws_key_pair.deployer.key_name}"
  vpc_security_group_ids  = ["${module.sg_all.sg_id}","${aws_security_group.sg_etcd.id}"]
  user_data = "${element(template_file.etcd_master.*.rendered, count.index)}"
  associate_public_ip_address = true
  count = "${var.count}"
  #iam_instance_profile = "${aws_iam_instance_profile.deployweb_profile.name}"
  root_block_device {
    volume_type = "standard"
    volume_size = "10"
    delete_on_termination = "false"
  }
  tags {
    Name = "etcd-test-deploy"
    Environment = "tets"
    Project = "etcd"
  }
}

resource "template_file" "etcd_master" {
    count = "${var.count}"
    template = "${file("templates/cloudinit.tpl")}"
    vars {
        discovery_url = "${var.discovery_url}"
        subnet = "${element(split(",", var.vpc_subnets_cidr_block), count.index)}"
    }
}


resource "aws_security_group" "sg_etcd" {
  name = "sg_etcd"
  description = "Security group that is needed for etcd"
  vpc_id = "${module.vpc.vpc_id}"

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "etcd-test-sg_etcd"
    Environment = "tets"
    Project = "etcd"
  }
}
