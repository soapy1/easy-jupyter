# Use and AWS compute node

## Requirements
 - [ansible][ansible]
 - [terraform][terraform]

 [ansible]: http://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html?
 [terraform]: https://www.terraform.io/intro/getting-started/install.html

 ## How to Use
1. To setup the terraform environment run a  `make init`
2. Spin up a server run a `make build-server`.
```bash
$ make build-server
cd terraform; terraform apply -auto-approve
aws_instance.web: Creating...
  ami:                          "" => "ami-7b807206"
  associate_public_ip_address:  "" => "true"
  availability_zone:            "" => "<computed>"
  ebs_block_device.#:           "" => "<computed>"
  ephemeral_block_device.#:     "" => "<computed>"
  get_password_data:            "" => "false"
  instance_state:               "" => "<computed>"
  instance_type:                "" => "c5.xlarge"
  ipv6_address_count:           "" => "<computed>"
  ipv6_addresses.#:             "" => "<computed>"
  key_name:                     "" => "dev"
  network_interface.#:          "" => "<computed>"
  network_interface_id:         "" => "<computed>"
  password_data:                "" => "<computed>"
  placement_group:              "" => "<computed>"
  primary_network_interface_id: "" => "<computed>"
  private_dns:                  "" => "<computed>"
  private_ip:                   "" => "<computed>"
  public_dns:                   "" => "<computed>"
  public_ip:                    "" => "<computed>"
  root_block_device.#:          "" => "<computed>"
  security_groups.#:            "" => "1"
  security_groups.3453312491:   "" => "sg-ea6bbe9c"
  source_dest_check:            "" => "true"
  subnet_id:                    "" => "subnet-c11c1fa5"
  tenancy:                      "" => "<computed>"
  volume_tags.%:                "" => "<computed>"
  vpc_security_group_ids.#:     "" => "<computed>"
aws_instance.web: Still creating... (10s elapsed)
aws_instance.web: Creation complete after 14s (ID: i-039bd2790c87c4674)
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
Outputs:
id = i-039bd2790c87c4674
ip = 35.170.52.155
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
Outputs:
id = i-039bd2790c87c4674
ip = 35.170.52.155
```

3. Provision the server with a `make provision-server IP={ip of the server from the terraform output, in this case 35.170.52.155}`. This will setup the ssh key and repo
```bash
$ make provision-server IP=35.170.52.155       
cd ansible; echo '35.170.52.155' > inv; ansible-playbook -v -i inv  --private-key ~/.ssh/dev.pem main.yml
Using /etc/ansible/ansible.cfg as config file
PLAY [setup dev env]
TASK [Gathering Facts]
The authenticity of host '35.170.52.1557 (35.170.52.155)' cant be established.
ECDSA key fingerprint is SHA256:WN563TtYPBiVr/20W05chS+EQlgNCSdQkbYDct0O/q4.
Are you sure you want to continue connecting (yes/no)? yes
ok: [107.23.24.227]
TASK [copy ssh file]
ok: [107.23.24.227] => {"changed": false, "checksum": "3e041cbba2f542de07b7727d2a2a2b8d9d494440", "gid": 1000, "group": "ubuntu", "mode": "0400", "owner": "ubuntu", "path": "/home/ubuntu/.ssh/dev", "size": 3243, "state": "file", "uid": 1000}
TASK [clone repo]
changed: [107.23.24.227] => {"changed": true, "cmd": "ssh-agent bash -c 'ssh-add /home/ubuntu/.ssh/dev; cd /home/ubuntu/; git clone git@github.com:RaunaqSuri/clickbait-detector.git'", "delta": "0:00:14.469691", "end": "2018-04-02 16:12:23.285487", "rc": 0, "start": "2018-04-02 16:12:08.815796", "stderr": "Identity added: /home/ubuntu/.ssh/dev (/home/ubuntu/.ssh/dev)\nCloning into 'clickbait-detector'...", "stderr_lines": ["Identity added: /home/ubuntu/.ssh/dev (/home/ubuntu/.ssh/dev)", "Cloning into 'clickbait-detector'..."], "stdout": "", "stdout_lines": []}
107.23.24.227              : ok=3    changed=1    unreachable=0    failed=0
```
4. start up jupyter notebook, notebook starts at {IP}:8888
```
make start-jupyter-notebook                                                130 ↵
cd ansible; ansible-playbook -v -i inv  --private-key ~/.ssh/dev.pem jupyter_start.yml
Using /etc/ansible/ansible.cfg as config file
PLAY [start jupyter]
TASK [Gathering Facts]
ok: [35.170.71.156]
TASK [start jupyter]
changed: [35.170.71.156] => {"changed": true, "cmd": "screen -dmS test bash -c 'echo waiting 5 senconds...; sleep 5; exec /home/ubuntu/miniconda3/bin/jupyter notebook'", "delta": "0:00:00.002926", "end": "2018-04-04 13:58:51.623150", "rc": 0, "start": "2018-04-04 13:58:51.620224", "stderr": "", "stderr_lines": [], "stdout": "", "stdout_lines": []}
PLAY RECAP
35.170.71.156     
```
5. ssh into the server `ssh -i ansible/files/dev ubuntu@{ip}`
6. Clean up when you are done
```bash
$ make destroy-server                                                          2 ↵
cd terraform; terraform destroy
aws_instance.web: Refreshing state... (ID: i-039bd2790c87c4674)
An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  - destroy
Terraform will perform the following actions:
  - aws_instance.web
Plan: 0 to add, 0 to change, 1 to destroy.
Do you really want to destroy?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.
  Enter a value: yes
aws_instance.web: Destroying... (ID: i-039bd2790c87c4674)
aws_instance.web: Still destroying... (ID: i-039bd2790c87c4674, 10s elapsed)
aws_instance.web: Still destroying... (ID: i-039bd2790c87c4674, 20s elapsed)
aws_instance.web: Destruction complete after 20s
Destroy complete! Resources: 1 destroyed.
```
