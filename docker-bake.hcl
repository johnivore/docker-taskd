group "default" {
	targets = ["alpine-3"]
}

target "alpine-3" {
	dockerfile = "Dockerfile"
	platforms = ["linux/amd64", "linux/arm64", "linux/arm/v7"]
    tags = ["johnivore/taskd:latest"]
}
