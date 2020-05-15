
#Comment out either mixedinstance.tf or asg.tg

data "template_file" "init" { 
template = "${file("${path.module}/wordpress.sh")}" 
} 
resource "aws_launch_configuration" "as_conf" { 
  name = "web_config" 
  image_id = "${data.aws_ami.image.id}" 
  instance_type = "t2.micro" 
  user_data = "${base64encode(data.template_file.init.rendered)}" 
  # spot_price = "0.1" 
} 
resource "aws_autoscaling_group" "bar" { 
name = "terraform-asg-example" 
launch_configuration = "${aws_launch_configuration.as_conf.name}" 
availability_zones = [ 
"us-east-1a", 
"us-east-1b", 
"us-east-1c", 
] 
  min_size = 1 
  max_size = 2 
  lifecycle { 
  create_before_destroy = true 
  } 
} 

