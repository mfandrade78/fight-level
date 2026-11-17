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

## APK para Android

Este repositório inclui um workflow em
[.github/workflows/build-apk.yml](.github/workflows/build-apk.yml) que gera um APK
automáticamente em cada push na branch `main` e também pode ser executado manualmente
via `workflow_dispatch`.

O arquivo final é publicado como release do GitHub com o nome `fight-level.apk` e pode
ser baixado em:

- GitHub Releases do repositório
- ou pelo artefato gerado pela action

Para instalar no celular:

1. baixe o APK do GitHub Releases;
2. habilite `Instalar apps desconhecidos` no Android;
3. abra o arquivo baixado e confirme a instalação.

Observação: a publicação real do APK acontece somente após o push deste código para o
GitHub e a execução bem-sucedida da action.
