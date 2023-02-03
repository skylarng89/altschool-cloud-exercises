# Create ALB target group
resource "aws_lb_target_group" "altschool-ex13-lb-tg" {
  name        = "altschool-ex13-lb-tg"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.altschool-ex13-vpc.id
  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

# Create Load balancer
resource "aws_lb" "altschool-ex13-lb" {
  name                       = "altschool-ex13-lb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.altschool-ex13-loadbalancersg.id]
  subnets                    = [aws_subnet.altschool-ex13-subneta.id, aws_subnet.altschool-ex13-subnetb.id, aws_subnet.altschool-ex13-subnetc.id]
  enable_deletion_protection = false
  depends_on                 = [aws_instance.altschool-ex13-server1, aws_instance.altschool-ex13-server2, aws_instance.altschool-ex13-server3]
}

# Create target listener
resource "aws_lb_listener" "altschool-ex13-listener" {
  load_balancer_arn = aws_lb.altschool-ex13-lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.altschool-ex13-lb-tg.arn
  }
}

# Create target listener rule
resource "aws_lb_listener_rule" "altschool-ex13-listener-rule" {
  listener_arn = aws_lb_listener.altschool-ex13-listener.arn
  priority     = 1
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.altschool-ex13-lb-tg.arn
  }
  condition {
    path_pattern {
      values = ["/"]
    }
  }
}

# Attach LB target group
resource "aws_lb_target_group_attachment" "altschool-ex13-att1" {
  target_group_arn = aws_lb_target_group.altschool-ex13-lb-tg.arn
  target_id        = aws_instance.altschool-ex13-server1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "Altschool-target-group-attachment2" {
  target_group_arn = aws_lb_target_group.altschool-ex13-lb-tg.arn
  target_id        = aws_instance.altschool-ex13-server2.id
  port             = 80
}
resource "aws_lb_target_group_attachment" "Altschool-target-group-attachment3" {
  target_group_arn = aws_lb_target_group.altschool-ex13-lb-tg.arn
  target_id        = aws_instance.altschool-ex13-server3.id
  port             = 80

}
