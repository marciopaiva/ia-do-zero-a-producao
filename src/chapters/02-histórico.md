# Capítulo 2: Histórico e evolução da IA

## Objetivo do capítulo

Entender a história da IA não é só curiosidade — é uma ferramenta prática. Os ciclos de hype e desilusão ensinam quando uma tecnologia está madura ou ainda é experimental. Ao final, você vai conseguir separar o que é real hoje do que é promessa para o futuro.

---

## A história como ciclo: invernos e verões

### Uma analogia: a IA como uma planta

Pense na IA como uma planta que passa por ciclos:
- **Verão**: sol forte, crescimento rápido, todo mundo nota
- **Inverno**: frio, estagnação, alguns acreditam que morreu
- Mas no inverno, as raízes crescem silenciosamente. No próximo verão, ela volta mais forte

Cada "inverno da IA" enterrou técnicas obsoletas. Cada "verão" trouxe aplicações reais.

---

## 1950–1970: Era da esperança

### O teste de Turing (1950)

Alan Turing, matemático britânico, propôs um experimento mental: se um humano não consegue distinguir, por conversa, se está falando com outro humano ou com uma máquina, essa máquina pode ser considerada inteligente?

Essa pergunta abriu o campo. Não sobre construir máquinas conscientes, mas sobre **comportamento inteligente**.

### Conferência de Dartmouth (1956)

Foi aqui que o termo "Inteligência Artificial" foi cunhado. John McCarthy organizou um workshop de dois meses para explorar se máquinas poderiam aprender e usar linguagem.

O otimismo era enorme. Pesquisadores acreditavam que em 20 anos teríamos máquinas tão inteligentes quanto humanos. Eles estavam errados sobre o prazo, mas certos sobre a direção.

### Primeiros sistemas

**Logic Theorist (1956)** — de Newell e Simon — foi o primeiro programa que simulava resolução de problemas. Ele provedou teoremas do *Principia Mathematica* de Whitehead e Russell, às vezes de formas mais elegantes que os humanos.

**ELIZA (1966)** — de Joseph Weizenbaum — simulava uma psicoterapeuta. Transformava frases do usuário em perguntas. As pessoas rapidamente percebiam que não era uma pessoa, mas o experimento mostrou como o **efeito Eliza** funciona: projetamos inteligência onde não há.

**Shakey (1966)** — primeiro robô móvel que podia raciocinar sobre ações. Ele via o ambiente com câmeras, planejava rotas e executava. Lento, caro, mas revolucionário.

### Por que o primeiro inverno (1974-1980)?

Promessas não se cumpriam. Computadores eram fracos. Dados, inexistentes. Os sistemas especialistas eram caros e frágeis. Agências de financiamento (como DARPA) cortaram recursos. A IA entrou em hibernação.

---

## 1980–1993: Sistemas especialistas e conexionismo

### A era das regras

Enquanto a IA simbólica (baseada em lógica) patinava, surgiram os **sistemas especialistas**. A ideia: capturar o conhecimento de especialistas humanos em regras if-then.

**MYCIN** — sistema para diagnosticar infecções sanguíneas — era impressionante. Continha 600 regras escritas por médicos. Funcionava bem, mas:
- Manter as regras era trabalhoso
- Era frágil a situações fora do escopo
- Não aprendia com novos casos

Empresas investiram bilhões em sistemas especialistas nos anos 80. Resultado: muitos projetos falharam. Segundo inverno.

### Paralelamente: redes neurais ressurgem

Em 1986, Rumelhart, Hinton e Williams popularizaram o algoritmo **backpropagation** para treinar redes neurais multicamadas. Era a renascença dos connectionistas — mas o poder computacional ainda limitava. Só com GPUs, anos depois, isso decolou.

---

## 1997–2012: Era estatística

### Deep Blue vs. Kasparov (1997)

A IBM derrotou o campeão mundial de xadrez. Foi uma vitória da **força bruta**: o Deep Blue examinava 200 milhões de posições por segundo, combinada com regras humanas.

A lição: em domínios bem definidos, regras + poder computacional podem superar humanos.

### A revolução dos dados

Nessa fase, o foco mudou para aprendizado de máquina estatístico:

- **Support Vector Machines (SVM)**: eficazes com dados de médio porte
- **Árvores de decisão e ensembles** (Random Forest, Gradient Boosting)
- **Data mining** em bases de dados corporativas

Aplicações práticas surgiram:
- Reconhecimento de voz (Siri, 2011)
- Filtros de spam (Gmail, 2004)
- Recomendação (Amazon, Netflix)

O padrão era: dados estruturados, algoritmos interpretáveis, resultados preditivos.

---

## 2012–presente: A revolução do deep learning

### AlexNet e o tipping point (2012)

Na competição ImageNet, uma rede neural profunda chamada **AlexNet** (Krizhevsky, Sutskever, Hinton) reduziu a taxa de erro de 26% para 15% — uma mudança de 10 pontos percentuais, inédita.

Por que foi revolucionário?
1. **GPU**: treinou em 2 GPUs NVIDIA, algo antes raro
2. **ReLU**: função de ativação que evapora o problema do gradiente vanishing
3. **Dropout**: regularização que evita overfitting

Essa vitória convenceu o mundo de que redes profundas funcionavam.

### Transformers: a arquitetura que mudou tudo (2017)

O artigo "Attention Is All You Need" (Vaswani et al., Google) introduziu o **Transformer** — arquitetura baseada em atenção (attention), não em RNNs ou CNNs.

Por que importa?
- Processa sequências em paralelo (não sequencial)
- Contexto longo: captura relações entre palavras distantes
- Escalável: funciona melhor quanto maior

Isso viabilizou os **modelos de linguagem grandes (LLMs)**.

### De BERT a ChatGPT (2018-2022)

- **BERT** (Google, 2018): modelo bidirecional que entende contexto. Revolucionou NLP.
- **GPT-2** (OpenAI, 2019): gerava texto coerente. Foi "liberado" gradualmente por preocupações de misuse.
- **GPT-3** (2020): 175 bilhões de parâmetros. Mostrou que escala traz capacidades emergentes (few-shot learning).
- **ChatGPT** (2022): fine-tuning com RLHF tornou o modelo útil e seguro. Democratizou o acesso.
- **GPT-4, Claude 3, Gemini** (2023-2024): multimodais, mais precisos, maiores contextos.

### Geração de imagens: GANs e difusão

- **GANs** (Goodfellow, 2014): duas redes rivais (gerador e discriminador) criam imagens realistas.
- **DALL-E 2** (2022), **Midjourney** (2022): geram imagens a partir de texto.
- **Stable Diffusion** (2022): open-source, roda localmente.
- **Sora** (2024): geração de vídeo.

---

## Lições da história para gestores

### Ciclo de hype

1. **Início**: nova técnica (ex: Transformers) gera entusiasmo
2. **Pico de expectativas**: todo mundo acha que vai revolucionar tudo
3. **Desilusão**: limitações aparecem; projetos falham
4. **Ascensão sólida**: casos de uso reais se consolidam
5. **Produtividade**: a tecnologia se torna rotina

Hoje estamos na fase de **ascensão sólida** da IA generativa. Alguns setores (marketing, suporte) já têm produtividade comprovada. Outros (medicina, jurídico) ainda estão na fase de validação.

### O que mudou permanentemente

- **Custo de desenvolvimento**: caiu drasticamente. Sem APIs, um projeto levaria meses. Com APIs, dias.
- **Barreiras técnicas**: saber programar ainda ajuda, mas não é mais pré-requisito absoluto
- **Velocidade de inovação**: um novo modelo a cada 3-6 meses

### O que NÃO mudou

- **Dados de qualidade**: continuam sendo o fator #1 de sucesso
- **Alinhamento com negócio**: tecnologia sem problema claro não entrega valor
- **Ética e governança**: IA não regula sozinha

---

## Para desenvolvedores: evolução técnica

### Do código tradicional ao prompt

Em 2010, um projeto típico de IA envolvia:
- Coletar dados → limpar → feature engineering → treinar modelo → deploy → monitorar

Hoje:
- Definir o problema → escrever um bom prompt → iterar → testing → deploy → monitoring

A mudança não é trivial:
- Antes: você construía o modelo
- Hoje: você orquestra modelos existentes

### Exemplo de evolução temporal

**2015 (TensorFlow 1.x)**:
```python
import tensorflow as tf

# Criar grafo computacional
x = tf.placeholder(tf.float32, [None, 784])
W = tf.Variable(tf.zeros([784, 10]))
b = tf.Variable(tf.zeros([10]))
y = tf.matmul(x, W) + b
```

**2024 (Hugging Face)**:
```python
from transformers import pipeline

# Uma linha faz o trabalho pesado
generator = pipeline("text-generation", model="gpt-4")
resultado = generator("Explique IA em uma frase", max_length=30)
```

A produtividade explodiu. Os desafios mudaram: agora lidamos com custo por token, latência de API, quality control de geração.

---

## Exercícios: reflita e pratique

### Nível 1 — conceitual

1. Por que ocorreram "invernos da IA"? O que mudou que tornou 2024 diferente?
2. Compare ELIZA (1966) e ChatGPT (2022). Qual a diferença técnica e qual a diferença percebida pelo usuário?
3. Se AlexNet não tivesse vencido o ImageNet em 2012, a IA estaria onde está hoje?

### Nível 2 — técnico

1. No Colab, carregue o dataset MNIST e treine uma CNN simples com Keras. Acurácia deve passar de 98%. Compare com uma rede fully connected simples.
2. Implemente desde zero (numpy apenas) um classificador KNN para o Iris dataset. Meça o tempo de execução para diferentes valores de k.
3. Use a API do OpenAI para gerar três versões da mesma pergunta: zero-shot, one-shot, few-shot. Discuta as diferenças.

### Nível 3 — desafio

1. Leia o artigo original do Transformer ("Attention is All You Need", 2017). Implemente um mecanismo de multi-head attention do zero usando apenas numpy.
2. Escolha um benchmark clássico (por exemplo, GLUE para NLP). Pesquise a evolução dos scores de 2018 a 2024. O que isso diz sobre progresso?
3. Crie uma linha do tempo interativa com Streamlit mostrando os principais modelos e datasets lançados desde 2010.

---

## Checklist de validação

- [ ] Consigo explicar para um leigo por que a IA "explodiu" nos últimos 10 anos
- [ ] Sei diferenciar IA simbólica, estatística e generativa
- [ ] Executei um exemplo de classificação com CNN no MNIST
- [ ] Entendo, em alto nível, como o Transformer funciona
- [ ] Consigo identificar quando uma novidade de IA é hype ou avanço real

---

## Fontes consultadas

- Russell, Stuart, e Peter Norvig. *Artificial Intelligence: A Modern Approach*. 4ª ed., Pearson, 2020.
- Goodfellow, Ian, Yoshua Bengio, e Aaron Courville. *Deep Learning*. MIT Press, 2016.
- Krizhevsky, Alex, Ilya Sutskever, e Geoffrey Hinton. "ImageNet Classification with Deep Convolutional Neural Networks". *NeurIPS*, 2012.
- Vaswani, Ashish, et al. "Attention Is All You Need". *NeurIPS*, 2017.
- "A Year in AI" — Stanford HAI Annual Reports, 2022–2024.
