if which kubectl > /dev/null; then
  source <(kubectl completion bash);
fi

if which helm > /dev/null; then
  source <(helm completion bash);
fi

if which minikube > /dev/null; then
  source <(minikube completion bash);
fi

