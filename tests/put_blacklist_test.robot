*** Settings ***
Resource  ../resources/blacklist_testes_recursos.resource

*** Variables ***

*** Test Cases ***
Cenário com POST: Inativar Departamento
  Criar centro de custo
  Criar um novo Departamento
  Cadastrar um novo Departamento
  Inativar Departamento

Cenário com POST: Editar Departamento
  Criar centro de custo
  Editar Departamento
