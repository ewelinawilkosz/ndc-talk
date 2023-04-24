ORG	   := ewelinawilkosz
NAME   := ${ORG}/ngingo
TAG    := $$(git log -1 --pretty=%h)
IMG    := ${NAME}:${TAG}
LATEST := ${NAME}:latest



build:
	@echo ${IMG}
	@docker build -f Dockerfile -t ${IMG} .
	@docker tag ${IMG} ${LATEST}
	@docker tag ${IMG} ghcr.io/${IMG}

push:
	@echo ghcr.io/${IMG}
	@docker push ghcr.io/${IMG}
	@cd scripts && ./report_build.sh ${TAG} ghcr.io/${IMG}

run:
	@docker run -d --rm -it -p 80:80 --name ngingo ${NAME}

stop:
	@docker stop ngingo

runk:
	@kubectl run hello-ngingo --image=${IMG} --port=80
	kubectl wait --for=condition=Ready pod/hello-ngingo
	@kubectl port-forward pods/hello-ngingo 8080:80

stopk:
	@kubectl delete pod hello-ngingo