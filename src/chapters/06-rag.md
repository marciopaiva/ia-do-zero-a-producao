# Capítulo 6 — RAG: Fazendo a IA Trabalhar com Seus Dados

## Objetivo do capítulo

Ensinar a construir aplicações de IA conectadas a conhecimento próprio usando RAG (Retrieval-Augmented Generation). Este é um dos capítulos mais importantes: aqui o leitor aprende a conectar IA ao mundo real, usar documentos internos, reduzir alucinações e criar produtos úteis de verdade.

---

## 6.1 O problema da IA sem contexto

### O limite dos modelos

Modelos de linguagem são treinados em dados públicos até uma certa data. Eles **não conhecem**:

- Documentos internos da sua empresa
- Manual do seu produto
- Políticas específicas
- Dados privados

**Exemplo:**
```text
Usuário: "Qual o prazo de garantia do produto X?"
LLM: não sabe → inventa ou dá resposta genérica
```

### Consequência: alucinações

Sem contexto, o modelo preenche lacunas com "conhecimento" estatístico que pode ser errado.

**Solução:** fornecer contexto relevante junto com a pergunta.

---

## 6.2 O que é RAG

### Definição

> Retrieval-Augmented Generation (RAG) é uma técnica que busca informações relevantes em uma base de conhecimento antes de gerar uma resposta.

### Analogia: bibliotecário + especialista

Imagine que você tem um especialista genial (o LLM) que não leu seus documentos internos. Você contrata um **bibliotecário** que:

1. Recebe a pergunta
2. Busca os documentos relevantes
3. Entrega os trechos para o especialista
4. O especialista responde **baseado naquilo**

### Fluxo RAG

```text
Pergunta do usuário
      ↓
Embedding da pergunta
      ↓
Busca no banco vetorial (similaridade)
      ↓
Recupera N chunks relevantes
      ↓
Concatena: (Contexto + Pergunta)
      ↓
LLM gera resposta contextualizada
      ↓
Resposta ao usuário (com fontes, se desejar)
```

### Por que RAG é revolucionário?

- **Reduz alucinações**: modelo responde baseado em documentos fornecidos
- **Atualizável**: adicione novos documentos, não precisa retreinar modelo
- **Auditorável**: você sabe de onde veio cada informação
- **Custo**: usa modelo geral + contexto, não fine-tuning caro

---

## 6.3 Como embeddings funcionam na prática

### O que é um embedding?

É um **vetor numérico** que representa o significado semântico de um texto.

Exemplo:
```python
from sentence_transformers import SentenceTransformer

model = SentenceTransformer('all-MiniLM-L6-v2')

frase1 = "Como funciona o RAG?"
frase2 = "O que é retrieval-augmented generation?"
frase3 = "Receita de bolo de chocolate"

emb1 = model.encode(frase1)
emb2 = model.encode(frase2)
emb3 = model.encode(frase3)

# Similaridade entre emb1 e emb2: ALTA (mesmo significado)
# Similaridade entre emb1 e emb3: BAIXA (tópicos diferentes)
```

### Analogia: mapa semântico

Pense no espaço de embeddings como um mapa onde:
- Frases com significado similar ficam próximas
- Frases diferentes ficam distantes

É como coordenadas GPS do significado.

### Dimensões

- Modelo `text-embedding-3-small`: 1536 dimensões
- Cada embedding é um array de 1536 números
- Distância (cosine similarity) varia de -1 a 1

---

## 6.4 Arquitetura de um sistema RAG

### Componentes

1. **Document Loader** — lê arquivos (PDF, TXT, DOCX)
2. **Text Splitter** — divide em chunks
3. **Embedding Model** — converte chunks em vetores
4. **Vector Store** — armazena e busca vetores
5. **Retriever** — recupera chunks relevantes
6. **LLM** — gera resposta final

### Diagrama completo

```text
[Documentos Originais]
        ↓
[Document Loader] → texto bruto
        ↓
[Text Splitter] → chunks
        ↓
[Embedding Model] → vetores
        ↓
[Vector Store] ← armazenamento
        ↓
[Query] → embedding da pergunta
        ↓
[Retriever] → busca por similaridade
        ↓
[Chunks relevantes] + Pergunta
        ↓
[LLM] → resposta contextualizada
        ↓
[Usuário]
```

---

## 6.5 Extraindo texto de documentos

### Formatos comuns

**PDF:**
```python
from PyPDF2 import PdfReader

def extrair_pdf(caminho):
    reader = PdfReader(caminho)
    texto = ""
    for page in reader.pages:
        texto += page.extract_text()
    return texto
```

**DOCX:**
```python
from docx import Document

def extrair_docx(caminho):
    doc = Document(caminho)
    return "\n".join([para.text for para in doc.paragraphs])
```

**TXT:**
```python
def extrair_txt(caminho):
    with open(caminho, 'r', encoding='utf-8') as f:
        return f.read()
```

### Limpeza

Remove:
- Quebras de linha múltiplas
- Espaços em branco
- Caracteres não-ASCII (se necessário)
- Cabeçalhos/rodapés repetitivos

```python
import re

def limpar_texto(texto):
    texto = re.sub(r'\n+', '\n', texto)  # múltiplas quebras → uma
    texto = re.sub(r'\s+', ' ', texto)   # múltiplos espaços → um
    return texto.strip()
```

---

## 6.6 Chunking: dividindo informação corretamente

### Por que chunk?

- Modelos têm limite de contexto (ex: 128K tokens)
- Documentos longos não cabem
- Busca mais precisa se dividido

### Estratégias de chunking

#### Fixed-size chunking

```python
from langchain_text_splitters import CharacterTextSplitter

splitter = CharacterTextSplitter(
    chunk_size=1000,      # 1000 caracteres
    chunk_overlap=200,    # 200 de sobreposição (evita cortar no meio)
    separator="\n"
)
chunks = splitter.split_text(texto)
```

**Prós:** simples, rápido  
**Contras:** pode cortar no meio de frases, perder contexto semântico

#### Semantic chunking (recomendado)

Usa embeddings para encontrar boundaries naturais.

```python
from langchain_experimental.text_splitter import SemanticChunker
from langchain_openai import OpenAIEmbeddings

embeddings = OpenAIEmbeddings()
splitter = SemanticChunker(embeddings)
chunks = splitter.split_text(texto)
```

**Prós:** respeita unidades de sentido  
**Contras:** mais lento, custa embeddings

#### Recursive chunking

Tenta separadores em ordem: `\n\n` → `\n` → `" "` → `""`

### Tamanho ideal?

- **Embeddings search**: 256–512 tokens (equilíbrio)
- **Contexto para LLM**: 512–1024 tokens por chunk
- **Sobrewriting**: 10–20% do chunk size

**Regra prática:** teste com seu documento. Muitos chunks pequenos → ruído. Poucos chunks grandes → perda de precisão.

---

## 6.7 Gerando embeddings

### OpenAI embeddings

```python
from openai import OpenAI

client = OpenAI()

def gerar_embedding(texto: str) -> list:
    response = client.embeddings.create(
        model="text-embedding-3-small",  # ou 'large'
        input=texto
    )
    return response.data[0].embedding
```

**Modelos:**
- `text-embedding-3-small`: 1536 dims, barato
- `text-embedding-3-large`: 3072 dims, mais caro, melhor qualidade

### Hugging Face (open-source)

```python
from sentence_transformers import SentenceTransformer

model = SentenceTransformer('all-MiniLM-L6-v2')
embedding = model.encode("Texto aqui")
```

**Vantagem:** roda local, sem custo por token  
**Desvantagem:** qualidade pode ser menor que OpenAI

### Batch de embeddings

```python
textos = ["chunk1", "chunk2", "chunk3"]
response = client.embeddings.create(
    model="text-embedding-3-small",
    input=textos  # múltiplos de uma vez
)
embeddings = [d.embedding for d in response.data]
```

---

## 6.8 Bancos vetoriais

### O que é?

Banco de dados otimizado para armazenar e buscar vetores (embeddings) por similaridade.

### Opções

#### Chroma (Recomendado para começar)

```python
import chromadb

client = chromadb.PersistentClient(path="./chroma_db")
collection = client.create_collection(name="docs")

# Adicionar
collection.add(
    documents=["texto chunk 1", "texto chunk 2"],
    embeddings=[[...], [...]],
    ids=["id1", "id2"]
)

# Buscar
results = collection.query(
    query_embeddings=[embedding_pergunta],
    n_results=3
)
```

**Prós:** simples, local, zero config  
**Contras:** não escala para milhões de vetores

#### Pinecone (Cloud)

- Gerenciado, alta escala
- Pago
- Fácil de usar

#### Qdrant

- Open-source, alta performance
- Pode ser local ou cloud (Qdrant Cloud)
- Suporte a múltiplas métricas de distância

#### pgvector (PostgreSQL)

- Extensão do Postgres
- Se já usa Postgres, é uma opção
- Simples, mas menos otimizado que bancos dedicados

### Escolha

| Tamanho | Escolha |
|---------|---------|
| Protótipo, < 10K vetores | Chroma |
| Produção, 10K–1M | Qdrant |
| Alta escala, >1M | Pinecone |
| Já usa Postgres | pgvector |

---

## 6.9 Busca semântica

### Keyword search vs semantic search

**Keyword:** match exato de palavras  
**Semantic:** match por significado

**Exemplo:**
- Pergunta: "como aumentar vendas?"
- Keyword: só acha se tiver "aumentar" e "vendas"
- Semantic: acha "como crescer receita", "como elevar faturamento" (sinônimos)

### Implementação

```python
def buscar_relevantes(pergunta: str, top_k: int = 3):
    # 1. Gera embedding da pergunta
    emb_pergunta = gerar_embedding(pergunta)

    # 2. Busca no banco
    results = collection.query(
        query_embeddings=[emb_pergunta],
        n_results=top_k
    )

    # 3. Retorna textos
    return results['documents'][0]  # lista de strings
```

### Melhorias

- **Re-ranking**: use um modelo para reordenar resultados (cross-encoder)
- **Hybrid search**: combine keyword + semantic
- **Query rewriting**: reescreva a pergunta para melhor busca

---

## 6.10 Construindo o pipeline RAG

### Código completo (mínimo viável)

```python
# rag.py
from openai import OpenAI
import chromadb
from PyPDF2 import PdfReader

client = OpenAI()

# 1. Extrai e processa documento
def processar_documento(caminho):
    if caminho.endswith('.pdf'):
        reader = PdfReader(caminho)
        texto = "".join([p.extract_text() for p in reader.pages])
    # ... outros formatos
    return limpar_texto(texto)

# 2. Chunking
from langchain_text_splitters import RecursiveCharacterTextSplitter
splitter = RecursiveCharacterTextSplitter(chunk_size=500, chunk_overlap=50)
chunks = splitter.split_text(texto)

# 3. Gera embeddings
embeddings = []
for chunk in chunks:
    resp = client.embeddings.create(model="text-embedding-3-small", input=chunk)
    embeddings.append(resp.data[0].embedding)

# 4. Armazena no Chroma
chroma_client = chromadb.PersistentClient(path="./chroma_db")
collection = chroma_client.create_collection(name="docs")
collection.add(
    documents=chunks,
    embeddings=embeddings,
    ids=[f"id{i}" for i in range(len(chunks))]
)

# 5. Função de chat RAG
def responder(pergunta: str):
    # Busca
    emb_pergunta = client.embeddings.create(model="text-embedding-3-small", input=pergunta).data[0].embedding
    results = collection.query(query_embeddings=[emb_pergunta], n_results=3)
    contexto = "\n\n".join(results['documents'][0])

    # Gera resposta
    prompt = f"""
    Use o seguinte contexto para responder.
    Se não souber, diga "Não encontrei nos documentos".

    Contexto:
    {contexto}

    Pergunta: {pergunta}
    """
    resp = client.chat.completions.create(
        model="gpt-4o-mini",
        messages=[{"role": "user", "content": prompt}]
    )
    return resp.choices[0].message.content
```

---

## 6.11 Reduzindo alucinações

### Técnicas

1. **Prompt claro:**
   ```
   Responda APENAS com base no contexto fornecido.
   Se a informação não estiver presente, responda: "Não encontrei essa informação nos documentos."
   ```

2. **Citação de fontes:**
   Peça para o modelo citar de qual chunk veio cada afirmação.

3. **Limitar contexto:**
   Só envie chunks realmente relevantes (top_k baixo, threshold de similaridade)

4. **Fact-checking pós-geração:**
   Valide afirmações contra o contexto original

5. **Threshold de confiança:**
   Se similaridade máxima < 0.7, não responda (ou diga "não tenho certeza")

---

## 6.12 Estratégias avançadas de retrieval

### Re-ranking

Depois da busca vetorial, use um modelo que scoreia melhor a relevância:

```python
from sentence_transformers import CrossEncoder

reranker = CrossEncoder('cross-encoder/ms-marco-MiniLM-L-6-v2')
pares = [(pergunta, doc) for doc in docs_recuperados]
scores = reranker.predict(pares)
# Ordena docs por score
```

### Hybrid search

Combine:
- BM25 (keyword)
- Vetorial (semantic)

Pondere os scores.

### Metadata filtering

Filtre por:
- Tipo de documento (manual, contrato)
- Data
- Departamento
- autor

```python
results = collection.query(
    query_embeddings=[emb],
    where={"tipo": "manual"},
    n_results=5
)
```

### Multi-query retrieval

Gere variações da pergunta e busca todas, depois merge resultados.

---

## 6.13 Custos e performance

### Onde gastamos

1. **Embeddings** — uma vez por documento (custo único)
2. **Busca vetorial** —基本 grátis (local) ou $/GB (cloud)
3. **LLM** — a cada pergunta (input: contexto + query; output: resposta)

### Otimizações

- **Chunk size adequado**: chunks muito grandes → contexto desnecessário, custo alto
- **Top-k controlado**: 3–5 chunks suficientes na maioria dos casos
- **Cache de perguntas frequentes**
- **Compressão de contexto**: sumarizar chunks antes de enviar ao LLM
- **Modelo menor** para embeddings (small vs large)
- **Local vs cloud**: embeddings local economiza se volume alto

### Estimativa de custo (OpenAI)

- Embedding: ~US$ 0.02 por 1000 documentos (1K tokens cada)
- GPT-4o-mini: ~US$ 0.003 por 1K tokens input
  - Exemplo: 5 chunks de 500 tokens + pergunta de 100 = 2600 tokens input
  - Custo por busca: ~US$ 0.008

**MVP com 1000 usuários/mês, 5 perguntas cada:**
- Embeddings: ~US$ 0.50 (único)
- LLM: 5000 perguntas × 2600 tokens = 13M tokens → US$ 39

**Total ~US$ 40/mês** — viável.

---

## Exercícios

### Nível 1 — conceitual

1. Explique com suas palavras por que RAG resolve o problema de alucinação.
2. Qual a diferença entre embeddings e busca por palavras-chave?
3. Por que o tamanho do chunk importa?

### Nível 2 — técnico

1. Extraia texto de um PDF (use PyPDF2 ou pymupdf) e imprima os primeiros 500 caracteres.
2. Gere embeddings para 5 frases e calcule a similaridade entre todas as pairs.
3. Crie uma coleção Chroma, insira 10 chunks de texto, e faça 3 buscas semânticas.

### Nível 3 — desafio

1. Implemente o pipeline RAG completo: upload PDF → chunks → embeddings → Chroma → chat.
2. Adicione re-ranking com CrossEncoder e compare resultados.
3. Monte um dashboard (Streamlit) que mostra: número de documentos, chunks, custo estimado, latência.

---

## Checklist de validação

- [ ] Entendo o problema que RAG resolve
- [ ] Sei extrair texto de PDF/DOCX
- [ ] Sei fazer chunking apropriado (tamanho, overlap)
- [ ] Gero embeddings corretamente (OpenAI ou HF)
- [ ] Criei e queryei banco vetorial (Chroma)
- [ ] Implementei pipeline completo (upload → resposta)
- [ ] Aplico técnicas para reduzir alucinações
- [ ] Consigo estimar custo operacional
- [ ] Testei estratégias avançadas (re-ranking, hybrid)
- [ ] Fiz deploy da aplicação RAG

---

## Fontes consultadas

- **Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks** — Lewis et al., 2020 (paper original)
- **LangChain RAG Tutorial** — https://python.langchain.com/docs/tutorials/rag/
- **Chroma Documentation** — https://docs.trychroma.com
- **OpenAI Embeddings Guide** — https://platform.openai.com/docs/guides/embeddings
- **Sentence Transformers** — https://www.sbert.net/
- **Advanced RAG** — https://blogs.llamaindex.ai/advanced-retrieval-6c41b9afcb92
- **Qdrant Documentation** — https://qdrant.tech/documentation/

---

## Próximo capítulo

No Capítulo 7, vamos beyond RAG: **Desenvolvimento de Produtos com IA** — validação, MVP, arquitetura, deploy, testes.
