# Automation Lab
________________________________________________________________________________

## O Projeto

### Sobre

O propósito desse projeto é criar um ambiente de laboratório para automação
de processos tecnológicos utilizando ferramentas *OpenSource*, de forma a
competir com soluções proprietárias, como o *Ansible Tower*.

### Ferramentas utilizadas

Abaixo, segue a lista das ferramentas/conceitos utilizados para a composição
deste laboratório:

- [x] Docker
- [x] Docker Compose
- [x] Ansible
- [x] Rundeck
- [x] Rundeck API
- [x] Rundeck CLI (rd)
- [ ] Jenkins
- [x] GitLab
- [x] GitLab API
- [ ] GitLab CI
- [ ] Gitflow
- [x] Elasticsearch
- [x] Logstash
- [x] Kibana
- [x] Grafana
- [x] MongoDB

### Estrutura de Diretórios

Arquivo/Diretório | Descrição                                                                |
----------------- | ------------------------------------------------------------------------ |
ansible/          | Estrutura de arquivos do Ansible (Hosts, Playbooks e Roles)              |
automation-lab.sh | Script de inicialização/parada do ambiente                               |
docker/           | Estrutura de arquivos do Docker (Docker Compose, Dockerfiles e volumes)  |
docs/             | Arquivos relacionados à documentação                                     |
README.md         | Documentação principal do projeto (também conhecido como `este arquivo`) |
________________________________________________________________________________

## Utilizando

### Pré-Requisitos

Para executar este laboratório em um ambiente (local ou núvem), é necessário ter
os seguintes pacotes/ferramentas instaladas e configuradas:

- Docker Engine (binário `docker`)
- Docker Compose (binário `docker-compose`)

### Iniciando o Laboratório

Para iniciar o laboratório, siga os passos abaixo:

1. Faça o download deste repositório
1. Entre no diretório raiz do repositório
1. Execute o comando `./automation-lab.sh start IP_EXTERNO`

**Observações**:

- Substitua `IP_EXTERNO` pelo endereço IP externo do seu ambiente local ou cloud
(ou seja, o IP pelo qual as interfaces gráficas das ferramentas serão
acessadas).
- Dependendo das configurações do seu *Sistema Operacional*, pode ser necessário
executar o script acima com `sudo`.

### Operando as ferramentas

Quando a execução do script de inicialização do laboratório for concluída, você
receberá as URLs de acesso às ferramentas em seu terminal.

Exemplo:

```
[2017-08-07 10:34:36] [info] vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
[2017-08-07 10:34:36] [info] The lab is ready to use - Click on the links below and have fun :)
[2017-08-07 10:34:36] [info] ------------------------------------------------------------------
[2017-08-07 10:34:36] [info] GitLab => http://35.192.181.73
[2017-08-07 10:34:36] [info] Rundeck => http://35.192.181.73:8080
[2017-08-07 10:34:36] [info] Kibana => http://35.192.181.73:8090
[2017-08-07 10:34:36] [info] Grafana => http://35.192.181.73:8091
[2017-08-07 10:34:36] [info] ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
```

### Roteiro de Testes do Laboratório

Siga o roteiro abaixo se quiser testar alguns cenários de uso do ambiente de
automação:

1. Em um navegador da web, abra a URL do **Rundeck**
1. Faça login com o usuário **admin** e senha **admin**
1. Clique no projeto **ansible-lab**
1. Verifique que existem 3 Jobs criados e agrupados como **Initial Pack**
1. Execute o Job **Hello World** para testar a comunicação entre o `rundeck` e
os hosts `ansible-core`
1. Não execute os Jobs **Update - Ansible** e **Update - Rundeck** ainda, pois
eles dependem do repositório do GitLab e serão executados automaticamente, via
Webhooks, quando fizermos o primeiro commit.
1. Abra a URL do **GitLab**
1. Faça login com o usuário **root** e senha **automation**
1. Verifique que já existe um repositório criado (`ansible-lab`)
1. Clique no nome do repositório e, quando já estiver dentro dele, clique em
**Settings** e depois em **Integrations**
1. Desça a página até a sessão de **Webhooks** e verifique que já existem 2
webhooks do tipo *Push Events* criados (um para cada um dos Jobs *Update* do
**Rundeck**)
1. Suba a página e clique em **Project** para voltar à página inicial do
projeto.
1. No endereço do repositório, clique em **SSH**, altere o protocolo para
**HTTP** e copie o link completo que foi gerado.
1. Abra um terminal e digite `git clone LINK_COPIADO` (exemplo:
`git clone http://35.192.181.73/root/ansible-lab.git`)
1. Caso solicitado, digite as mesmas credenciais de login do *GitLab* (**root**
/ **automation**)
1. Para simular a operação dos desenvolvedores de *Playbooks* e *Runbooks*,
copie todo o conteúdo do diretório `ansible` deste repositório para o
repositório vazio que você acabou de clonar (copie o conteúdo do diretório
**ansible**, mas não o próprio diretório - Exemplo:
`cp -p ~/git/automation-lab/ansible/* ~/git/ansible-lab`)
1. Faça um commit inicial no repositório com o comando os comandos abaixo
1. `git add --all`
1. `git commit -m "Initial Commit"`
1. `git push origin master`
1. Caso solicitado, digite novamente as credenciais do *GitLab*
1. Agora que você fez uma modificação no repositório, os webhooks do **GitLab**
foram disparados
1. Volte para o **Rundeck** e verifique que os Jobs **Update - Ansible** e
**Update - Rundeck** foram disparados.
1. Como resultado do Job **Update - Ansible**, agora os hosts `ansible-core`
possuem a estrutura do repositório atualizada. Caso novos commits ocorram no
repositório, as mudanças serão refletidas novamente através deste mesmo Job.
1. Como resultado do Job **Update - Rundeck**, agora existem novos Jobs criados
no **Rundeck**. Navegue até a tela de Jobs para visualizá-los e, se desejar,
executá-los. Caso novos commits ocorram no repositório, o **Rundeck** fará uma
nova pesquisa por definições de Jobs, refletindo na ferramenta.
1. Abra a URL do **Kibana**, e visualize os logs das execuções do **Rundeck**
capturados pelo **Logstash**
1. Abra a URL do **Grafana** e faça login com o usuário **admin** e senha
**admin** (nesta ferramenta, futuramente haverão *Dashboards* de visualização
de métricas pré-configurados)
1. Pronto, você concluiu o roteiro de testes do laboratório. Algum passo não deu
certo? Abra uma **Issue** se possível e nos mantenha informado.

### Parando o Laboratório

Para encerrar a execução do laboratório, siga os passos abaixo:

1. Entre no diretório raiz deste repositório
1. Execute o comando `./automation-lab.sh stop`

**Observações**:

- Dependendo das configurações do seu *Sistema Operacional*, pode ser necessário
executar o script acima com `sudo`.
________________________________________________________________________________

## Produ_logs(título tempo)

O objetivo dessa documentação é descrever todas as tecnologias que foram utilizadas para criar o ambiente de coleta, provisionamento dos logs.

<p align="center">
  <img src="https://blog.netapsys.fr/wp-content/uploads/2016/05/ELASTIC_LOGSTASH_KIBANA.jpg">
</p>
--

* [Objetivo do projeto](#objetivo-do-projeto)
* [Tecnologia usada](#tecnologia-usada)
* [Download Instalação](#download-instalação)
* [Configuração do Elasticsearch](#configuração-do-elasticsearch)
* [Configuração do Kibana](#configuração-do-Kibana)
* [Configuração do Mongodb](#Configuração-do-mongodb)
* [Configuração do logstash](#Configuração-do-logstash)
* [Modelo conector](#modelo-conector)
* [Topologia](#Topologia)

### Objetivo do projeto

Desenvolver um ambiente que capture, filtre e que persista as informação de logs gerada pelo lançador rundeck / ansible.

### tecnologia usada

* **Elasticsearch** --> Baseado no Apache Lucene, um servidor de busca e indexação textual, o objetivo do Elasticsearch 
    é fornecer um método de se catalogar e efetuar buscas em grandes massas de informação por meio de interfaces REST 
    que recebem/provêm informações em formato JSON.

* **Logstash** --> Criado pela Elastic, o conceito do Logstash é fornecer pipelines de dados, através do qual podemos 
    suprir as informações contidas nos arquivos de logs das nossas aplicações – além de outras fontes – para diversos 
    destinos, como uma instância de Elasticsearch, um bucket S3 na Amazon, um banco de dados MongoDB, entre outros

* **Mongodb** --> O MongoDB é um document database(banco de dados de documentos), mas não são os documentos da 
    família Microsoft, mas documentos com informações no formato JSON. A ideia é o documento representar toda a 
    informação necessária, sem a restrição dos bancos relacionais

* **Grafana** --> Ferramentas web para criação e exibição de gráficos.

* **Kibana** --> O Kibana foi desenvolvido pela Elastic com o intuito de fornecer uma interface rica que permita 
    consultas analíticas e/ou a construção de dashboards, com base nas informações contidas dentro de um Elasticsearch.

* **

### Download / Instalação

* **Elasticsearch** 
    
    1. https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.5.1.tar.gz
    2. tar -zxvf elasticsearch-5.5.1.tar.gz

* **Logstash**

    1. https://artifacts.elastic.co/downloads/logstash/logstash-5.5.1.tar.gz
    2. tar -zxvf logstash-5.5.1.tar.gz

* **Mongodb**

    1. https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-amazon-3.4.6.tar.gz
    2. tar -zxvf mongodb-linux-x86_64-amazon-3.4.6.tar.gz

* **Grafana**

    1. https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana-4.4.2.linux-x64.tar.gz 
    2. tar -zxvf grafana-4.4.2.linux-x64.tar.gz 

* **Kibana**

    1. https://artifacts.elastic.co/downloads/kibana/kibana-5.5.1-linux-x86_64.tar.gz
    2. tar -zxvf kibana-5.5.1-linux-x86_64.tar.gz

* **

### Configuração do mongodb

* **Usuário mongod**

  1. useradd -d /usr/local/mongodb -g mongodb -r mongodb
  2. chown mongodb.mongodb mongodb/ -R

* **Execução do mongod**

  1. bin/mongod -dbpath data/db/ --directoryperdb > /tmp/mongodb.log 2<&1 &
  
### Configuração do logstash

* **Execução do logstash**
  
  1. bin/logstash -f "etc/pipeline-rundeck.conf"

* **Pipeline de configuração**

```
input {
	tcp {
		port => 6511
		type => 'rundeck'
	}
}

filter {
	json {
		source => message
	}
	ruby {
	code => "
		hash = event.to_hash
		hash.each do |k,v|
		if v == nil
			event.remove(k)
		end
		end
	"
	}
	mutate {
		convert => { "message" => "string" }
		remove_field => [
			"line", "event.stepctx"
		]
	}
	if[message] =~ /nil/ {
		mutate {
			remove_field => ["execution.id","execution.serverUrl", 
			"execution.group", "@timestamp", "port", "execution.executionType", 
			"execution.username", "execution.serverUUID", "@version", "host", 
			"execution.url","totallines", "execution.retryAttempt", "execution.wasRetry", 
			"execution.loglevel","execution.name", "line", "datetime", "event.step", "event.node", 
			"event.user", "execution.user.name", "eventType", "message", "execution.project", 
			"event.stepctx", "execution.execid", "loglevel"]
		}
	}
}

output {
	if[message] != "PLAY RECAP **************************
  *******************************************" and 
	[message] != "TASK [apache : Configuring Apache files] **********************
  *****************" and 
	[message] != "TASK [Gathering Facts] ***************************
  ******************************" and 
	[message] != "PLAY [all] ********************************
  *************************************" and 
	[message] != "" {
		stdout  { codec => rubydebug }
		mongodb {
			uri => "mongodb://localhost"
			database => "rundecklog"
			collection => "ansible"
		}
		elasticsearch {
			manage_template => true
			hosts => ["localhost:9200"]
			index => "rundecklog-%{+YYYY.MM.dd}"
		}
	}
}
```

### Modelo conector

* **mongodb doc sucesso**

```
{
        "_id" : ObjectId("59848657b959ec530700001b"),
        "execution.id" : "7ac894bd-3629-49e1-94cb-4dd449f7f050",
        "execution.name" : "Ansible Playbook",
        "type" : "rundeck",
        "datetime" : NumberLong("1501857383983"),
        "execution.serverUrl" : "http://172.20.150.95/",
        "execution.group" : null,
        "@version" : "1",
        "host" : "172.20.150.95",
        "event.step" : "1",
        "execution.wasRetry" : "false",
        "event.node" : "ansible-core",
        "event.user" : "root",
        "execution.user.name" : "admin",
        "eventType" : "log",
        "message" : "node-03: ok=2  changed=0  unreachable=0  failed=0",
        "execution.project" : "ansible-lab",
        "execution.execid" : "6049",
        "@timestamp" : "\"2017-08-04T14:36:07.680Z\"",
        "port" : 43880,
        "execution.executionType" : "scheduled",
        "execution.username" : "admin",
        "loglevel" : "NORMAL",
        "execution.serverUUID" : null,
        "execution.url" : "http://172.20.150.95/project/ansible-lab/execution/follow/6049",
        "execution.retryAttempt" : "0",
        "execution.loglevel" : "INFO"
}

        message: [node1, node2, node3]
```

* **mongodb doc falha**

```
{
        "_id" : ObjectId("5984f9ccb959ecd3a60000ae"),
        "execution.id" : "7ac894bd-3629-49e1-94cb-4dd449f7f050",
        "execution.name" : "Ansible Playbook",
        "execution.user.name" : "admin",
        "eventType" : "log",
        "message" : "Execution failed: 9005 in project ansible-lab: [Workflow result: , 
            step failures: {1=Dispatch failed on 1 nodes: [ansible-core: NonZeroResultCode: Remote command failed with 
            exit status 1]}, Node failures: {ansible-core=[NonZeroResultCode: Remote command failed with exit status 1]}, 
            status: failed]",
        "type" : "rundeck",
        "execution.project" : "ansible-lab",
        "execution.execid" : "9005",
        "datetime" : NumberLong("1501886940930"),
        "@timestamp" : "\"2017-08-04T22:48:44.905Z\"",
        "execution.serverUrl" : "http://172.20.150.95/",
        "port" : 50460,
        "execution.executionType" : "scheduled",
        "execution.username" : "admin",
        "loglevel" : "ERROR",
        "@version" : "1",
        "host" : "172.20.150.95",
        "execution.url" : "http://172.20.150.95/project/ansible-lab/execution/follow/9005",
        "execution.retryAttempt" : "0",
        "execution.wasRetry" : "false",
        "execution.loglevel" : "INFO"
}
```

### Topologia

![Produb]
(docs/log.png)

