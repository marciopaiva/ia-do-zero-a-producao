# Capítulo 3 — O Ecossistema Moderno da Inteligência Artificial

## Objetivo do capítulo

Apresentar as principais categorias de ferramentas, modelos e infraestruturas que compõem o ecossistema moderno de IA. O foco não é ensinar uma ferramenta específica, mas sim:

- Como o ecossistema funciona
- Quais peças existen
- Como elas se conectam
- Quando usar cada uma

Este capítulo prepara você para enxergar IA como uma stack tecnológica, não como uma "caixa preta mágica".

---

## 3.1 O novo stack da IA

### A arquitetura de uma aplicação moderna

Uma aplicação de IA não é apenas "uma chamada à API do ChatGPT". Ela tem camadas:

```text
Frontend (Web, Mobile, CLI)
        ↓
Backend/API (FastAPI, Flask)
        ↓
Orquestração (LangChain, LlamaIndex)
        ↓
Modelo (OpenAI, Anthropic, Llama local)
        ↓
Memória (RAG, banco vetorial)
        ↓
Cache (Redis, Memcached)
        ↓
Observabilidade (logs, tracing, custos)
```

Cada camada tem opções, trade-offs e custos.

### O erro comum

Iniciantes focam apenas no modelo ("qual LLM usar?") e esquecem do resto. O resultado: aplicação que funciona, mas não escala, não é monitorável, custa fortunas.

**Mensagem:** IA é engenharia de sistemas, não só chamada de API.

---

## 3.2 Modelos proprietários vs. open source

### Proprietários (Closed)

**Exemplos:** GPT-4 (OpenAI), Claude (Anthropic), Gemini (Google)

**Vantagens:**
- Qualidade leadership (state-of-the-art)
- Suporte oficial
- Infraestrutura gerenciada
- Segurança e compliance embutidos

**Desvantagens:**
- Custo por token (pode explodir em escala)
- Vendor lock-in
- Dados saem da sua infra
- Limitações de contexto/customização

**Quando usar:**
- Prototipagem rápida
- Tarefas que exigem máxima qualidade
- Sem tempo/infra para gerenciar modelos

---

### Open source

**Exemplos:** Llama 2/3 (Meta), Mistral, DeepSeek, Qwen, Phi

**Vantagens:**
- Controle total (rode local, on-prem)
- Privacidade (dados não saem)
- Customização (fine-tuning, quantization)
- Custo previsível (apenas infra)

**Desvantagens:**
- Requer infraestrutura (GPU, RAM)
- Manutenção é sua
- Pode exigir tuning para performance
- Qualidade depende da versão

**When usar:**
- Dados sensíveis (não podem sair)
- Volume alto (custo de API proibitivo)
- Customização necessária (domínio específico)
- Quer evitar vendor lock-in

---

## 3.3 APIs de IA

### O que é uma API de IA?

É um endpoint HTTP que recebe um prompt e retorna uma resposta.

Exemplo简化:
```python
import openai

client = openai.OpenAI(api_key="...")
response = client.chat.completions.create(
    model="gpt-4",
    messages=[{"role": "user", "content": "Olá"}]
)
print(response.choices[0].message.content)
```

### Elementos de uma API de LLM

- **Authentication**: API keys (geralmente Bearer token)
- **Model selection**: qual modelo usar (gpt-4, claude-3, etc.)
- **Parameters**:
  - `temperature` (0-2) — criatividade
  - `max_tokens` — limite de resposta
  - `top_p` — diversidade
  - `stop` — sequências de parada
- **Streaming**: respostas parciais (token a token)
- **Rate limits**: requests por minuto
- **Pricing**: input/output tokens (diferentes preços)

### Boas práticas

- **Retry logic**: APIs falham; implemente exponential backoff
- **Timeout**: defina limites (ex: 30s)
- **Circuit breaker**: evite cascate failures
- **Cache**: respostas idênticas podem ser cacheadas
- **Batching**: junte múltiplas requisições quando possível

---

## 3.4 Modelos multimodais

### O que são?

Modelos que entendem e geram múltiplos tipos de mídia:

- **Texto** → Input e output
- **Imagem** → Input (visão) e/ou output (geração)
- **Áudio** → Speech-to-text, text-to-speech
- **Vídeo** → Análise e geração (emergente)

### Aplicações

- **OCR + LLM**: extrair texto de PDF e processar
- **Visão + linguagem**: descrever imagens, responder perguntas sobre figuras
- **Áudio**: transcrição de reuniões, assistentes de voz
- **Multimodal generation**: criar slides com texto + imagens

**Exemplo:** GPT-4V analisa uma foto de geladeira e sugere receitas.

---

## 3.5 Ferramentas de desenvolvimento com IA

### Assistentes de código

- **GitHub Copilot**: autocomplete no VS Code
- **Cursor**: editor baseado em IA, chat integrado
- **Claude Code**: CLI para tarefas complexas

** produtividade:** ganho de 30-50% em código boilerplate.

### IDEs AI-native

- **Cursor** (já mencionado)
- **Windsurf**: foco em agentes
- **Replit AI**: ambiente completo na nuvem

### Automação e No-code

- **Zapier AI**: conecta apps com IA
- **n8n**: automação workflows com nodes de IA
- **Make (Integromat)**: visual automation

### Prototipagem rápida

- **V0** (Vercel): gera UI a partir de descrição
- **Bolt**: constrói apps inteiros com prompt
- **Lovable**: similar

**Cuidado:** ferramentas são meios, não fim. Entenda o que está sendo gerado.

---

## 3.6 Bancos vetoriais

### O que são?

Banco de dados especializado em armazenar e buscar **vetores** (embeddings).

```text
Embedding (vetor) → Armazenado em banco vetorial
Query (vetor)      → Busca por similaridade (cosine, Euclidean)
```

### Por que importam?

Permitem **busca semântica**: você busca por significado, não por palavra-chave.

**Exemplo:**  
Query: "como aumentar vendas?"  
Documento: " estratégias para crescer receita" → match mesmo sem palavras idênticas.

### Opções

| Ferramenta | Open-source | Cloud | Observações |
|------------|-------------|-------|-------------|
| **Chroma** | ✅ | ❌ | Leve, local, ideal para prototyping |
| **Pinecone** | ❌ | ✅ | Gerenciado, alta escala |
| **Weaviate** | ✅ | ✅ | Híbrido (objetos + vetores) |
| **Qdrant** | ✅ | ✅ | Alta performance |
| **pgvector** | ✅ | ❌ | Extensão PostgreSQL (simples) |

### Escolha

- **Prototipagem**: Chroma (local, zero config)
- **Produção pequena/média**: pgvector (se já usa Postgres)
- **Alta escala**: Pinecone ou Qdrant cloud

---

## 3.7 Frameworks de IA

### O problema que resolvem

Orquestrar componentes: LLM, embeddings, tools, memory, chains.

### Principais

**LangChain** — mais popular, ampla comunidade
- Chains, agents, tools
- Integração com centenas de fontes
- Cuidado: abstrai muito, pode gerar código ineficiente

**LlamaIndex** — focado em RAG
- Indexação de dados
- Retrieval avançado
- Query engines

**Semantic Kernel** (Microsoft) — .NET/C#
**CrewAI** — agentes multi-agente
**AutoGen** (Microsoft) — conversação multi-agent

### When to use (and when not)

✅ **Use** se:
- Precisa de RAG
- Precisa de agentes com ferramentas
- Quer acelerar desenvolvimento

❌ **Não use** se:
- A lógica é simples (chamada direta à API basta)
- Quer controle total (frameworks escondem detalhes)
- Performance é crítica (overhead)

**Princípio:** framework é degrau, não muleta. Entenda o que acontece por baixo.

---

## 3.8 Plataformas de deploy e inferência

### Hosting de modelos

**Cloud gerenciada:**
- **OpenAI API** — mais fácil
- **Anthropic** — Claude via API
- **Google Vertex AI** — hospeda modelos próprios
- **AWS Bedrock** — múltiplos modelos em uma API

**Auto-hosting:**
- **Ollama** — rodar localmente (Mac/Linux)
- **vLLM** — alta throughput, high-performance
- **TGI** (Text Generation Inference) — Hugging Face
- **Modal** — platform for running any code (including LLMs)
- **RunPod** — aluga GPUs por hora

### Considerações

- **Latência**: local < cloud (mas cloud escala melhor)
- **Custo**: fixo (local) vs. variável (API)
- **Escalabilidade**: cloud auto-scale; local tem limite físico
- **Segurança**: local = dados nunca saem

---

## 3.9 Observabilidade e monitoramento

### O que monitorar em IA?

1. **Performance**
   - Latência (time to first token, total)
   - Throughput (requests/s)
   - Error rate

2. **Custo**
   - Tokens processados (input/output)
   - Custo por request
   - Tendência de custo

3. **Qualidade**
   - Avaliação humana (rating)
   - Métricas automáticas (BLEU, ROUGE, judge LLM)
   - Hallucination rate

4. **Uso**
   - Queries mais frequentes
   - Tokens por conversa
   - Modelos mais usados

### Ferramentas

- **Langfuse** — open-source, ótimo para RAG
- **Helicone** — proxy com analytics
- **Weights & Biases** (W&B) — MLOps completo
- **Prometheus + Grafana** — custom
- **OpenTelemetry** — padrão aberto

**Regra de ouro:** cole Telemetry desde o primeiro dia. Depois é difícil adicionar.

---

## 3.10 Custos e trade-offs

### Onde gastamos

| Item | Custo (aprox) | Impacto |
|------|---------------|---------|
| API LLM (input) | $0.001–0.03 / 1K tokens | Alto (volume) |
| API LLM (output) | $0.002–0.06 / 1K tokens | Alto |
| Embeddings | $0.0001–0.001 / 1K | Médio (indexação) |
| Banco vetorial | $0.10–1.00 / GB/mês | Baixo-médio |
| Infra (GPU) | $0.50–5.00 / hora | Alto (se 24/7) |

### Exemplo real: chatbot com 10.000 usuários/mês

- Média: 8 interações cada = 80K interações/mês
- Tokens médios: 500 entrada + 300 saída = 800 tokens/interação
- Total tokens: 80K × 800 = 64M tokens
- Custo com GPT-4 (input $0.03, output $0.06):  
  (64M × 0.6) / 1000 = US$ 384/mês (se 60% entrada, 40% saída)

Cenário com 1M usuários: ~US$ 38.000/mês.

### Trade-offs

| Decisão | Custo | Complexidade | Escala |
|---------|-------|--------------|--------|
| API externa | Baixo inicial, varíavel | Baixa | Média |
| Open source local | Médio (GPU) | Alta | Ilimitada |
| Fine-tuning | Alto (train) | Alta | Alta |
| RAG vs. puro LLM | + custo de DB/embed | +complexidade | Melhor qualidade |

**Estratégia:** comece com API (simples), migre para open-source quando volume justificar.

---

## 3.11 Como escolher sua stack

### Stack simples (iniciante, MVP)

```text
Frontend: Next.js (ou HTML simples)
Backend: FastAPI
LLM: OpenAI GPT-3.5/GPT-4
Vector DB: Chroma (local) ou Pinecone (cloud)
Deploy: Railway/Render
Obs: Langfuse (grátis)
```

Custo inicial: ~US$ 50–200/mês até 10K usuários.

---

### Stack RAG (produto com conhecimento próprio)

```text
LLM: Claude 3 Sonnet (ou GPT-4)
Embeddings: OpenAI text-embedding-3
Vector DB: Weaviate ou pgvector
Observabilidade: Langfuse
Cache: Redis
Deploy: AWS/GCP/Azure
```

Ideal: documentação, suporte, base de conhecimento.

---

### Stack Enterprise (alta escala, segurança)

```text
Gateway: Kong/Traefik com rate limiting
   ↓
RAG pipeline: múltiplos retrievers
   ↓
LLM routing: escolhe modelo por complexidade
   ↓
Fallbacks: modelo fallback se primary falhar
   ↓
Observabilidade: WANDB + Sentry + custom metrics
   ↓
Cache: Redis + CDN
   ↓
Segurança: PII detection, moderation layer
```

---

### Stack on-prem (dados sensíveis)

```text
Models: Llama 3 70B quantizado (GGUF)
Inference: vLLM ou Ollama
Hardware: 2x A100 80GB ou equivalent
Embeddings: sentence-transformers local
Vector DB: Qdrant self-hosted
Obs: OpenTelemetry + Prometheus
```

Custo fixo alto, mas dados nunca saem.

---

## Exercícios

### Nível 1 — conceitual

1. Desenhe o stack de uma aplicação de IA que você usaria para um chatbot de suporte.
2. Explique a diferença entre API de LLM e rodar modelo local.
3. Quando vale a pena usar banco vetorial?

### Nível 2 — técnico

1. Crie uma conta na OpenAI, gere uma API key, e faça uma chamada simples (completion).
2. Instale Chroma, crie uma coleção, insira 5 embeddings (use `sentence-transformers`), faça uma busca.
3. Compare latency de GPT-3.5 vs GPT-4 na mesma tarefa.

### Nível 3 — desafio

1. Arquitetura: desenhe diagrama de uma aplicação RAG completa (components, fluxo).
2. Benchmark: teste 3 modelos diferentes (ex: GPT-4, Claude, Llama local) em 10 prompts, compare qualidade/custo.
3. Seleção: baseado em requisitos (custo, latência, privacidade), escolha stack para: (a) startup early, (b) empresa financeira, (c) governo.

---

## Checklist de validação

- [ ] Entendo as camadas de uma aplicação de IA moderna
- [ ] Sei diferenciar modelos proprietários e open-source
- [ ] Consumo APIs de LLM com parâmetros corretos
- [ ] Entendo quando usar banco vetorial
- [ ] Conheço frameworks (LangChain, LlamaIndex) e quando usá-los
- [ ] Sei opções de deploy (cloud vs local)
- [ ] Implementei observabilidade básica (logging, custo)
- [ ] Escolhi uma stack adequada para um caso de uso real

---

## Fontes consultadas

- **OpenAI API Documentation** — https://platform.openai.com/docs
- **Anthropic Claude Documentation** — https://docs.anthropic.com
- **LangChain Documentation** — https://python.langchain.com
- **LlamaIndex** — https://docs.llamaindex.ai
- **Chroma Documentation** — https://docs.trychroma.com
- **vLLM: Easy, Fast and Cost-Effective LLM Serving** — https://github.com/vllm-project/vllm
- **Ollama** — https://ollama.ai
- **Pinecone Documentation** — https://docs.pinecone.io
