# Capítulo 9 — MLOps e Manutenção

## Objetivo do capítulo

Colocar o sistema em produção e mantê-lo funcionando: monitoramento, escalabilidade, segurança, custos, atualizações.

---

## 9.1 Monitoramento e observabilidade

### O que monitorar?

1. **Infraestrutura**
   - CPU, memória, disco
   - Latência (p50, p95, p99)
   - Throughput (req/s)
   - Error rate (%)

2. **Modelo**
   - Distribuição de scores de confiança
   - Drift de dados (input distribution muda?)
   - Degradação de qualidade (metrics vs. baseline)

3. **Negócio**
   - Uso (usuários ativos, sessões)
   - Custo por request
   - Satisfação (CSAT, NPS)

### Implementação

- **Logs estruturados** (JSON) — inclua: timestamp, user_id (anon.), prompt_hash, latency, custo
- **Métricas** — Prometheus + Grafana ou Datadog
- **Tracing** — OpenTelemetry para seguir requests através de serviços

**Exemplo de log:**
```json
{
  "timestamp": "2026-05-12T10:23:00Z",
  "user_id": "anon_12345",
  "model": "gpt-4",
  "input_tokens": 250,
  "output_tokens": 180,
  "latency_ms": 1240,
  "cost_usd": 0.0123,
  "error": false
}
```

---

## 9.2 Escalabilidade e performance

### Estratégias

1. **Cache** — armazene respostas frequentes (Redis, Memcached)
2. **Rate limiting** — proteja backend de overdose
3. **Load balancing** — distribua carga em múltiplas instâncias
4. **Auto-scaling** — aumente réplicas conforme demanda
5. **Batch processing** — agrupe predições quando possível

### Otimização de modelos

- **Quantização**: FP16 → INT8 reduz memória, speedup
- **Pruning**: remove pesos pouco usados
- **Distillation**: modelo pequeno aprende do grande
- **Caching de embeddings**: não recalcule

---

## 9.3 Segurança e conformidade

### Ameaças

- **Prompt injection** — usuário engana modelo ("Ignore regras anteriores")
- **Data leakage** — vazamento de dados sensíveis via logs
- **Denial of service** — flood de requests
- **Model theft** — extração do modelo via API

### Proteções

1. **Input validation** — sanize prompts (block list de comandos perigosos)
2. **Rate limiting + authentication** — evite abuse
3. **PII detection** — escaneie inputs/outputs, redija se necessário
4. **Audit logs** — registre todas as ações
5. **Model isolation** — não rode modelos não-confiaveis no mesmo HW

### LGPD

- Anonimize logs (não guarde CPF, e-mail direto)
- Direito à explicação: tenha logs para reconstruir decisões
- Retenção limitada: defina TTL para dados pessoais

---

## 9.4 Gestão de custos

### Onde o dinheiro vai

- **API de LLM**: geralmente >70% do custo
- **Infra**: VMs, GPU, armazenamento
- **Observabilidade**: ferramentas de monitor
- **Desenvolvimento**: fine-tuning, eval

### Redução de custos

| Tática | Economia | Complexidade |
|--------|----------|--------------|
| Cache de respostas | 20–50% | Baixa |
| Modelo menor para tarefas simples | 30–70% | Média |
| Batch de requests | 10–30% | Baixa |
| Contexto otimizado (trim) | 5–15% | Baixa |
| Quantização (local) | 50–80% vs API | Alta |

**Budget tracking:** defina alertas em US$ mensais.

---

## 9.5 Manutenção e evolução contínua

### Ciclo de vida do produto de IA

1. **Coleta de feedback** — usuários reportam problemas
2. **Priorização** — o que ajustar primeiro?
3. **Experimento** — A/B test de novo modelo/prompt
4. **Deploy** — rollout gradual (canary)
5. **Monitor** — veja métricas pós-deploy
6. **Itere**

### Atualização de modelos

- **Novos modelos surgem** (ex: GPT-5). Avalie se vale migrar.
- **Fine-tuning contínuo** — re-treine com novos dados periodicamente
- **Prompt management** — versionação de prompts (como código)

---

## 9.6 Disaster recovery

### O que pode falhar?

- API do provedor cai
- Modelo degrade (qualidade cai)
- Ataque de segurança
- Custo explode

### Planos

- **Fallback model**: se GPT-4 falha, usa GPT-3.5
- **Rollback rápido**: versão anterior funcionava? Volte.
- **Circuit breaker**: se erro rate > 5%, pare de chamar API por 5min

---

## Exercícios

### Nível 1

1. Liste 5 métricas que você monitoraria em um chatbot.
2. Explique por que cache é importante.
3. Dê exemplo de prompt injection.

### Nível 2

1. Configure Prometheus + Grafana em uma aplicação FastAPI.
2. Implemente rate limiting com Redis.
3. Adicione logging estruturado (JSON) e envie para Loki/ELK.

### Nível 3

1. Implemente detecção de drift em embeddings de entrada (compare distribuição vs. treino).
2. Construa sistema de fallback: se LLM falhar, use resposta template.
3. Crie dashboard de custos diários por modelo.

---

## Checklist

- [ ] Logs estruturados implementados
- [ ] Métricas de latency/error rate coletadas
- [ ] Cache configurado
- [ ] Rate limiting ativo
- [ ] Alertas configurados (PagerDuty, Slack)
- [ ] Processo de rollback documentado
- [ ] Budget monitorado
- [ ] Backup de configuração

---

## Fontes

- **Google SRE Book** — https://sre.google/books/
- **MLOps: Continuous Delivery for ML** — https://ml-ops.org/
- **Prometheus Documentation** — https://prometheus.io/
- **OpenTelemetry** — https://opentelemetry.io/
