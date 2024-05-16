*** Settings ***
Resource  ../resources/blacklist_testes_recursos.resource

*** Variables ***

*** Test Cases ***
Cenário com GET : Testando Módulo Departamento
  Listar Departamento
