resource "aws_security_group_rule" "all_worker_mgmt_egress_https" {
  
  type              = "egress"
  security_group_id = aws_security_group.all_worker_mgmt.id

  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  cidr_blocks = ["0.0.0.0/0"]
}


resource "aws_security_group_rule" "all_worker_mgmt_egress_dns" {
  description       = "Allow DNS outbound traffic"
  type              = "egress"
  security_group_id = aws_security_group.all_worker_mgmt.id

  from_port = 53
  to_port   = 53
  protocol  = "udp"

  cidr_blocks = ["0.0.0.0/0"]
}
