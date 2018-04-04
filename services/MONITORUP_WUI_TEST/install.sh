docker build . -t monitorup-wui-test:{{service.local.hash}} --build-arg gitHash={{cp.pr.hash}} --build-arg prId={{cp.pr.id}} --build-arg oAuthToken={{cp.github.oath.token}}
