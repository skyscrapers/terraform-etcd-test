# terraform-etcd-test
This repo has terraform code to test an etcd cluster
By default it sets up a 3 node etcd cluster.

This project sets up the bare minimum.

To run terraform, you need to supply it with a discovery token: https://github.com/skyscrapers/terraform-etcd-test/blob/master/vars.tf#L50-L53
Don't forget to change the ssh key, or you won't have access.


Feel free to improve this project.
