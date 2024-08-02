all: build

build:
	@docker build --tag=motionbank/squid .
