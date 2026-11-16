Funcionalidade: Gerenciamento da Fight Level
  Como responsável pela academia
  Quero gerenciar estudantes e consultar os recursos do aplicativo
  Para acompanhar as atividades da equipe e os horários de treino

  Cenário: Adicionar um estudante
    Dado que estou na página inicial
    Quando seleciono "Insert Student" e informo um nome válido
    Então o estudante deve aparecer na lista de estudantes

  Cenário: Impedir cadastro sem nome
    Dado que estou no formulário de novo estudante
    Quando tento salvar sem informar um nome
    Então o cadastro não deve ser concluído
    E devo ver uma mensagem de validação

  Cenário: Remover estudante com confirmação
    Dado que há estudantes cadastrados
    Quando seleciono um estudante para remoção e confirmo
    Então ele deixa de aparecer na lista

  Cenário: Cancelar remoção de estudante
    Dado que selecionei um estudante para remoção
    Quando cancelo a confirmação
    Então o estudante continua na lista

  Cenário: Buscar estudante
    Dado que estou na busca de estudantes
    Quando digito parte do nome, experiência ou graduação
    Então vejo somente os estudantes correspondentes

  Cenário: Consultar treinos da semana
    Quando abro "Workout"
    Então vejo os dias da semana e os horários de treino cadastrados
    E os dias sem treino são identificados

  Cenário: Abrir a comunidade no Instagram
    Quando seleciono "Community"
    Então o perfil do Instagram da equipe é aberto externamente

  Cenário: Acessar recursos da navegação
    Quando seleciono uma ação da barra inferior
    Então a página correspondente é exibida
