*** Settings ***
Documentation  O objetivo deste arquivo é armazenar todos os recursos para os testes  
Library  RequestsLibrary
Library  String
Library  Collections

*** Keywords *** 
Criar sessão
  ${headers}        Create Dictionary   accept=application/json                                  Content-Type=application/json
  Create Session    alias=APIBlacklist  url= https://squad-black-list.qacoders-academy.com.br    headers=${headers}

Logando como administrador
  ${body}      Create Dictionary        mail=sysadmin@qacoders.com  password=1234@Test
  Log          ${body}
  Criar sessão
  ${resposta}  POST On Session          alias=APIBlacklist          url=/api/login              json=${body}
  Log          ${resposta.json()}
  Set Test Variable    ${ID_TOKEN}      ${resposta.json()["token"]}
  Set Test Variable    ${RESPOSTA}      ${resposta.json()}

Conferir se logou como administrador
  Log                  ${RESPOSTA}
  Dictionary Should Contain Item        ${RESPOSTA}    msg    Olá Qa-Coders-SYSADMIN, autenticação autorizada com sucesso!
  #Log To Console    ${RESPOSTA}

Validar o token e gravar em um header de autorização
  ${headers}         Create Dictionary    Authorization=Bearer ${ID_TOKEN}
  ${resposta}        GET On Session       alias=APIBlacklist        url=/api/validateToken     headers=${headers}
  Log                ${ID_TOKEN}


Criar novo usuário   # Esse foi o primeiro código de inserção no banco que fiz, funcionou mais não é o padrão.
  Criar sessão
  Logando como administrador
  ${randomica}         Generate Random String    length=5      chars=[LETTERS]
  ${randomica}         Convert To Lower Case     ${randomica}
  Set Test Variable    ${NOVOUSUARIO}            Usuario Blacklist${randomica}   

  ${CPF}               Generate Random String    11            [NUMBERS]
   
  
  ${headers}     Create Dictionary        Authorization=${ID_TOKEN}            
  ${response}    GET On Session           alias=APIBlacklist        url=/api/user              headers=${headers}
  Log   ${response.content}

  ${header}      Create Dictionary        Content-Type=application/json    Authorization=${ID_TOKEN}
  ${Response}    POST On Session          alias=APIBlacklist   url=/api/user   headers=${header}   data={ "fullName": "${NOVOUSUARIO}", "mail": "Blacklis${CPF}@qacoders.com.br", "password": "1234@Test", "accessProfile": "ADMIN", "cpf": "${CPF}", "confirmPassword": "1234@Test" }
  Log            ${response.json()["msg"]}
  Log To Console    ${Response.json()}
  Log To Console    ${Response.status_code}
  Log To Console    ${Response.content}
  Log To Console    ${Response.headers}


Criar Diretoria      # Esse foi um código de inserção que gera a massa de dados e grava no banco em um mesmo cenário.
  Logando como administrador
  Criar sessão

  ${randomica}  Generate Random String  length=5  chars=[LETTERS]
  ${randomica}  Convert To Lower Case   ${randomica}
  ${body}       Create Dictionary       boardName=Blacklist${randomica}             
  Log           ${body}
  
 # Set Test Variable       ${DEPARTAMENTO}             Blacklistxxx&${palavra_randomica}

  ${headers}     Create Dictionary      Content-Type=application/json            Authorization=${ID_TOKEN} 
  ${resposta}    POST On Session        alias=APIBlacklist     url=/api/board/   headers=${headers}    json=${body}     expected_status=201
  Log            ${resposta.json()}
  Set Test Variable    ${DIRETORIA_ID}        ${resposta.json()["newBoard"]["_id"]}
  Set Test Variable    ${resposta}            ${resposta.json()}

Criar centro de custo
  Criar Diretoria

  ${palavra_randomicacc}  Generate Random String  length=5  chars=[LETTERS]
  ${palavra_randomicacc}  Convert To Lower Case   ${palavra_randomicacc}
  ${body}                 Create Dictionary         costCenterName=Blacklist${palavra_randomicacc}            boardId=${DIRETORIA_ID}    
  Log                   ${body}

  ${headers}     Create Dictionary                Content-Type=application/json    Authorization=${ID_TOKEN} 
  ${resposta}    POST On Session                  alias=APIBlacklist               url=/api/costCenter/     headers=${headers}    json=${body}     expected_status=201
  Log                  ${resposta.json()}
  Set Test Variable    ${CENTROCUSTO_ID}          ${resposta.json()["newCostCenter"]["_id"]}
  Set Test Variable    ${resposta}                ${resposta.json()}

Criar um novo Departamento   # Esse foi o segundo código de inserção no banco que ficou mais estruturado. Ele já faz a massa de dados na primeira etapa e gravação na segunda. 
  ${palavra_randomica}    Generate Random String      length=37     chars=[LETTERS]
  Set Test Variable       ${DEPARTAMENTO}             Blacklistxxx&${palavra_randomica}

Cadastrar um novo Departamento
  ${body}        Create Dictionary    departmentName=${DEPARTAMENTO}         costCenterId=${CENTROCUSTO_ID}
  Log    ${body}

  ${headers}     Create Dictionary    Content-Type=application/json    Authorization=${ID_TOKEN} 
  ${resposta}    POST On Session      alias=APIBlacklist     url=/api/department/      headers=${headers}    json=${body}     expected_status=201
  Log             ${resposta.json()}
  Set Test Variable    ${DEPARTAMENTO_ID}     ${resposta.json()["newDepartment"]["_id"]}
  Set Test Variable    ${resposta}            ${resposta.json()}

Inativar Departamento
  ${header}    Create Dictionary  Content-Type=application/json    Authorization=${ID_TOKEN}
  ${Response}  PUT On Session     alias=APIBlacklist               url=/api/department/status/${DEPARTAMENTO_ID}    headers=${header}   data={ "status": false }
  Log    ${response.json()["msg"]}
  Log To Console    ${Response.json()}
  Log To Console    ${Response.status_code}
  Log To Console    ${Response.content}


Editar Departamento
  Criar um novo Departamento
  Cadastrar um novo Departamento
  ${palavra_randomica}      Generate Random String      length=5  chars=[LETTERS]
  ${palavra_randomica}      Convert To Lower Case       ${palavra_randomica}
  Set Test Variable         ${EDITARDEPARTAMENTO}       Departamento Editado&${palavra_randomica}
  ${header}                 Create Dictionary           Content-Type=application/json      Authorization=${ID_TOKEN}    
  ${Response}               PUT On Session              alias=APIBlacklist     url=/api/department/${DEPARTAMENTO_ID}    headers=${header}    data={ "departmentName": "${EDITARDEPARTAMENTO}" , "costCenterId": "${CENTROCUSTO_ID}" }
  Log                       ${response.json()["msg"]}
#  Log To Console    ${Response.json()}
#  Log To Console    ${Response.status_code}
#  Log To Console    ${Response.content}

Listar Departamento
  Criar sessão
  Logando como administrador
  ${headers}=      Create Dictionary    Content-Type=application/json    Authorization=${ID_TOKEN} 
  ${response}=     GET On Session       alias=APIBlacklist    url=/api/department    expected_status=200    headers=${headers}
  Log To Console   ${response.status_code}
  Log To Console   ${response.content}
  Log To Console   ${response.headers}





