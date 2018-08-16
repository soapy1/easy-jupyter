init:
	cd terraform; terraform init

build-server:
	cd terraform; terraform apply -auto-approve

destroy-server:
	cd terraform; terraform destroy

provision-server:
	cd ansible; echo '${IP}' > inv; ansible-playbook -v -i inv  --private-key ~/.ssh/dev.pem main.yml

start-jupyter-notebook:
	cd ansible; ansible-playbook -v -i inv  --private-key ~/.ssh/dev.pem jupyter_start.yml
