docker build . -t monitorup-wui:{{service.local.hash}} --build-arg gitHash={{cp.git.hash}} --build-arg oAuthToken={{cp.github.oath.token}}
