ORG	   := ewelinawilkosz
NAME   := ${ORG}/ngingo
TAG    := $$(git log -1 --pretty=%h)
FULL   := $$(git rev-parse HEAD)
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
	@cd scripts && ./report_build.sh ${FULL} ghcr.io/${IMG}

run:
	@docker run -d --rm -it -p 80:80 --name ngingo ${NAME}

stop:
	@docker stop ngingo

deploy:
	@kubectl get deployment hello-ngingo || kubectl create deployment hello-ngingo --image=ghcr.io/${IMG} --port=80
	@kubectl set image deployment/hello-ngingo ngingo=ghcr.io/${IMG}
	@kubectl rollout status deployment/hello-ngingo --timeout=20s
	@cd scripts && ./record_env.sh
#	@PODNAME="$$(kubectl get pods -o=jsonpath='{.items[0].metadata.name}')"; kubectl port-forward pods/$$PODNAME 8080:80

stopk:
	@kubectl delete deployment hello-ngingo