terraform{
    required_version = ">=0.12.0"
    backend "s3" {
        region = "us-east-1"
        profile = "default"
        key = "terraformstatefile"
        bucket = "terragitlab"  # This is the name of the bucket you created
    }
}