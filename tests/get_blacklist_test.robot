*** Settings ***
Resource  ../resources/blacklist_testes_recursos.resource

*** Variables ***

*** Test Cases ***
Cenário com GET : Módulo Departamento
  Listar Departamento

Cenário com GET : Módulo Diretoria
  Pesquisar Diretoria
