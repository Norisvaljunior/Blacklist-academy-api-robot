*** Settings ***
Resource  ../resources/blacklist_testes_recursos.resource

*** Variables ***

*** Test Cases ***
Cenário com POST: Logando no sistema
  Logando como administrador
  Conferir se logou como administrador
  Validar o token e gravar em um header de autorização

Cenário com POST: Criar usuário no sistema
  Criar novo usuário

Cenário com POST: Criar Centro de custo
  Criar centro de custo


Cenário com POST: Criar Diretoria
  Criar Diretoria
 
Cenário com POST: Criar Departamento
  Criar centro de custo
  Criar um novo Departamento
  Cadastrar um novo Departamento

