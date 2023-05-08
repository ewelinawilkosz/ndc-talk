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

deploy:
	@kubectl get deployment hello-ngingo || kubectl create deployment hello-ngingo --image=ghcr.io/${IMG} --port=80
	@kubectl set image deployment/hello-ngingo ngingo=ghcr.io/${IMG}
#	kubectl wait --for=condition=Ready pod/hello-ngingo
#	@kubectl port-forward pods/hello-ngingo 8080:80

stopk:
	@kubectl delete pod hello-ngingo