# Capítulo 1: O que é Inteligência Artificial?

## Objetivo do capítulo

Ao final deste capítulo, você terá uma compreensão clara do que é IA, como ela funciona na prática e por que ela se tornou tão relevante hoje. Você será capaz de identificar oportunidades de aplicação no seu próprio contexto, seja como desenvolvedor, gestor ou entusiasta.

---

## O conceito: além do buzzword

### Uma definição prática

Inteligência Artificial é um campo da computação que cria sistemas capazes de realizar tarefas que, em humanos, dependem de inteligência — como reconhecer uma voz, decidir se um e-mail é spam, ou sugerir um produto.

A palavra-chave aqui é **sistemas**. IA não é magia; são algoritmos, dados e computação trabalhando juntos.

### Dois tipos principais de IA

Quando falamos de IA no mundo real, quase sempre nos referimos à **IA estreita**:

- **IA estreita** (ou fraca): especializada em uma tarefa específica. É o que existe hoje. Seu smartphone usa IA estreita para desbloquear com reconhecimento facial; o Netflix usa para recomendar filmes.
- **IA geral** (ou forte): uma IA que igualaria ou superaria a inteligência humana em qualquer domínio. Ainda é ficção científica. Nenhum sistema atual se aproxima disso.

O que importa para nós é a IA estreita — e ela já é incrivelmente poderosa.

---

## Para gestores: o valor da IA para negócios

### Onde a IA traz retorno

A IA entrega valor quando automatiza decisões ou gera conteúdo em escala. Exemplos concretos:

- **Atendimento**: chatbots que resolvem 70% das perguntas frequentes sem intervenção humana
- **Vendas**: recomendação personalizada que aumenta conversão em 20-40%
- **Operações**: classificação automática de documentos (faturas, contratos)
- **Segurança**: detecção de fraudes em transações em tempo real

### Quando NÃO investir em IA

- **Problemas mal definidos**: se você não sabe o que quer resolver, a IA não vai adivinhar
- **Dados de má qualidade**: lixo entra, lixo sai. Sem bons dados, a IA falha
- **Custo proibitivo**: se cada decisão custa R$ 1 e você toma 10 decisões/dia, não vale a pena
- **Ética sensível**: diagnosticar doenças ou decidir crédito para pessoas require supervisão humana

### ROI realista

Segundo McKinsey (2023), empresas que adotaram IA em processos específicos tiveram:
- Redução de custos operacionais de 15 a 25%
- Aumento de receita de 5 a 15% (personalização)
- ROI típico: 6 a 18 meses

Mas cuidado: 70% dos projetos de IA falham por falta de preparação de dados ou definição clara de métricas.

---

## Para desenvolvedores: a implementação prática

### Os três componentes de um sistema de IA

1. **Dados**: a matéria-prima. Sem dados de qualidade, nada funciona.
2. **Algoritmo**: o "cérebro" que aprende padrões dos dados.
3. **Aplicação**: onde o modelo é usado — API, interface, integração.

### Um exemplo completo: classificação de e-mails

Vamos construir juntos um classificador de spam. É simples, mas ilustra todos os conceitos.

#### Primeiro,的准备 (preparação)

```python
# Instale as bibliotecas necessárias
# pip install pandas scikit-learn

import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.naive_bayes import MultinomialNB
from sklearn.metrics import accuracy_score, classification_report

# Dataset simples de exemplo (substitua por dados reais)
dados = {
    'texto': [
        'Ganhe dinheiro rápido sem esforço',
        'Reunião de equipe amanhã às 10h',
        'Oferta exclusiva só por hoje!',
        'Relatório mensal pronto para revisão',
        'Você ganhou um iPhone grátis!'
    ],
    'spam': [1, 0, 1, 0, 1]  # 1 = spam, 0 = legítimo
}

df = pd.DataFrame(dados)
```

#### Segundo, a transformação

O computador não entende texto. Precisamos converter palavras em números:

```python
# TF-IDF: transforma texto em vetor numérico
vectorizer = TfidfVectorizer(stop_words=['portuguese'])
X = vectorizer.fit_transform(df['texto'])
y = df['spam']

print(f"Vocabulário: {vectorizer.get_feature_names_out()}")
print(f"Matriz TF-IDF:\n{X.toarray()}")
```

#### Terceiro, o treinamento

```python
# Dividimos em treino e teste
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=42)

# Modelo simples, mas eficaz para texto
modelo = MultinomialNB()
modelo.fit(X_train, y_train)

# Previsão
y_pred = modelo.predict(X_test)
print(f"Acurácia: {accuracy_score(y_test, y_pred):.2f}")
print(classification_report(y_test, y_pred))
```

#### Quarto, o uso

```python
# Classifique um novo e-mail
novo_email = ["Você foi selecionado para um prêmio! Clique aqui"]
vetor_novo = vectorizer.transform(novo_email)
predicao = modelo.predict(vetor_novo)

resultado = "SPAM" if predicao[0] == 1 else "LEGÍTIMO"
print(f"Classificação: {resultado}")
```

### Armadilhas comuns (e como evitá-las)

1. **Dados desbalanceados**: se 95% dos e-mails são legítimos, o modelo pode aprender a sempre dizer "não spam" e acertar 95% sem servir para nada. **Solução**: balanceie o dataset ou use métricas como F1-score, não apenas acurácia.

2. **Vazamento de dados (data leakage)**: informações do futuro no treino. Ex: coluna "data_de_envio" que correlaciona com spam. **Solução**: analyze features cuidadosamente.

3. **Degradação do modelo**: um modelo que funcionava hoje pode falhar amanhã se o padrão de spams mudar. **Solução**: monitoramento contínuo e retreinamento periódico.

### Além do exemplo

Para ir mais longe:
- Use `scikit-learn` para modelos mais sofisticados (RandomForest, SVM)
- Explore `spacy` para processamento de linguagem natural em português
- Implemente API com FastAPI para servir o modelo
- Adicione logs e métricas de monitoramento

---

## Exercícios: fixe o conhecimento

### Nível 1 — conceitual

1. **Identificação**: encontre 3 exemplos de IA estreita que você usa diariamente (sem perceber).
2. **Analogia**: explique a diferença entre "programação tradicional" e "aprendizado de máquina" para alguém sem conhecimento técnico.
3. **Critério**: quando um sistema merece ser chamado de IA? Um termostato programado é IA?

### Nível 2 — técnico

1. **No Colab**, baixe o dataset `sms-spam-collection` (Kaggle) e treine o classificador acima. Acurácia esperada: acima de 95%.
2. **Pré-processamento**: aplique stemming em português (`nltk.stem.RSLPStemmer`) antes da vetorização. Compare resultados.
3. **Métricas**: calcule precision, recall e F1-score. Onde o modelo mais erra? Que tipo de spam ele deixa passar?

### Nível 3 — desafio

1. **Pipeline completo**: construa um projeto completo desde coleta de dados (web scraper de fóruns) até API FastAPI, com Docker e testes unitários.
2. **Monitoramento**: integre Evidently AI para detectar drift nos dados de entrada.
3. **Adversário**: teste o classificador com exemplos de spam "inteligente" que tentam enganar (ex: "G4nh3 d1nh31r0"). Como defender?

---

## Checklist de validação

- [ ] Entendo a diferença entre IA estreita e IA geral
- [ ] Identifiquei 3 problemas no meu trabalho que poderiam usar IA
- [ ] Executei o exemplo de spam detection do zero
- [ ] Sei explicar por que dados de qualidade são mais importantes que algoritmos sofisticados
- [ ] Consigo convencer um gestor do valor (e limites) da IA em uma área específica

---

## Fontes consultadas

- Russell, Stuart, e Peter Norvig. *Artificial Intelligence: A Modern Approach*. 4ª ed., Pearson, 2020.
- Samuel, Arthur L. "Some Studies in Machine Learning Using the Game of Checkers". *IBM Journal of Research and Development*, 1959.
- scikit-learn: Machine Learning in Python. Disponível em: https://scikit-learn.org/
- spaCy: Industrial-strength Natural Language Processing. https://spacy.io/
