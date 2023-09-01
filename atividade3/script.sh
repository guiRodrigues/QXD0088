#!/bin/bash

url="http://joao.marcelo.nom.br/disciplinas/20212/scripts/atividades/arquivos/auth.log"

action() {
    curl $url -o auth.log

    grep -v "sshd" auth.log > "item1.log"
    grep "sshd.*session opened for user j" auth.log > "item2.log"
    grep "sshd.*Disconnected from authenticating user root" auth.log > "item3.log"
    grep -E '^Oct (11|12).* New session' auth.log > "item4.log"
}

action
