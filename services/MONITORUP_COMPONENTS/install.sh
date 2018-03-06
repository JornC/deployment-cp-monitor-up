docker build . -t monitorup-components:{{service.local.hash}} --build-arg oAuthToken={{cp.github.oath.token}}
