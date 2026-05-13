# Capítulo 3 — Aprendizado de Máquina vs. IA Generativa

## Objetivo do capítulo

Escolher a abordagem correta para seu problema, compreendendo os trade-offs entre machine learning tradicional e IA generativa em termos de custo, controle, qualidade e adequação ao caso de uso.

---

## 3.1 Duas filosofias, dois resultados

### Analogia: calculadora vs. parceiro criativo

Pense em duas ferramentas:

- **Machine Learning (ML) tradicional** é como uma **calculadora avançada**. Você dá números, ela devolve um resultado preciso. Você sabe exatamente o que esperar. Se 2+2=4 sempre.

- **IA Generativa** é como um **parceiro criativo**. Você dá uma direção ("escreva um poema sobre café"), e ele cria algo novo a cada vez. Às vezes brilhante, às vezes bizarro.

Ambas são úteis. A chave é saber quando usar cada uma.

---

## 3.2 Machine Learning tradicional: previsão e classificação

### O que faz

ML tradicional aprende a mapear **entradas** para **saídas** com base em dados históricos.

**Exemplos clássicos:**
- Prever preço de casa a partir de características (tamanho, localização)
- Classificar e-mail como spam ou não-spam
- Detectar fraude em transações
- Recomendar produto baseado em histórico

### Características

- **Dados estruturados**: tabelas, CSV, SQL
- **Rotulados**: cada exemplo tem uma resposta correta
- **Modelos menores**: milhares a milhões de parâmetros (não bilhões)
- **Inferência barata**: milissegundos, CPU够
- **Interpretável**: você pode entender por que decidiu (árvores, coeficientes)

### Ferramentas

- scikit-learn
- XGBoost, LightGBM
- TensorFlow/PyTorch (redes menores)

---

## 3.3 IA Generativa: criação de conteúdo

### O que faz

Gera **conteúdo novo** — texto, imagem, código, áudio — que se assemelha ao material de treinamento, mas não é cópia.

**Exemplos:**
- Escrever artigos, roteiros, e-mails
- Gerar imagens a partir de descrições
- Produzir código-fonte
- Criar variações de campanhas de marketing

### Características

- **Dados massivos**: internet inteira (ou quase)
- **Não-rotulados**: aprende sozinho a prever próximo token
- **Modelos enormes**: bilhões/trilhões de parâmetros
- **Inferência cara**: centenas de ms a segundos, GPU recomendada
- **Caixa preta**: difícil explicar por que gerou isso

### Ferramentas

- GPT-4, Claude, Gemini (APIs)
- Llama 2, Mistral (open-source local)
- Stable Diffusion, DALL-E (imagens)

---

## 3.4 Comparação lado a lado

| Critério | ML Tradicional | IA Generativa |
|----------|----------------|---------------|
| **Tarefa** | Prever classificação/valor | Criar novo conteúdo |
| **Dados** | Estruturados, rotulados | Não estruturados, massivos |
| **Tamanho** | Pequeno–médio | Enorme (B–T params) |
| **Custo inferência** | Baixo (CPU) | Alto (GPU ou API) |
| **Interpretabilidade** | Moderada–alta | Baixa |
| **Criatividade** | Nenhuma | Alta |
| **Caso de uso** | Crédito, detecção de fraude | Chatbots, geração de conteúdo |

---

## 3.5 Quando usar ML tradicional

### Critérios

Use quando:

1. **Dados estruturados e rotulados disponíveis**
2. **Métrica de precisão crítica** (ex: score de crédito, diagnóstico)
3. **Custo operacional sensível** (milhões de predições/dia)
4. **Explicabilidade necessária** (regulado por Lei 13.709/2018)

### Exemplos brasileiros

- **Banco do Brasil**: scoring de crédito (XGBoost)
- **Nubank**: detecção de fraude em tempo real
- **Magazine Luiza**: recomendação de produtos baseada em histórico de compras
- **ClearSale**: chargeback prevention

### Implementação mínima

```python
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import classification_report

# Dados estruturados
X, y = load_my_data()
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)

model = RandomForestClassifier(n_estimators=100)
model.fit(X_train, y_train)

print(classification_report(y_test, model.predict(X_test)))
```

---

## 3.6 Quando usar IA generativa

### Critérios

Use quando:

1. **Conteúdo novo é necessário** (texto, imagem, código)
2. **Dados não estruturados** (PDFs, e-mails, conversas)
3. **Criatividade desejada** (brainstorming, variações)
4. **Velocidade de onboarding** (sem rotular dados)

### Exemplos

- **Atendimento**: chatbot que responde perguntas frequentes
- **Marketing**: geração de copy para anúncios
- **Documentação**: sumarização de contratos
- **Código**: autocomplete inteligente

### Implementação mínima

```python
from transformers import pipeline

generator = pipeline("text-generation", model="gpt2")
result = generator("A inteligência artificial no Brasil", max_length=100)
print(result[0]['generated_text'])
```

---

## 3.7 O híbrido: RAG (Retrieval-Augmented Generation)

### O problema

 IA generativa sozinha:
- Alzheimer (esquece fora do contexto)
- Alucina (inventa fatos)
- Não conhece seus dados privados

### A solução

Combine **recuperação** (ML tradicional) com **geração** (LLM):

```text
Pergunta → Embedding → Busca em base de conhecimento → Contexto → LLM → Resposta
```

**Vantagens:**
- Baseado em fontes confiáveis
- Atualizável (só atualiza a base, não o modelo)
- Menor custo (uso estratégico de contexto)

### Exemplo de código

```python
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
from transformers import pipeline

# 1. Base de conhecimento
documentos = [
    "Política de devolução: 30 dias sem motivo",
    "Horário: seg–sex 9h–18h",
    "Frete grátis acima de R$ 200"
]

# 2. Indexação
vectorizer = TfidfVectorizer()
matriz = vectorizer.fit_transform(documentos)

# 3. Busca
pergunta = "Qual o prazo para troca?"
pergunta_vec = vectorizer.transform([pergunta])
similaridades = cosine_similarity(pergunta_vec, matriz)
indice = similaridades.argsort()[0][-1]  # mais similar
contexto = documentos[indice]

# 4. Geração
generator = pipeline("text-generation", model="gpt2")
prompt = f"Contexto: {contexto}\nPergunta: {pergunta}\nResposta:"
resposta = generator(prompt, max_length=100)
print(resposta[0]['generated_text'])
```

---

## 3.8 Fluxo de decisão: qual abordagem escolher?

Pergunte-se nesta ordem:

1. **O problema é estruturado e tem dados rotulados?**
   - Sim → ML tradicional
   - Não → vá para 2

2. **Você precisa criar conteúdo original?**
   - Sim → IA generativa
   - Não → vá para 3

3. **A decisão exige alta precisão e explicabilidade?**
   - Sim → ML tradicional
   - Não → considere IA generativa com guardrails

4. **O volume de uso é altíssimo e custo é sensível?**
   - Sim → ML tradicional (ou modelo local leve)
   - Não → IA generativa via API pode valer

### Exemplo aplicado

**Problema:** classificação automática de tickets de suporte

- Dados: tickets históricos com标签 (baixa/alta prioridade) → **ML tradicional**
- Modelo: classificador leve (RandomForest)
- Custo: ~US$ 10/mês para 10K predições

**Problema:** resposta automática a clientes

- Dados: base de conhecimento (FAQ) + criatividade necessária → **RAG (híbrido)**
- Recuperador: embedding search
- Gerador: LLM leve
- Custo: ~US$ 50/mês para 5K interações

---

## Para gestores: análise de custo-benefício

### Comparativo financeiro

| Aspecto | ML Tradicional | IA Generativa | Híbrido (RAG) |
|---------|----------------|---------------|---------------|
| **Custo inicial** | Alto (engenharia de features) | Baixo (integração API) | Médio (indexação + API) |
| **Custo operacional** | Baixo (CPU) | Alto (por token) | Médio (busca barata + geração moderada) |
| **Manutenção** | Retreinamento periódico | Atualização de prompts | Atualizar base de conhecimento |
| **ROI típico** | 6–12 meses | 3–6 meses | 4–8 meses |
| **Risco** | Data drift | Alucinação, custo variável | Complexidade |

### Recomendações por setor

- **Varejo/E-commerce**: ML tradicional para previsão de demanda; IA generativa para descrições de produto
- **Finanças**: ML tradicional para crédito/fraude; RAG para atendimento regulatório
- **Saúde**: ML tradicional para triagem; IA generativa para documentação (não diagnóstico)
- **Jurídico**: RAG para busca em contratos; IA generativa para minutas (com revisão humana)

---

## Para desenvolvedores: implementação prática

### Stack recomendada

**ML tradicional:**
- scikit-learn (comece aqui)
- XGBoost (modelos tree-based)
- TensorFlow/PyTorch (redes profundas, se necessário)

**IA generativa:**
- OpenAI API (GPT-4) — mais capable
- Anthropic (Claude) — mais seguro
- Llama 2 local (via `llama-cpp-python`) — sem custo por token

**RAG:**
- LangChain ou LlamaIndex para orquestração
- ChromaDB/Pinecone para banco vetorial
- Sentence Transformers para embeddings

### Exemplo de pipeline híbrido

```python
from langchain_community.document_loaders import WebBaseLoader
from langchain_text_splitters import RecursiveCharacterTextSplitter
from langchain_community.vectorstores import Chroma
from langchain_openai import OpenAIEmbeddings, ChatOpenAI
from langchain.chains import RetrievalQA

# 1. Carregar documentos
loader = WebBaseLoader("https:// SuaDocumentacao.com")
docs = loader.load()

# 2. Dividir em chunks
text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=200)
splits = text_splitter.split_documents(docs)

# 3. Criar banco vetorial
vectorstore = Chroma.from_documents(documents=splits, embedding=OpenAIEmbeddings())

# 4. Criar cadeia RAG
llm = ChatOpenAI(model="gpt-4")
qa_chain = RetrievalQA.from_chain_type(
    llm=llm,
    retriever=vectorstore.as_retriever(),
    return_source_documents=True
)

# 5. Perguntar
result = qa_chain.invoke({"query": "Como funciona a política de reembolso?"})
print(result["result"])
```

**Pronto:** um sistema de perguntas e respostas baseado em seus documentos, com fontes citadas.

---

## Exercícios

### Nível 1 — conceitual

1. Dê um exemplo onde ML tradicional é claramente superior à IA generativa.
2. Explique, em suas palavras, o que é um embedding.
3. Quando você escolheria RAG em vez de LLM puro?

### Nível 2 — técnico

1. No Colab, treine um classificador de sentimentos com scikit-learn (dataset IMDB). Compare acurácia com GPT-3.5 via few-shot learning.
2. Implemente busca semântica simples com Sentence Transformers e cosine similarity.
3. Construa um RAG com LangChain: indexe 3 artigos próprios e faça perguntas.

### Nível 3 — desafio

1. Crie um decision tree que, dados características de um problema (tipo de dados, volume, necessidade de explicabilidade), recomende ML tradicional vs. IA generativa vs. RAG.
2. Implemente um sistema híbrido: ML tradicional para classificação de intenção + LLM para gerar resposta.
3. Compare custos mensais de usar GPT-4 vs. Llama 2 local para um caso real (ex: suporte ao cliente).

---

## Checklist de validação

- [ ] Consigo diferenciar claramente ML tradicional e IA generativa
- [ ] Sei quando usar cada abordagem
- [ ] Entendo o que são embeddings e sua importância
- [ ] Implementei ao menos um exemplo de cada paradigma
- [ ] Consigo estimar custo operacional de cada opção
- [ ] Sei montar um pipeline RAG básico
- [ ] Identifiquei casos no meu trabalho onde cada técnica se aplica

---

## Fontes consultadas

- **scikit-learn documentation** — https://scikit-learn.org/
- **Hugging Face Transformers** — https://huggingface.co/docs/transformers/
- **LangChain Documentation** — https://python.langchain.com/
- **Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks** — Lewis et al., 2020 (arXiv:2005.11401)
- **Attention Is All You Need** — Vaswani et al., 2017
- **GPT-4 Technical Report** — OpenAI, 2023
