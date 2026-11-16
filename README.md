# Fight Level

Aplicativo Flutter para consultar estudantes, acompanhar progresso e ver os
horários semanais de treino.

## Funcionalidades

- Cadastro e remoção de estudantes durante a sessão do aplicativo.
- Busca por nome, experiência ou graduação.
- Filtros de estudantes por ordem alfabética e disponibilidade de mídia.
- Agenda semanal de treinos.
- Atalhos para o perfil da equipe no Instagram, notificações, conquistas e ajuda.

Os estudantes adicionados ou removidos são mantidos em memória e voltam à lista
inicial quando o aplicativo é reiniciado.

## BDD e testes

Os cenários de comportamento estão em
[`test/features/fight_level.feature`](test/features/fight_level.feature).

Para executar os testes de interface:

```sh
flutter test
```
