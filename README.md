Based on tutorial at https://developer.hashicorp.com/terraform/tutorials/kubernetes/gke

Run terraform init and terraform apply to create the GKE cluster.
Then run kubectl apply -f echo-server.yaml to deploy the echo server.
Then run kubectl get service echo-server to get the external IP address of the echo server.
Open the ip address in a web browser to see the echo server response.
