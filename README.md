# Modelagem de Banco de Dados - Academia

Entrega Semana 01

Nome: [Antonio Magno Marinho Costa Junior]
Curso: [Analise e Desenvolvimento de Sistemas]

## Cenário escolhido

Escolhi o mini-desafio da **Academia**.

Na academia tem os alunos, que escolhem um plano (mensal, trimestral ou anual) e pagam a mensalidade. Tem também os instrutores, que dão as aulas (spinning, yoga, zumba, etc). Os alunos podem se inscrever nas aulas que quiserem.

## Levantamento de requisitos

Fiz as duas leituras do texto. Na segunda eu grifei os substantivos e verbos.

Substantivos: aluno, plano, mensalidade, instrutor, aula

Verbos: escolhe (plano), paga, dá (aula), se inscreve

Regras que eu tirei do cenário:
- cada aluno tem um plano
- um plano pode ter vários alunos
- um aluno paga várias mensalidades
- um instrutor pode dar várias aulas, mas cada aula tem só um instrutor
- um aluno pode fazer várias aulas e uma aula tem vários alunos

## Entidades e atributos

**ALUNO**
- id_aluno (PK)
- nome
- cpf
- telefone
- data_nascimento

**PLANO**
- id_plano (PK)
- nome
- valor
- duracao_meses

**PAGAMENTO**
- id_pagamento (PK)
- data_pagamento
- valor_pago
- forma_pagamento

**INSTRUTOR**
- id_instrutor (PK)
- nome
- telefone
- especialidade

**AULA**
- id_aula (PK)
- nome
- dia_semana
- horario
- vagas

## Relacionamentos e cardinalidade

| Relacionamento | Cardinalidade |
|---|---|
| PLANO - ALUNO (um plano tem vários alunos) | 1:N |
| ALUNO - PAGAMENTO (um aluno faz vários pagamentos) | 1:N |
| INSTRUTOR - AULA (um instrutor dá várias aulas) | 1:N |
| ALUNO - AULA (aluno faz várias aulas e a aula tem vários alunos) | N:N |

Não encontrei nenhum 1:1 nesse cenário.

## Diagrama

```
PLANO ---1:N--- ALUNO ---1:N--- PAGAMENTO
                  |
                 N:N
                  |
INSTRUTOR ---1:N--- AULA
```

## Observação

O relacionamento entre ALUNO e AULA é N:N, então na modelagem lógica vai precisar de uma tabela no meio (tipo "inscrição"). Isso eu vou ver na próxima etapa.
