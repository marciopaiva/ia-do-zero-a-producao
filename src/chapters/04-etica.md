# Capítulo 4 — Ética, Viés e Responsabilidade

## Objetivo do capítulo

Identificar riscos éticos em projetos de IA, aplicar técnicas de mitigação de viés e garantir conformidade com a LGPD e regulamentações emergentes. Ao final, você saberá construir sistemas que sejam não apenas eficazes, mas justos e responsáveis.

---

## 4.1 Por que ética não é "depois"

### Uma história real

Em 2018, pesquisadores do MIT testaram três sistemas comerciais de reconhecimento facial. Resultado: para mulheres negras, a taxa de erro era de 35%. Para homens brancos: menos de 1%.

Os modelos não tinham "preconceito" intencional. Apenas aprenderam de dados que tinham muito mais homens brancos do que mulheres negras.

**A IA amplifica o que recebe.** Dados históricos discriminatórios geram outputs discriminatórios.

### O papel do construtor

Se você constrói um sistema de IA, você é responsável por:
- Os dados que usa
- As decisões que o modelo toma
- Os impactos na vida das pessoas

Não ter a intenção de prejudicar não isenta da responsabilidade.

---

## 4.2 O que é viés algorítmico

### Definição prática

**Viés algorítmico** ocorre quando um sistema produz resultados que sistematicamente favorecem (ou prejudicam) determinados grupos.

Não é sobre "mau comportamento" da IA. É sobre **estatísticas desbalanceadas** que geram injustiça.

### Como surge

1. **Viés de seleção** — dados de treinamento não representam a população real
   - Exemplo: modelo de recrutamento treinado apenas com currículos de homens (porque a empresa historicamente contratou mais homens)

2. **Viés de medida** — a forma como medimos é enviesada
   - Exemplo: usar "histórico criminal" como proxy para "risco", mas o policing é discriminatório

3. **Viés de agregação** — tratar grupos diversos como se fossem iguais
   - Exemplo: modelo de crédito que usa "CEP" como feature, mas certas áreas são majoritariamente pobres

### Caso Brasil: crédito

Em 2021, investigações revelaram que algoritmos de scoring de crédito discriminavam por cor/raça. A defesa: "o modelo é neutro, baseado em dados financeiros". O problema: dados financeiros refletem desigualdade histórica. Resultado: pessoas negras recebiam limites menores, juros maiores.

**Conclusão:** neutralidade matemática não garante justiça social.

---

## 4.3 Consequências reais

### Para indivíduos

- **Oportunidades perdidas**: vaga de emprego rejeitada por algoritmo enviesado
- **Custos maiores**: seguros ou crédito mais caro por grupo
- **Exclusão**: sistemas de reconhecimento facial que não identificam rostos não-brancos
- **Violação de privacidade**: dados sensíveis usados sem consentimento

### Para empresas

- **Reputação**: vazamento de viés gera crise de imagem
- **Multas**: LGPD prevê até 2% do faturamento (máx. R$ 50 milhões/infração)
- **Perda de mercado**: clientes abandonam produtos percebidos como injustos
- **Litígios**: ações coletivas por discriminação

### Para sociedade

- **Amplificação de desigualdade**: IA automatiza e escala vieses existentes
- **Perda de confiança**: população desconfia de tecnologias
- **Polarização**: algoritmos de recomendação criam bolhas

---

## 4.4 Framework legal brasileiro

### LGPD (Lei 13.709/2018)

**Art. 20** — decisões automatizadas que afetam pessoas devem ter:
- Explicabilidade (informar lógica used)
- Revisão humana solicitável
- Possibilidade de contestação

**Art. 46** — operador deve adotar medidas técnicas e administrativas para proteger dados.

**Art. 48** — comunicação de incidentes à ANPD e titular em até 24h se houver riscos.

**Sanções:**
- Advertência
- Multa até 2% do faturamento (máx. R$ 50 milhões por infração)
- Suspensão ou eliminação de dados

### AI Act (União Europeia)

Classifica sistemas por risco:
- **Proibidos**: scoring social, manipulation
- **Alto risco**: recrutamento, crédito, saúde — exigem avaliação de conformidade
- **Limitados**: chatbots — requerem disclosure de que são IA
- **Mínimos**: todos os outros

---

## 4.5 Checklist de governança

Antes de deploy, responda:

**Dados:**
- [ ] Dados de treinamento representam diversidade da população-alvo?
- [ ] Features sensíveis (raça, gênero) são usadas? Justifique.
- [ ] Dados pessoais sensíveis foram removidos ou anonimizados?

**Métricas:**
- [ ] Testei equalized odds (TPR igual entre grupos)?
- [ ] Testei demographic parity (taxa de positivos igual entre grupos)?
- [ ] Calculei disparity impact (razão entre taxas de grupos)?

**Processo:**
- [ ] Decisões críticas têm override humano?
- [ ] Usuário sabe que está interagindo com IA?
- [ ] Há canal para denúncias de discriminação?
- [ ] Documentação do modelo e limitações está acessível?

**Monitoramento:**
- [ ] Logging de predições com grupos sensíveis (com cuidado com LGPD!)
- [ ] Alertas se disparidade aumentar 10% em uma semana
- [ ] Revisão periódica independente?

---

## 4.6 Técnicas de mitigação (código)

### Pré-processamento: reweighting

```python
from fairlearn.reductions import ExponentiatedGradient, DemographicParity
from sklearn.tree import DecisionTreeClassifier
from sklearn.datasets import make_classification
import pandas as pd

# Dados sintéticos com sensitive attribute
X, y = make_classification(n_features=5, n_classes=2)
sensitive = [0, 1, 0, 1, 0, 1, 0, 1, 0, 1]  # grupo sensível

# Converter para DataFrame
df = pd.DataFrame(X, columns=[f'f{i}' for i in range(5)])
df['target'] = y
df['group'] = sensitive

# Treinar modelo com constraint de fairness
constraint = DemographicParity()
classifier = DecisionTreeClassifier()
mitigator = ExponentiatedGradient(classifier, constraint)
mitigator.fit(df.drop(['target', 'group'], axis=1), df['target'], sensitive_features=df['group'])

# Avaliar
predictions = mitigator.predict(df.drop(['target', 'group'], axis=1))
```

### Pós-processamento: threshold adjustment

```python
from fairlearn.postprocessing import ThresholdOptimizer
from sklearn.linear_model import LogisticRegression

# Ajusta thresholds por grupo para equalizar taxas
optimizer = ThresholdOptimizer(
    estimator=LogisticRegression(),
    constraints="equalized_odds",
    prefit=False
)
optimizer.fit(X_train, y_train, sensitive_features=train_groups)
```

### Ferramentas

- **Fairlearn** (Microsoft) — métricas e mitigação
- **AIF360** (IBM) — toolkit completo
- **SHAP** — explicabilidade de modelos

---

## 4.7 Privacidade e dados pessoais

### Princípio: dados mínimos

Não coletar o que não precisa.

Se for treinar modelo de recomendação, não precisa do CPF do usuário.

### Anonimização insuficiente

Remover nome e e-mail não é enough. Combinação de features (cep, idade, profissão) pode re-identificar.

### Técnicas

1. **Differential privacy** — adiciona ruído estatístico para proteger indivíduos
2. **k-anonymity** — cada registro é indistinguível de k-1 outros
3. **Federated learning** — treina descentralizado, dados não saem do dispositivo

```python
# Exemplo conceitual de differential privacy
from opacus import PrivacyEngine

# Envolve modelo e optimizer
privacy_engine = PrivacyEngine()
model, optimizer, data_loader = privacy_engine.make_private(
    module=model,
    optimizer=optimizer,
    data_loader=train_loader,
    noise_multiplier=1.1,
    max_grad_norm=1.0,
)
```

---

## 4.8 Monitoramento em produção

### O que loggar

- **Input**: prompt (sem dados sensíveis!)
- **Output**: resposta do modelo
- **Metadata**: timestamp, user_id (anonimizado), latency, custo
- **Labels** (quando disponível): feedback humano

**Cuidado:** não logar dados pessoais (LGPD). Anonimize ou agregue.

### Métricas de fairness contínuas

```python
import pandas as pd
from fairlearn.metrics import demographic_parity_difference

# Log de predições ao longo do tempo
logs = pd.read_csv("predicoes.csv")

# Calcular disparidade semanalmente
logs['semana'] = pd.to_datetime(logs['timestamp']).dt.isocalendar().week
weekly_disparity = logs.groupby('semana').apply(
    lambda df: demographic_parity_difference(
        df['true'], df['pred'], df['group']
    )
)

# Alerta se disparidade aumenta > 10%
limite = 0.1
if weekly_disparity.diff().abs().max() > limite:
    send_alert("Viés aumentou significativamente")
```

---

## 4.9 Caso prático: sistema de recrutamento enviesado

### Cenário

Empresa de tecnologia desenvolveu modelo para classificar currículos. Treinou com histórico interno (80% homens). Resultado: mulheres rejeitadas 30% mais que homens com qualificação similar.

### Detecção

1. **Auditoria**: analisar taxa de aprovação por gênero
2. **Métrica**: demographic parity difference = 0.28 (alto viés)
3. **Root cause**: dados históricos desbalanceados + feature "universidade" correlacionada com gênero

### Correção

1. **Pré-processamento**: reweighing (dar mais peso para exemplos de mulheres)
2. **Remover feature** "universidade" (proxy de gênero)
3. **Auditoria humana** em casos de empate
4. **Re-colheita de dados**: campanha para receber mais currículos de mulheres

**Resultado pós-correção:** disparidade caiu para 0.05 (aceitável).

---

## Exercícios

### Nível 1 — conceitual

1. Dê exemplo onde "tratamento igual" (mesma regra) gera injustiça.
2. Por que remover a variável "raça" nem sempre resolve o problema?
3. Explique a diferença entre fairness individual e grupal.

### Nível 2 — técnico

1. No Colab, use dataset `Adult` (UCI) para prever renda. Calcule disparidade de gênero com Fairlearn.
2. Aplique reweighing e compare métricas antes/depois.
3. Implemente detector de prompt injection com regex e ML.

### Nível 3 — desafio

1. Simule cenário de crédito com dados brasileiros fictícios. Demonstre viés e proponha correção.
2. Dashboard Streamlit com evolução de fairness metrics em tempo real.
3. Escreva compliance checklist de 10 itens baseado na LGPD e AI Act.

---

## Checklist de validação

- [ ] Entendo viés individual vs. grupal
- [ ] Executei auditoria de fairness
- [ ] Conheço 3 artigos da LGPD aplicáveis a IA
- [ ] Implementei técnica de mitigação
- [ ] Consigo explicar trade-off entre acurácia e fairness
- [ ] Sei configurar logging ético (sem dados sensíveis)
- [ ] Entendo processo de DPIA (Data Protection Impact Assessment)

---

## Fontes consultadas

- **Lei Geral de Proteção de Dados (LGPD)** — Lei 13.709/2018
- **AI Act (EU)** — European Commission, 2024
- **Fairlearn Documentation** — Microsoft Research
- **Gender Shades** — Buolamwini & Gebru, 2018 (FAccT)
- **The Algorithmic Justice League** — https://www.ajl.org/
- **ANPD — Diretrizes sobre IA** — gov.br/anpd
- **NIST AI Risk Management Framework** — 2023
