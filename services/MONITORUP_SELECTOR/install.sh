docker build . -t monitorup-selector:{{service.local.hash}} --build-arg gitHash={{cp.pr.hash}} --build-arg oAuthToken={{cp.github.oath.token}} --build-arg prId={{cp.pr.id}}
