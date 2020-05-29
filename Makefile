TAGS = 0 0.1 0.1.0
IMAGE = aspenlang/aspen

.PHONY: all
all: debian alpine
	docker tag $(IMAGE):debian $(IMAGE):latest
	$(foreach TAG,$(TAGS),docker tag $(IMAGE):debian $(IMAGE):$(TAG);)

.PHONY: push
push: all
	docker push $(IMAGE):latest
	docker push $(IMAGE):debian
	docker push $(IMAGE):alpine
	$(foreach TAG,$(TAGS),docker push $(IMAGE):$(TAG);)
	$(foreach TAG,$(TAGS),docker push $(IMAGE):$(TAG)-debian;)
	$(foreach TAG,$(TAGS),docker push $(IMAGE):$(TAG)-alpine;)

.PHONY: debian
debian:
	docker build \
		--tag $(IMAGE):debian \
		--file debian/Dockerfile \
		aspen
	$(foreach TAG,$(TAGS),docker tag $(IMAGE):debian $(IMAGE):$(TAG)-debian;)

.PHONY: alpine
alpine:
	docker build \
		--tag $(IMAGE):alpine \
		--file alpine/Dockerfile \
		aspen
	$(foreach TAG,$(TAGS),docker tag $(IMAGE):alpine $(IMAGE):$(TAG)-alpine;)
