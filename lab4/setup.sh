az ml online-endpoint create --local -n $endpoint_name -f endpoints/online/managed/sample/endpoint.yml

az ml online-deployment create --local -n mydep --endpoint $endpoint_name -f endpoints/online/managed/sample/blue-deployment.yml