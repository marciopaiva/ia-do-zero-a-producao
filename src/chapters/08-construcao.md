# Capítulo 8 — Desenvolvimento de Produtos com IA

## Objetivo do capítulo

Conduzir o leitor do zero ao produto funcional, cobrindo validação, definição de MVP, arquitetura, desenvolvimento assistido por IA, testes e deploy.

---

## 8.1 Validação de ideia sem escrever código

### Por que validar primeiro?

O maior erro de empreendedores e devs é construir antes de validar. IA facilita prototipagem, mas isso não justifica pular a validação.

### Métodos de validação

1. **Pesquisa de mercado** — entrevistas com potenciais usuários
2. **Landing page de teste** — capture e-mails antes de ter produto
3. **Pré-venda** — venda antes de construir (validação extrema)
4. **Concorrência análise** — use IA para analisar reviews de produtos similares

### Ferramentas de IA na validação

- **Análise de concorrentes**: peça ao GPT para resumir reviews de App Store/Google Play
- **Personas**: gere personas realistas a partir de dados demográficos
- **Simulação de entrevistas**: role-play com LLM como cliente

---

## 8.2 Definindo o MVP (Produto Mínimo Viável)

### Princípio

MVP é a **menor versão** do produto que entrega valor central e permite aprender com usuários reais.

Para produtos de IA, o MVP testa:
- O modelo funciona?
- Os usuários entendem a saída?
- O custo é sustentável?

### Exemplo

**Ideia:** assistente de escrita de e-mails.

**MVP:** interface web onde usuário digita "resposta ao cliente X", o sistema gera draft, usuário edita e envia.

**Não-MVP:** aprendizado de voz, suporte a múltiplos idiomas, integrações, mobile app.

---

## 8.3 Arquitetura de um produto de IA

### Componentes essenciais

1. **Frontend** — interface do usuário (web, mobile)
2. **Backend API** — lógica de negócio, orquestração
3. **Camada de IA** — modelo ou API
4. **Banco de dados** — usuários, histórico, métricas
5. **Cache** — respostas frequentes, reduz custo/latência
6. **Fila** (opcional) — tarefas assíncronas (ex: processamento em batch)
7. **Monitoramento** — logs, métricas, alertas

### Padrões arquiteturais

#### RAG (Retrieval-Augmented Generation)

```text
Query → Embedding → Vector DB → Context retrieved → LLM → Answer
```

Use quando: precisar de conhecimento específico (docs internos, FAQs).

#### Fine-tuning vs Prompting

- **Prompting**: zero-shot ou few-shot; flexível, barato, mas inconsistente
- **Fine-tuning**: ajusta modelo permanentemente; custo inicial alto, mas consistente

#### Streaming

Respostas token a token (como ChatGPT). Melhor UX, mais complexo de implementar.

---

## 8.4 Desenvolvimento assisted by AI

### O papel do desenvolvedor hoje

De "digitador de código" para "arquiteto e validador".

Ferramentas:
- **GitHub Copilot** — autocomplete
- **Cursor** — refatoração automática
- **Claude Code** — refatoração grande, debugging

### Workflow eficiente

1. **Escreva a spec** (o que a função deve fazer)
2. **Gere código** com IA
3. **Revise e refine** — IA erra, você corrige
4. **Teste** — manual ou automático
5. **Documente** — a IA pode ajudar a escrever docstrings

**Produtividade:** 2–5x mais rápido para código boilerplate.

---

## 8.5 Testes e qualidade

### Testes tradicionais

- **Unit tests** — testam funções isoladas
- **Integration tests** — testam integração entre componentes
- **E2E tests** — testam fluxo completo

### Testes específicos de IA

- **Avaliação de outputs**: compare com golden answers
- **Robustness testing**: inputs adversariais
- **A/B testing de modelos**: compare versões
- **Human eval**: amostra revisada por pessoas

**Metricas comuns:**
- Precisão, recall, F1 (classificação)
- BLEU, ROUGE (texto)
- Similaridade de embedding (RAG)

---

## 8.6 Deploy e infraestrutura

### Opções de hospedagem

| Opção | Melhor para | Custo | Complexidade |
|-------|-------------|--------|--------------|
| **VPS (DigitalOcean, Linode)** | Controle total, custo previsível | Médio | Média |
| **Cloud (AWS, GCP, Azure)** | Escala, serviços gerenciados | Variável | Alta |
| **Serverless (Vercel, Railway)** | Simplicidade, auto-scale | Baixo-médio | Baixa |
| **Edge (Cloudflare Workers)** | Latência baixa, global | Baixo | Média |

### CI/CD para produtos de IA

Diferenças vs software tradicional:
- **Teste de modelos**: validar qualidade antes de deploy
- **Canary releases**: liberar para % pequeno de usuários
- **Rollback rápido**: se modelo degrada, reverta
- **Monitoramento integrado**: métricas de modelo no pipeline

### Containers

Dockerize sua aplicação:
```dockerfile
FROM python:3.11-slim
COPY . /app
RUN pip install -r requirements.txt
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
```

---

## 8.7 Checklist de validação (Cap 6)

- [ ] Validação de ideia concluída (entrevistas, landing page)
- [ ] MVP definido (escopo claro)
- [ ] Arquitetura desenhada (diagrama)
- [ ] Stack tecnológica escolhida
- [ ] Primeira versão desenvolvida (mesmo que simples)
- [ ] Testes implementados
- [ ] Deploy em ambiente de staging
- [ ] Monitoramento básico configurado

---

## Fontes consultadas (Cap 6)

- **Lean Startup** — Eric Ries (validação, MVP)
- **Building Machine Learning Powered Applications** — Emmanuel Ameisen (arquitetura ML)
- **MLOps Engineering at Scale** — Carl Peter
- **FastAPI Documentation** — https://fastapi.tiangolo.com
- **Docker Documentation** — https://docs.docker.com
- **CI/CD for Machine Learning** — https://docs.github.com/en/actions
