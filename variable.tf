variable "my-bucket" {

  description = "The AWS region to deploy resources"

  type = string

  default = "new-barobel-test-bucket"
}


variable "my-block" {

  description = "The AWS region to deploy resources"

  type = string

  default = "10.0.0.0/16"
}


variable "my-newnet" {

  description = "The AWS region to deploy resources"

  type = list(string)

  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "my-oldnet" {

  description = "The AWS region to deploy resources"

  type = list(string)

  default = ["10.0.3.0/24", "10.0.4.0/24"]

}


variable "my-azs" {

  description = "The AWS region to deploy resources"

  type = list(string)

  default = ["us-east-1a", "us-east-1b"]

}
variable "my-iam-role-cluster" {

  description = "The AWS region to deploy resources"

  type = string

  default = "my-new-eks-cluster"

}
variable "my-eks-cluster" {

  description = "The AWS region to deploy resources"

  type = string

  default = "my-eks-cluster"
}
variable "my-iam-group-node" {

  description = "The AWS region to deploy resources"

  type = string

  default = "my-iam-group-node"
}
