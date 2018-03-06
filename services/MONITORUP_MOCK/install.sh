docker build . -t monitorup-mock:{{service.local.hash}} --build-arg gitHash={{cp.pr.hash}} --build-arg oAuthToken={{cp.github.oath.token}}
