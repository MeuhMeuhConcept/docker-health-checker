VERSION=1.0

build:
	docker build -t jngermon/health-checker:$(VERSION) .
