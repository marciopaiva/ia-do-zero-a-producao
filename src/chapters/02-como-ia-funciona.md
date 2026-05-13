# Capítulo 2 — Como a Inteligência Artificial Realmente Funciona

## Objetivo do capítulo

Explicar os fundamentos reais da IA moderna de forma acessível, mostrando o que acontece "por trás da mágica". Este capítulo elimina mitos, reduz hype e cria uma base sólida para entender LLMs, RAG, agentes e produção.

A ideia central:

> Você não precisa virar cientista de dados, mas precisa entender a mecânica básica.

---

## 2.1 A IA não "pensa" como humanos

### O maior equívoco

Quando vemos um modelo escrever um texto fluente ou gerar uma imagem realista, a impressão é que ele "entende" ou "pensa". Isso é uma ilusão.

**Modelos de IA não possuem:**
- Consciência
- Intenção
- Compreensão semântica real
- Conhecimento factual garantido

Eles fazem algo muito mais simples (e poderoso): **prevêem a sequência mais provável de símbolos** (palavras, pixels, etc.) com base em padrões estatísticos aprendidos de trilhões de exemplos.

### Analogia: autocompletion superavançado

Pense em seu teclado de smartphone que sugere a próxima palavra. Agora imagine um sistema que:

- Foi treinado em quase toda a internet
- Conhece relações entre conceitos
- Pode adaptar o estilo
- Gera múltiplas variações coerentes

É isso que um LLM faz. Ele não "raciocina" — ele **completa**.

### Implicação prática

Como a IA não entende significado, ela pode:
- Gerar texto muito plausível, mas factualmente errado (alucinação)
- Ser inconsistente em respostas seguidas
- "Inventar" citations, URLs, leis
- Parafrasear sem capturar nuances

**Para você:** sempre valide o que a IA produz, especialmente em dados factuais.

---

## 2.2 O que são modelos de linguagem

### Definição simples

Um **modelo de linguagem** é uma função estatística que, dada uma sequência de texto, calcula a probabilidade do próximo token.

Matematicamente:  
P(next_token | previous_tokens)

### Como eles são criados

1. **Coleta de dados**: livros, artigos, wikis, código, fóruns — petabytes de texto
2. **Treinamento**: a rede neural ajusta bilhões de parâmetros para prever a próxima palavra
3. **Avaliação**: testes de qualidade, safety, bias

Durante o treinamento, o modelo **não vê respostas**. Ele só vê dados brutos e aprende sozinho a identificar padrões.

### O que o modelo realmente faz

- **Compressão de conhecimento**: armazena estatísticas de co-ocorrência de palavras
- **Generalização**: aplica padrões vistos a situações novas
- **Interpolação**: combina ideias de contextos diferentes

**Exemplo:** o modelo aprende que "capital do Brasil" frequentemente aparece com "Brasília". Ele não sabe o que é Brasil ou capital — apenas que a sequência de tokens "Brasília" segue "capital do Brasil" com alta probabilidade.

---

## 2.3 Tokens: a unidade básica da IA

### O que é um token?

Token é a menor unidade que o modelo processa. Pode ser:
- Uma palavra inteira (comum em português)
- Parte de uma palavra (subpalavras)
- Um caractere (em alguns modelos)

Exemplo em português (modelo BPE):

| Texto | Tokens |
|-------|--------|
| "IA" | ["IA"] (1 token) |
| "Inteligência Artificial" | ["Inteligência", " Artificial"] (2 tokens) |
| "São Paulo" | ["São", " Paulo"] (2 tokens) |
| Código: `def soma(a, b):` | ["def", " soma", "(", "a", ",", "b", "):"] (7 tokens) |

### Por que tokens importam?

1. **Custo**: APIs cobram por token (ex: US$ 0.01 por 1K tokens de entrada, US$ 0.03 por 1K tokens de saída — GPT-4)
2. **Contexto**: limites de contexto são medidos em tokens (ex: GPT-4 tem 128K tokens)
3. **Performance**: mais tokens = mais lentidão e custo

### Calcule seus tokens

```python
from transformers import AutoTokenizer

tokenizer = AutoTokenizer.from_pretrained("gpt2")
texto = "Inteligência Artificial é o futuro."
tokens = tokenizer.encode(texto)
print(f"Texto: '{texto}'")
print(f"Tokens: {len(tokens)} → {tokens}")
print(f"Decodificado: {tokenizer.decode(tokens)}")
```

**Resultado aproximado:** 7 tokens.

**Dica prática:** 1000 tokens ≈ 750 palavras em português.

---

## 2.4 Como modelos aprendem padrões

### Treinamento: ajuste de billions de parâmetros

1. **Inicialização aleatória** — o modelo começa com pesos aleatórios
2. **Forward pass** — processa um batch de texto, gera previsões
3. **Cálculo de loss** — compara previsão com o que realmente veio a seguir
4. **Backward pass** — ajusta pesos para reduzir erro (gradiente descendente)
3. **Repete** — por trilhões de tokens

O resultado: uma grande tabela de números (os parâmetros) que codifica estatísticas da linguagem.

### O que é aprendido?

O modelo adquire "conhecimento" distribuído pela rede:
- Camadas iniciais: padrões locais (gramática, morfologia)
- Camadas médias: sintaxe, entidades
- Camadas finais: semântica, raciocínio

### Fine-tuning: adaptando o modelo

Após o pré-treinamento geral, podemos **sintonizar** o modelo para uma tarefa específica:

```python
from transformers import AutoModelForCausalLM, AutoTokenizer, TrainingArguments, Trainer

model_name = "gpt2"
model = AutoModelForCausalLM.from_pretrained(model_name)
tokenizer = AutoTokenizer.from_pretrained(model_name)

# Você fornece exemplos específicos (ex: e-mails profissionais)
# O treinamento ajusta levemente os pesos
# Resultado: modelo especializado, sem perder conhecimento geral
```

**Fine-tuning vs prompting:**
- Prompting: você guia o modelo a cada interação (flexível, não custa treinar)
- Fine-tuning: você altera o modelo permanentemente (caro, mas consistente)

---

## 2.5 O que são embeddings

### Definição

**Embeddings** são representações numéricas (vetores) que capturam o significado de um texto.

Palavras ou frases semanticamente similares ficam próximas no espaço vetorial.

### Analogia: mapa semântico

Imagine um mapa onde:
- "cachorro" e "gato" estão próximos (animais domésticos)
- "carro" e "moto" estão próximos (veículos)
- "carro" está longe de "banana"

Esse mapa é criado automaticamente pelo modelo.

### Como funcionam na prática

```python
from sentence_transformers import SentenceTransformer

model = SentenceTransformer('all-MiniLM-L6-v2')

frases = [
    "O gato está na casa",
    "O felino está no lar",
    "O carro está na garagem"
]

embeddings = model.encode(frases)

# Similaridade entre frases
from sklearn.metrics.pairwise import cosine_similarity
import numpy as np

sim_12 = cosine_similarity([embeddings[0]], [embeddings[1]])[0][0]
sim_13 = cosine_similarity([embeddings[0]], [embeddings[2]])[0][0]

print(f"Similaridade 'gato' vs 'felino': {sim_12:.3f}")   # Alta (ex: 0.85)
print(f"Similaridade 'gato' vs 'carro': {sim_13:.3f}")    # Baixa (ex: 0.15)
```

**Aplicações de embeddings:**
- Busca semântica (não só palavras-chave)
- Agrupamento (clustering) de documentos
- Recomendação de conteúdo similar
- Memória de agentes (RAG)

---

## 2.6 Contexto e memória

### Janela de contexto

É o número de tokens que o modelo "vê" de uma vez. Por exemplo, GPT-4: 128.000 tokens (~300 páginas).

**Regra:** dentro da janela, o modelo pode referenciar qualquer coisa.

**Problema:** quando a conversa ou documento excede o limite, o início é truncado (jogado fora).

### Tipos de memória

1. **Memória de curto prazo (contexto)** — o que está na janela atual
2. **Memória de longo prazo (banco vetorial)** — informações armazenadas externamente, recuperadas por similaridade
3. **Memória de sessão** — variáveis do código que persistem entre chamadas

### Contexto vs. armazenamento

O modelo **não lembra** de conversas passadas se saírem da janela. Para manter memória persistente, você precisa:
- Armazenar embeddings de interações
- Recuperar relevantes a cada nova pergunta (RAG)
- Injetar no prompt atual

---

## 2.7 Por que IA alucina

### O mecanismo

O modelo gera a resposta mais provável dado o contexto. Se o contexto não contém informação verdadeira, ele **inventa** algo que soa plausível.

**Exemplos reais:**
- ChatGPT cita casos judiciais inexistentes
- Claude inventa APIs que não existem
- Bard atribui citações falsas

### Por que acontece?

1. **Treinamento em dados com erros** — a internet tem desinformação
2. **Pressão para ser útil** — se não souber, preference gerar algo em vez de dizer "não sei"
3. **Falta de grounding** — sem fontes verificáveis, o modelo preenche lacunas

### Como mitigar

- **RAG**: conecte o modelo a fontes confiáveis antes da geração
- **Fact-checking automático**: valide afirmações contra conhecimento externo
- **Prompting explícito**: "Se não souber, diga 'Não sei'"
- **Human-in-the-loop**: revisão de outputs críticos

---

## 2.8 Temperatura, criatividade e precisão

### O parâmetro temperatura

Controla aleatoriedade da geração:

| Temperatura | Comportamento | Use quando |
|-------------|---------------|------------|
| 0.0–0.3 | Determinístico, repetitivo | Código, fatos, Q&A |
| 0.4–0.7 | Balanceado | Textos gerais, e-mails |
| 0.8–1.2 | Criativo, variado | Brainstorming, histórias |

**Exemplo:**
```python
import openai

response = openai.ChatCompletion.create(
    model="gpt-4",
    messages=[{"role": "user", "content": "Escreva um slogan para café"}],
    temperature=0.9  # Mais criativo
)
```

### Outros parâmetros

- **top_p**: controle de diversidade via núcleo de probabilidade
- **max_tokens**: limite de comprimento da resposta
- **stop**: sequências que encerram geração

---

## 2.9 Custos computacionais da IA

### De onde vêm os custos

1. **Treinamento** — bilhões em GPUs por semanas (ex: GPT-4: ~US$ 100 milhões)
2. **Inferência** — cada chamada gasta computação
3. **Armazenamento** — embeddings, indexes, modelos (GBs–TBs)

### Cálculo prático

Para um chatbot com 1000 usuários/dia, média de 10 interações, 1000 tokens cada:

- Tokens de entrada: 1000 × 10 × 1000 = 10M
- Tokens de saída: 1000 × 10 × 500 = 5M
- Custo (GPT-4): (10M/1K × US$ 0.03) + (5M/1K × US$ 0.06) = US$ 300 + US$ 300 = **US$ 600/mês**

Cenário com 100.000 usuários: **US$ 60.000/mês**.

### Estratégias de redução

- Cache de respostas frequentes
- Modelos menores para tarefas simples
- Batches de requisições
- Compressão de contexto
- Escolha certa: GPT-4 para coisa difícil, modelo leve para coisa simples

---

## 2.10 O ciclo completo de uma requisição

### Fluxo simplificado

```text
Usuário prompt
    ↓
Tokenização (texto → IDs numéricos)
    ↓
Embedding lookup (cada token vira vetor)
    ↓
Passagem pelo Transformer (camadas de atenção)
    ↓
Geração autoregressiva (um token de cada vez)
    ↓
Detokenização (IDs → texto)
    ↓
Resposta ao usuário
```

### Fluxo moderno com RAG

```text
Usuário pergunta
    ↓
Embedding da pergunta
    ↓
Busca em banco vetorial (similaridade)
    ↓
Recuperação de documentos relevantes
    ↓
Construção do prompt: (contexto + pergunta)
    ↓
Modelo de linguagem gera resposta
    ↓
Pós-processamento (formatação, validação)
    ↓
Resposta final
```

**Cada etapa tem custo e latência.**

---

## 2.11 Limitações reais da IA atual

### O que a IA não faz bem

- **Raciocínio matemático complexo** — pode errar contas simples
- **Conhecimento factual atualizado** — cutoff de treinamento (ex: GPT-4 até 2023)
- **Consistência longa** — esquece Details depois de muitas interações
- **Entendimento de irony/sarcasmo**
- **Cálculos precisos**
- **Planejamento de longo prazo**

### Segurança e riscos

- **Prompt injection** — usuário engana o sistema
- **Data leakage** — vazamento de informações sensíveis
- **Bias amplification** — amplificação de vieses sociais
- **Dependência excessiva** — humanos deixam de validar

### A regra de ouro

> IA é uma ferramenta, não uma solução autônoma.

Use para:
- Aumentar produtividade
- Gerar ideias
- Automatizar tarefas repetitivas

Não use para:
- Decisões críticas sem supervisão
- Informações factuais sem verificação
- Substituir julgamento humano

---

## Exercícios: solidifique o entendimento

### Nível 1 — conceitual

1. Explique com suas palavras por que a IA não "pensa" como humanos.
2. Qual a diferença entre tokens e palavras? Dê um exemplo onde uma frase vira mais tokens que palavras.
3. Por que embeddings são úteis para busca semântica?

### Nível 2 — técnico

1. No Colab, use a biblioteca `transformers` para tokenizar um texto em português e conte os tokens.
2. Gere embeddings para 5 frases sobre IA e calcule a matriz de similaridade. Qual par é mais similar?
3. Experimente o mesmo prompt com temperatura 0.0 e 1.0. Compare a criatividade e consistência.

### Nível 3 — desafio

1. Construa um sistema simples de busca semântica: dado um índice de documentos, recupere os mais relevantes para uma query usando embeddings.
2. Implemente um detector de alucinação: dê um fato ao modelo, peça para gerar texto, e valide contra uma fonte confiável.
3. Estime o custo mensal de um produto com N usuários, média de M interações, cada uma com P tokens de entrada e S tokens de saída. Crie uma calculadora.

---

## Checklist de validação

- [ ] Entendo que IA não pensa, apenas prevê padrões
- [ ] Sei o que são tokens e como afetam custo/performance
- [ ] Compreendo o conceito de embeddings e suas aplicações
- [ ] Entendo o fluxo de uma requisição LLM
- [ ] Sei explicar por que a IA alucina e como mitigar
- [ ] Conheço os parâmetros que controlam geração (temperatura, top_p)
- [ ] Consigo estimar o custo operacional de um sistema de IA
- [ ] Identifiquei as limitações reais da IA atual

---

## Fontes consultadas

- **Attention Is All You Need** — Vaswani et al., 2017 (arquitetura Transformer)
- **Language Models are Few-Shot Learners** — Brown et al., 2020 (GPT-3)
- **Embeddings from Language Models** — Pennington et al., 2014 (GloVe)
- **OpenAI Cookbook** — https://cookbook.openai.com (cálculo de tokens, custos)
- **Hugging Face Course** — https://huggingface.co/course (transformers, embeddings)
- **Stanford CS224N** — Natural Language Processing with Deep Learning
