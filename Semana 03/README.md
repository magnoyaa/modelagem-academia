[README.md](https://github.com/user-attachments/files/32445553/README.md)
# Banco de Dados da Academia - Semana 03

Nome: Antonio Magno Marinho Costa Junior
Curso: Analise e Desenvolvimento de Sistemas

## Cenário

Continuei com a academia das outras semanas. Os alunos escolhem um plano e pagam mensalidade, os instrutores dão as aulas (spinning, yoga, zumba) e os alunos se inscrevem nas aulas que querem.

## Do conceitual pro lógico

Peguei o MER da semana 02 e passei pro modelo relacional usando as regras que vimos em aula:

- entidade virou tabela, com o identificador como PK
- nos relacionamentos 1:N a FK fica na tabela do lado N, então o `id_plano` foi pra ALUNO, o `id_aluno` pra PAGAMENTO e o `id_instrutor` pra AULA
- o N:N entre aluno e aula virou uma tabela no meio, a INSCRICAO, com PK composta (`id_aluno` + `id_aula`)

Nesse cenário não teve nenhum 1:1.

## Diagrama do modelo lógico

```mermaid
erDiagram
    PLANO ||--o{ ALUNO : tem
    ALUNO ||--o{ PAGAMENTO : faz
    INSTRUTOR ||--o{ AULA : da
    ALUNO ||--o{ INSCRICAO : realiza
    AULA ||--o{ INSCRICAO : recebe

    PLANO {
        int id_plano PK
        varchar(50) nome UK
        decimal(8,2) valor
        int duracao_meses
    }

    ALUNO {
        int id_aluno PK
        varchar(100) nome
        char(11) cpf UK
        varchar(100) email UK
        varchar(15) telefone
        date data_nascimento
        date data_matricula
        int id_plano FK
    }

    PAGAMENTO {
        int id_pagamento PK
        date data_pagamento
        decimal(8,2) valor_pago
        varchar(20) forma_pagamento
        int id_aluno FK
    }

    INSTRUTOR {
        int id_instrutor PK
        varchar(100) nome
        char(11) cpf UK
        varchar(15) telefone
        varchar(50) especialidade
    }

    AULA {
        int id_aula PK
        varchar(50) nome
        varchar(15) dia_semana
        time horario
        int vagas
        int id_instrutor FK
    }

    INSCRICAO {
        int id_aluno PK, FK
        int id_aula PK, FK
        date data_inscricao
    }
```

## Normalização

Pra mostrar a normalização eu imaginei que a academia começou anotando tudo numa planilha só, uma linha por aluno, assim:

```
FICHA (id_aluno, nome_aluno, cpf, telefone, id_plano, nome_plano, valor_plano, duracao_meses,
       AULAS: { id_aula, nome_aula, dia_semana, horario, vagas,
                id_instrutor, nome_instrutor, especialidade, data_inscricao } )
```

O problema é que as AULAS se repetem, porque o aluno pode fazer várias. Não dá pra colocar tudo numa linha só.

### 1FN

Tirei o grupo que se repete e agora cada linha é um aluno em uma aula. Como o mesmo aluno aparece em várias linhas, o `id_aluno` sozinho não serve mais de chave, então a PK ficou (`id_aluno`, `id_aula`).

```
FICHA_1FN (id_aluno, id_aula, nome_aluno, cpf, telefone, id_plano, nome_plano, valor_plano,
           duracao_meses, nome_aula, dia_semana, horario, vagas, id_instrutor,
           nome_instrutor, especialidade, data_inscricao)
```

### 2FN

Na 2FN eu procurei as dependências parciais, que são as colunas que dependem só de um pedaço da chave:

```
id_aluno -> nome_aluno, cpf, telefone, id_plano, nome_plano, valor_plano, duracao_meses
id_aula  -> nome_aula, dia_semana, horario, vagas, id_instrutor, nome_instrutor, especialidade
(id_aluno, id_aula) -> data_inscricao
```

Só a `data_inscricao` depende da chave inteira, porque é a data de um aluno em uma aula específica. O resto depende só do aluno ou só da aula. Do jeito que tava, o nome e o telefone do aluno iam repetir em todas as aulas dele, e se ele trocasse de telefone teria que mudar em várias linhas.

Então separei em 3 tabelas:

```
ALUNO_2FN  (id_aluno PK, nome_aluno, cpf, telefone, id_plano, nome_plano, valor_plano, duracao_meses)
AULA_2FN   (id_aula PK, nome_aula, dia_semana, horario, vagas, id_instrutor, nome_instrutor, especialidade)
INSCRICAO  (id_aluno PK/FK, id_aula PK/FK, data_inscricao)
```

### 3FN

Na 3FN procurei as dependências transitivas, que é quando uma coluna que não é chave depende de outra que também não é chave:

```
ALUNO_2FN: id_aluno -> id_plano -> nome_plano, valor_plano, duracao_meses
AULA_2FN:  id_aula -> id_instrutor -> nome_instrutor, especialidade
```

O nome e o valor do plano dependem do `id_plano` e não do aluno. O nome e a especialidade do instrutor dependem do `id_instrutor` e não da aula. Se deixasse assim o valor do plano se repetia em todo aluno daquele plano, e o nome do instrutor em todas as aulas dele.

Tirei essas colunas e criei as tabelas PLANO e INSTRUTOR:

```
PLANO      (id_plano PK, nome, valor, duracao_meses)
ALUNO      (id_aluno PK, nome, cpf, telefone, id_plano FK)
INSTRUTOR  (id_instrutor PK, nome, cpf, telefone, especialidade)
AULA       (id_aula PK, nome, dia_semana, horario, vagas, id_instrutor FK)
```

### PAGAMENTO

A tabela PAGAMENTO eu não coloquei na ficha, mas conferi separado. Ela tem PK simples (`id_pagamento`) e todas as colunas dependem só dela, então já estava na 3FN e não precisei mudar nada.

### Resultado

Ficaram 6 tabelas na 3FN: PLANO, ALUNO, PAGAMENTO, INSTRUTOR, AULA e INSCRICAO. Agora cada informação fica guardada em um lugar só, então se o valor de um plano mudar é só alterar uma linha.

## Restrições que usei

- **PK** em todas as tabelas (composta na INSCRICAO)
- **FK** em `aluno.id_plano`, `pagamento.id_aluno`, `aula.id_instrutor`, `inscricao.id_aluno` e `inscricao.id_aula`
- **NOT NULL** nos campos obrigatórios
- **UNIQUE** no cpf (aluno e instrutor), no email do aluno e no nome do plano
- **CHECK**: valor e duração do plano maiores que 0, valor pago maior que 0, forma de pagamento só Pix, Cartao ou Dinheiro, vagas maior que 0, dia da semana de Segunda a Sabado, e a matrícula não pode ser antes do nascimento
- **DEFAULT**: `data_matricula` e `data_inscricao` com a data de hoje, `forma_pagamento` como 'Pix' e `vagas` como 20

## Arquivos

- [ddl.sql](ddl.sql) tem os `CREATE TABLE`
- [dml.sql](dml.sql) tem os `INSERT` (de 3 a 5 por tabela) e 3 `SELECT` com `JOIN`

Os SELECTs são:

1. aluno com o nome e o valor do plano (JOIN de 2 tabelas)
2. aluno com as aulas que faz, dia, horário e instrutor (JOIN de 4 tabelas)
3. quantidade de pagamentos e total pago por aluno (JOIN com GROUP BY)

## Como rodar

Usei o MySQL 8. Primeiro roda o `ddl.sql` e depois o `dml.sql`, no Workbench ou assim:

```
mysql -u root -p < ddl.sql
mysql -u root -p < dml.sql
```
