# Projeto de Análise de Dados: Viagens a Serviço (Portal da Transparência)

## Sobre o Projeto

Este projeto foi desenvolvido como o **Projeto Avaliativo do Módulo 1** do curso de Análise de Dados com Python, turma T2, da **ScTec / Profissionalizar**.

O objetivo principal é construir um pipeline de dados que consome, limpa, transforma e analisa dados sobre **Viagens a Serviço** do Governo Federal, permitindo a extração de insights reais para apoiar tomadas de decisão.

As perguntas de negócio que precisavam ser respondidas foram:

1. Os 5 órgãos com maior custo total?
2. Os 3 destinos com maior custo médio por viagem?
3. A viagem de maior duração e seu custo total?
4. Qual o tipo de pagamento com maior valor médio?
5. Qual o meio de transporte mais usado nos trechos?
6. Qual UF de destino aparece em mais trechos?
7. Qual órgão pagou mais no total?

---

## Estrutura dos Arquivos do Projeto

### Pasta Principal:
* **gitignore:** Arquivo para ignorar arquivos desnecessários no repositório.
* **requirements.txt:** Resumo das bibliotecas e ferramentas necessárias para a execução do projeto.
* **read.me**

### notebooks:
* **3_analisar.py (ou Jupyter Notebook):** Script de análise de dados (Camada Gold) responsável pelas queries de negócio e plotagem dos gráficos.

### reports:
Nesta pasta encontram-se os arquivos de imagem dos gráficos plotados na etapa de análise.

### scripts:
* **config.py e banco.py:** Arquivos de configuração de ambiente e utilitários de conexão com o banco de dados.
* **1_extrair.py:** Script Python responsável pelo download automatizado do dataset, descompactação e carga em lotes para a camada Raw (Bronze).
* **2_transformar.py:** Pipeline em Python que executa as queries SQL de migração e higienização dos dados da camada Raw para a Silver.

### sql
* **0_criar_banco.sql:** Script SQL responsável por provisionar o banco de dados e criar a modelagem física das tabelas RAW e Silver.
* **gold.sql:** Script para criação da etapa gold e sua view.


---

## Principais insights e conclusões:

* O Ministério da Justiça e Segurança Pública é o órgão com maior custo total em viagens, apresentando uma diferença alta para o segundo colocado, o Ministério da Defesa, gastando 3.1 vezes o valor da Defesa. Para entender melhor o motivo desta diferença, seria necessário avaliar, principalmente, a coluna "motivo"
* A questão 2 pode ser calculada de formas diferentes, o que gera, consequentemente, dados diferentes. Da maneira que calculei, os destinos mais caros foram fora do Brasil, o que, de forma lógica, faz sentido. Para informações mais apuradas, poder-se-ia aprofundar a pesquisa neste assunto.
* A viagem mais longa não possui nenhum gasto, o que parece um pouco contraditório. Olhando com mais cuidado os detalhes do registro, vê-se que o motivo dele é: "Convocar o servidor, para atuação presencial junto á APS Mogi Mirim, nas mesmas atividades que atualmente exercem na lotação de origem". Na verdade, parece tratar-se de um deslocamento de local de trabalho. Neste caso, talvez essa informação não devesse ser tratada como viagem e nem precisaria aparecer neste banco de dados. De qualquer forma, não é possível ter certeza desta inferência e possível erro nos dados sem consultar os órgãos governamentais competentes, o que não cabia ao projeto atual.
* Na pergunta 4, existem apenas 4 meios de pagamento. Em sequência descrescente, eles são: diárias (R$ 2.078,28), passagem (R$ 1.878,34), serviço correlato - seguro ($ 447,51) e restituição (R$ 245,70). Esses itens mais parecem categorias do que formas de pagamento, não tendo formas mais clásssicas como cartão de crédito, pix, ou correlatos.
* Em relação à pergunta 5, percebe-se que o meio de transporte mais usado para as viagens é o veículo oficial, mas cabe destaque também o meio aéreo. Juntos, eles representam em torno de 80% do total das viagens.
* Já a questão 6 mostra que o destino mais frequente é o Distrito Federal, o que faz total sentido, já que é a capital do Brasil. DF é seguido por São Paulo e Rio de Janeiro, todas as 3 sendo capitais importantes para o país, em vários aspectos. É importante frisar, porém, que há uma diferença significativa entre o número de viagens ao DF (72297) em relação a SP (46392).
* Quanto à pergunta 7, o órgão superior com mais gastos foi o Ministério da Justiça e Segurança Pública, o que ecoa o resultado da primeira questão: se há mais viagens, é lógico imaginar que o custo também é maior para este órgão.
* Por último, para abarcar todos os critérios de avaliação, resolvi fazer um gráfico que analisasse o total de passagens emitidas (silver_passagem) por cada órgão superior (informação que se encontra na tabela silver_viagem). Foi utilizado um `inner join` para isso. No gráfico é possível perceber que o Ministério da Defesa é o que tem mais passagens emitidas, o que coindice com os gráficos da pergunta 1 e 7, apesar de, nestes casos, ter ficado em segundo lugar. Ainda assim, valor gasto pode estar diretamente relacionado à quantidade de passagens emitidas. Para haver certeza, só fazendo uma análise mais profunda neste quesito.

---

## Tecnologias e Ferramentas

* **Banco de Dados:** MySQL / SQL (camadas organizadas em estruturas de tabelas de passagem e trechos).
* **Linguagem de Programação:** Python.
* **Análise de Dados:** Pandas, sys e os (para buscar o módulo banco).
* **Visualização de Dados:** Matplotlib, textwrap (para adequação de rótulos no último gráfico) e Seaborn (estilização com paletas de cores harmônicas e soluções para sobreposição de elementos).

---

## Arquitetura de Dados (Medallion Architecture)

O projeto segue estritamente o conceito de arquitetura de medalhões, dividindo os dados em camadas para garantir rastreabilidade, auditoria e performance:

```text
[ Fonte Oficial ]
│
▼  (Fase 1: Extração)
┌──────────────┐
│  Camada RAW  │  <- Dados brutos originais guardados em formato de texto
│   (Bronze)   │     no MySQL (tabelas raw_*)
└──────┬───────┘
│
▼  (Fase 2: Transformação)
┌──────────────┐
│Camada SILVER │  <- Dados higienizados, tipados corretamente (DATE, DECIMAL)
│   (Prata)    │     e com integridade referencial (Chaves Primárias e Estrangeiras)
└──────┬───────┘
│
▼  (Fase 3: Análise)
┌──────────────┐
│ Camada GOLD  │  <- Agregações e métricas prontas para responder perguntas de
│    (Ouro)    │     negócio e alimentar visualizações
└──────────────┘
```

---

## Desafios Técnicos Superados

Durante o desenvolvimento do pipeline, foram superados desafios de engenharia de dados, incluindo:

* **Alinhamento e Normalização de Esquemas (Camada Raw):** Ajuste fino de colunas e ordem de importação em lotes (chunksize) usando Pandas para ler diretamente de arquivos ZIP sem estourar a memória RAM do computador.
* **Integridade Referencial Estrita:** Garantia de chaves estrangeiras (FOREIGN KEY) funcionais na camada Silver, resolvendo desencontros comuns em chaves públicas do governo federal (cruzamento do identificador único com número de propostas).
* **Limpeza e Deduplicação de Dados:** Remoção automatizada de duplicidades utilizando constraints nativas do banco (PRIMARY KEY, UNIQUE) e técnicas de inserção inteligente (INSERT IGNORE).
* **Problemas técnicos no SQL:** No processo de criação das queries em SQL, alguns problemas técnicos aconteceram. Algumas queries foram pesadas demais para se executar, quebrando o processo de transformação dos dados brutos em refinados (Raw para Silver). Diretamente do arquivo 2_transformar.py, o MySQL chegou a perder contato com o servidor. A resolução deste problema exigiu otimização, servindo de grande aprendizado para os próximos projetos.

---

## Como Executar o Projeto

1. Clone este repositório:
   ``git clone [https://github.com/seu-usuario/seu-repositorio.git](https://github.com/seu-usuario/seu-repositorio.git)``
2. Instale as dependências necessárias:
   ``pip install pandas matplotlib seaborn mysql-connector-python``
3. Certifique-se de ter um banco de dados MySQL configurado com as tabelas do SCDP (silver_viagem, silver_trecho, silver_passagem e silver_pagamento).
4. Abra e execute o notebook principal:
   ``jupyter notebook analise_viagens.ipynb``

---

## Melhorias a serem implementadas

* **Adequação de gráficos:** Em um possível processo de melhoria deste projeto, alguns gráficos de barra poderiam ser transformados em gráficos de pizza ou de rosca (como para a pergunta 5, que pede o meio de transporte com maior custo). Neste caso, porém, deve-se levar em consideração que, havendo mais de 5 categorias, seria interessante expor as 4 maiores e reunir as restantes em um grupo "Outros", para manter a visualização dos dados limpa e profissional.
* **Aprofundamento sobre a diferença de custo total dos órgãos:** Como comentado na seção de conclusões e insights, é possível aprofundar a análise para entender o porquê de o Ministério da Justiça ser o que tem mais gastos. Essa análise provavelmente seria mais complexa pela necessidade de utilizar os campos de "motivo", com texto, diminuindo as possibilidades de análise quantitativa.
* **Adequação apurada de dados:** Para deixar as respostas mais confiáveis, seria importante criar um filtro no projeto para identificar e corrigir dados estranhos, como aquela viagem super longa que apareceu com custo zero. Além disso, seria ótimo corrigir a coluna "meio de pagamento" para que ela mostre formas de pagamento de verdade (como Pix, boleto ou cartão), em vez de misturar com o tipo da despesa (passagens, diárias).
* **Criar mapas visuais das viagens:** Como o Distrito Federal é o destino mais frequente, uma melhoria visual muito legal seria criar um mapa interativo do Brasil mostrando de onde as pessoas saem e para onde vão. Isso deixaria a apresentação muito mais dinâmica do que apenas usar gráficos de barras.
* **Deixar as consultas no SQL mais rápidas:** Para evitar que o banco de dados trave ou perca a conexão (como aconteceu ao tentar cruzar as tabelas de passagens e viagens), uma melhoria técnica importante seria criar "atalhos" de busca no banco de dados (chamados de índices). Isso faria o sistema rodar as perguntas em segundos, sem sobrecarregar o computador.

---

Desenvolvido por Lilian Severino da Silva
