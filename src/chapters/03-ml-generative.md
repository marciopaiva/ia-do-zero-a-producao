# Capítulo 3: Aprendizado de máquina vs. IA generativa

## Objetivo do capítulo

Quando você tem um problema, como saber se deve usar机器学习 tradicional ou IA generativa? Este capítulo dá critérios práticos para escolher, mostrando trade-offs de custo, controle e qualidade com exemplos reais.

---

## Dois paradigmas, duas finalidades

### Uma analogia: ferramenta de precisão vs. pincel inteligente

Imagine que você precisa fazer um corte exato em uma peça de madeira. Você usa uma **serra de precisão** — sabe exatamente onde vai cortar, repete o mesmo movimento, o resultado é previsível.

Agora imagine que você quer pintar um quadro. Você dá ao artista a ideia "pinte um pôr do sol na praia". O resultado será criativo, cada vez ligeiramente diferente, e pode até surpreender você.

- **Machine learning tradicional** é a serra de precisão: você controla, o resultado é determinístico, ótimo para classificação e previsão.
- **IA generativa** é o pincel inteligente: você dá uma direção, o modelo cria algo novo.

### Diferenças fundamentais

| Aspecto | Machine Learning tradicional | IA generativa |
|---------|-----------------------------|---------------|
| **Objetivo** | Prever uma classe ou valor numérico | Criar conteúdo novo (texto, imagem, código) |
| **Tarefa típica** | "Esse e-mail é spam?" "Qual o preço desta casa?" | "Escreva um artigo sobre X", "Gere uma imagem de Y" |
| **Dados necessários** | Dataset rotulado (ex: e-mails com marcação spam/não-spam) | Textos/imagens massivos, não necessariamente rotulados |
| **Tamanho do modelo** | Pequeno–médio (milhões de parâmetros) | Enorme (bilhões de parâmetros) |
| **Velocidade de inferência** | Milissegundos | Centenas de ms a segundos |
| **Explicabilidade** | Relativamente alta (árvores de decisão são interpretáveis) | Baixa (caixa preta) |
| **Custo por chamada** | Baixo (modelos podem rodar local) | Alto (API por token ou GPU local cara) |
| **Criatividade** | Baixa — faz o que foi treinado para fazer | Alta — combina ideias de formas novas |

---

## Quando usar cada abordagem: critérios para decisão

### Machine learning tradicional é a escolha quando:

1. **Você tem dados estruturados e rotulados**. Ex: histórico de vendas com features (cliente, produto, data, valor) e label "comprou/não comprou".
2. **A decisão requer alta precisão e consistência**. Ex: aprovação automática de crédito, diagnóstico médico auxiliar.
3. **A saída precisa ser regulada e auditada**. Lei 13.709/2018 (LGPD) exige explicabilidade para decisões automatizadas que afetam pessoas.
4. **O volume de inferências é enorme** (milhões/dia) e custo por predição deve ser baixo.
5. **Você precisa de controle fino** sobre features e thresholds.

**Exemplos reais brasileiros:**
- **Banco do Brasil**: sistema de scoring de crédito (modelos como XGBoost)
- **Nubank**: detecção de fraudes em transações em tempo real
- **Magazine Luiza**: recomendação de produtos baseada em histórico (até 2022, antes de LLMs)
- **ClearSale**: detecção de chargeback

### IA generativa é a escolha quando:

1. **A tarefa é aberta e criativa**. Ex: escrever conteúdos, gerar ideias, criar imagens.
2. **Você não tem dados estruturados rotulados**. LLMs aprendem de dados massivos da internet.
3. **A velocidade de desenvolvimento é crítica**. Com uma API, você tem um assistente de escrita em uma hora.
4. **O problema envolve dados não estruturados**. PDFs, e-mails, gravações de voz — a IA generativa entende naturalmente.
5. **A variação é desejada**. Você quer múltiplas versões de um texto, não uma resposta fixa.

**Exemplos reais:**
- **Chatbots de atendimento** (TodaEstrutura, Submarino)
- **Geração de e-mail marketing** (várias versões para A/B test)
- **Sumarização de documentos jurídicos**
- **Criação de conteúdo para redes sociais**

---

## O híbrido: RAG (Retrieval-Augmented Generation)

O melhor dos dois mundos: use ML tradicional para buscar informações relevantes e IA generativa para compor respostas contextualizadas.

**Exemplo**: Assistente de documentação técnica

1. **Retriever** (ML tradicional): busca trechos relevantes em uma base de conhecimento (vetorial similarity search, BM25).
2. **Generator** (LLM): lê os trechos e escreve uma resposta natural em português.

Vantagens:
- Respostas baseadas em fontes (reduz alucinação)
- Atualizável: adicione novos documentos sem retreinar o modelo
- Custo controlado: retrieve é barato, geração é usada apenas no necessário

---

## Tomada de decisão: fluxo prático

Pergunte-se nesta ordem:

1. **O problema é bem definido e estruturado?**
   - Sim → considere ML tradicional
   - Não (texto livre, imagens, ideias) → considere IA generativa

2. **Você tem dados rotulados de qualidade?**
   - Sim → ML tradicional provavelmente funciona bem
   - Não → IA generativa (ou colete/rotule dados primeiro)

3. **A decisão exige explicabilidade?**
   - Sim → ML tradicional (árvores, regressão) é mais transparente
   - Não → IA generativa pode ser aceitável

4. **Qual o volume de uso?**
   - Milhões de requisições/dia → custo de API LLM pode ser proibitivo; considere modelo local
   - Baixo-médio volume → APIs são práticas

5. **A criatividade é valor?**
   - Sim (conteúdo original) → IA generativa
   - Não (previsão numérica) → ML tradicional

---

## Para gestores: trade-offs financeiros e operacionais

### Custo total de propriedade (TCO)

**ML tradicional:**
- Custo inicial: desenvolvimento + engenharia de features (alto)
- Custo operacional: infra para inference (baixo, pode usar CPU)
- Manutenção: retreinamento periódico (moderado)

**IA generativa (API):**
- Custo inicial: desenvolvimento baixo (apenas integration)
- Custo operacional: por token (pode ser alto em escala)
- Manutenção: monitoramento de qualidade, guardrails

**Exemplo comparativo:**
- Classificador de 1M predições/mês com ML local: R$ 200/mês (servidor)
- LLM para 1M tokens (integrações curtas): R$ 20-40/mês (OpenAI)
- LLM para geração de conteúdo longo: R$ 500+/mês

### Riscos específicos

**ML tradicional:**
- Data drift: distribuição dos dados muda, modelo degenera
- Conceito drift: o fenômeno em si muda (ex: comportamento de compra muda)
- Viés: aprendido dos dados, requer auditoria

**IA generativa:**
- Alucinações: fatos incorretos com confiança alta
- Prompt injection: ataques que fazem o modelo ignorar instruções
- Custo variável: uso imprevisível pode explodir fatura
- Dependência de fornecedor: lock-in de API

### Estratégia de adoção

Para empresas:

1. **Piloto com ML tradicional** em problema de baixo risco — valida processo, dados, governança.
2. **Piloto com IA generativa** use case onde criatividade agrega (ex: geração de variações de anúncios).
3. **Compare custo/benefício** — em alguns casos, a combinação (RAG) é melhor.
4. **Develop internal capabilities** — treinar equipes em prompt engineering e evaluation de LLMs.

---

## Para desenvolvedores: código comparativo

### Exemplo 1: classificação vs. geração

**ML tradicional — Classificação de sentimentos:**
```python
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import classification_report

# Dados rotulados
textos = ["Adorei o produto!", "Péssimo atendimento", "Mais ou menos"]
rotulos = [1, 0, 0]  # 1 positivo, 0 negativo

# Vetorização
vec = TfidfVectorizer()
X = vec.fit_transform(textos)

# Treino
X_train, X_test, y_train, y_test = train_test_split(X, rotulos, test_size=0.3)
modelo = LogisticRegression()
modelo.fit(X_train, y_train)

# Predição
print(modelo.predict(vec.transform(["Estou satisfeito!"])))
```

**IA generativa — Geração de resposta:**
```python
from transformers import pipeline

generator = pipeline("text-generation", model="gpt2")
resposta = generator("O atendimento foi", max_length=20)
print(resposta[0]['generated_text'])
```

### Exemplo 2: onde híbrido brilha

**RAG para perguntas sobre documentos:**

```python
# 1. Recuperador (ML tradicional)
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity

documentos = ["A política de devolução é de 30 dias", "Horário de funcionamento: 9h-18h"]
vetorizador = TfidfVectorizer()
matriz = vetorizador.fit_transform(documentos)

def buscar(pergunta, top_k=1):
    pergunta_vec = vetorizador.transform([pergunta])
    scores = cosine_similarity(pergunta_vec, matriz)
    indices = scores.argsort()[0][-top_k:][::-1]
    return [documentos[i] for i in indices]

# 2. Gerador (IA generativa)
from transformers import pipeline

generator = pipeline("text-generation", model="gpt2")
contexto = buscar("Qual o prazo para troca?")[0]
prompt = f"Contexto: {contexto}\nPergunta: Qual o prazo para troca?\nResposta:"
print(generator(prompt, max_length=50)[0]['generated_text'])
```

### Armadilhas técnicas

**ML tradicional:**
- Feature engineering pode consumir 80% do tempo
- Seleção de variáveis: não jogue tudo no modelo
- Overfitting: valide em dados nunca vistos

**IA generativa:**
-Prompt injection: usuário pode tentar quebrar restrições ("Ignore as regras anteriores")
- Alucinação: nunca confie cegamente na saída
- Temperatura: ajuste para controlar criatividade vs. consistência

---

## Exercícios

### Nível 1 — conceitual

1. Classifique: um sistema que aprova empréstimos é ML tradicional ou generativo? Um assistente de escrita é?
2. Quando um modelo de ML tradicional se torna obsoleto?
3. Cite 3 risços de usar IA generativa para atendimento ao cliente.

### Nível 2 — técnico

1. No Colab, treine um classificador SVM no dataset Iris (scikit-learn). Compare acurácia com RandomForest. Qual é mais interpretável?
2. Use GPT-2 para gerar 5 propostas de e-mail marketing para um e-commerce de roupas. Avalie a qualidade de cada uma.
3. Implemente RAG simples: use BM25 (surprise) + GPT-2 para perguntas sobre seu próprio código-fonte.

### Nível 3 — desafio

1. Crie um classificador automático que, dado um dataset e um objetivo, sugere se deve usar ML tradicional ou IA generativa. Use como features: tamanho do dataset, tipo de dado, objetivos métricas.
2. Faça um A/B test real: compare GPT-4 (pago) vs Llama 2 rodado local (gratuito) para sumarização de artigos. Meça custo, latência e qualidade (avaliação humana).
3. Implemente um sistema de guardrails para um chatbot: se a resposta for sobre política/cidadãos, redirecione para site oficial; se for sobre saúde, adicione disclaimer.

---

## Checklist de validação

- [ ] Consigo listar 4 diferenças técnicas entre os paradigmas
- [ ] Escolhi a abordagem correta para um caso real do meu trabalho
- [ ] Executei tanto um exemplo de ML tradicional quanto de IA generativa
- [ ] Calculei o custo operacional de cada opção
- [ ] Consigo explicar para um gestor o trade-off entre controle e criatividade

---

## Fontes consultadas

- scikit-learn: Machine Learning in Python. https://scikit-learn.org/
- Hugging Face Transformers. https://huggingface.co/docs/transformers/
- Lewis, Patrick, et al. "Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks". *arXiv:2005.11401*, 2020.
- Andrew Ng. *Machine Learning Yearning*. https://machinelearningyearning.github.io/
- Ribeiro, Marco Tulio, et al. "Why Should I Trust You? Explaining the Predictions of Any Classifier". *KDD*, 2016.
