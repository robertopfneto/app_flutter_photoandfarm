# app_flutter_photoandfarm

### Autor
    Roberto Pereira de Freitas Neto

# Resumo

    - Aplicativo para o Front-End de um protótipo de um sistema que contém um Back End conectado (API Django Rest Framework). Registram fazendas, pessoas
    e fotos, enviando-as para API e sendo salvas pelo Banco de Dados (PostgreSQL)

# Setup

    1. Instalar o Android Studio
        1.1 Versão utilizada: 7.6.3

    2. Ao executá-lo, crie um emulador de Android
        2.1 Versão utilizada : Pixel 3.0 API 30

    3. Selecioná-lo para executar ao rodar o arquivo `main` do flutter. Para selecionar, basta apertar no botão ao lado do ícone de notificações localizado no canto inferior direito da interface do VS Code.

    - No arquivo pubspec.yaml estão as dependências utilizados no front-end do projeto

    cupertino_icons: 1.0.6
    http: 1.2.1
    image_picker: 1.0.8
    model_progress_hud_nsn: 0.5.1
    collection: 1.15.0

    após atualizar para essas versões, executar os comandos:
    `flutter doctor`, `flutter clean` e `flutter pub get` para limpar e garantir que todas as dependências estejam atualizadas no projeto 

    Obs: O aplicativo não vai conseguir salvar nenhum dado se a API não estiver
    funcionando, por isso, é necessário executar a api django na respectiva pasta

    `cd caminho_para_o_arquivo_django/api`
    `python manage.py runserver seu_ip_local_aqui:8000`
    
  
        
        - Caso queira alterar o link das requisições para api, basta modificar cada caminho em `/lib/models/urls.dart`

### Instruções para uso

    - A área de autenticação não está completa com conexão com o google, por isso, o login está definido no código para acesso ao aplicativo
    
    *Nome : "Qualquer um"
   
    *email: teste
    
    *senha: 123
    
    *Selecione uma data qualquer

    - É necessário que haja pelo menos uma fazenda cadastrada para conseguir
    registrar uma pessoa, bem como é necessário existir uma pessoa cadastrada para cadastrar e enviar uma foto para api
    
## Sobre o recebimento de fotos

 - Apenas uma imagem por vez
 - todas as fotos serão salvas na pasta `/media/photos`


