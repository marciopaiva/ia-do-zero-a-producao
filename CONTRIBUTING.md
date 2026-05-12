# Guia de Desenvolvimento — IA: Do Zero à Produção

> **Nota:** Este guia substitui o prompt master externo. Todas as contribuições devem seguir estas diretrizes.

---

## 🎯 Público-Alvo (3 perfis simultâneos)

| Perfil | Nível Técnico | Interesse Principal |
|--------|--------------|---------------------|
| **Dev** | Intermediário em código, zero em IA | Implementação, arquitetura, boas práticas |
| **Gestor** | Baixo código, foco em negócio | ROI, governança, LGPD, decisão estratégica |
| **Entusiasta** | Zero técnico, alta curiosidade | Conceitos claros, analogias, projetos guiados |

---

## 📐 Estrutura de Capítulo (obrigatório)

Todo capítulo novo deve seguir este formato:

```markdown
# Capítulo X: Título

## 🎯 Objetivo
1-2 frases sobre o que o leitor saberá fazer após ler.

## 📖 Conceito
Explicação progressiva:
1. **Analogia do cotidiano** — algo familiar
2. **Fundamento técnico** — definição precisa
3. **Aplicação prática** — como se usa no mundo real

## 💼 Para Gestores
- Quando usar / quando evitar este conceito
- ROI estimado e custos ocultos
- Métricas de sucesso (ex: precisão, recall, latência)
- Checklist de governança (LGPD, ética, auditoria)

## 💻 Para Devs
- Pré-requisitos técnicos (bibliotecas, hardware)
- Código mínimo viável (Python) com comentários
- Armadilhas comuns em produção
- Referências a notebooks (Colab/GitHub)
- Boas práticas: versionamento, testes, deploy

## 🛠️ Exercícios
- **Nível 1** — Conceitual (quiz, reflexão, sem código)
- **Nível 2** — Técnico (notebook Colab, código guiado)
- **Nível 3** — Desafio aberto (extensão do projeto)

## ✅ Checklist de Validação
- [ ] Entendi [conceito chave]
- [ ] Executei [exemplo prático]
- [ ] Consigo explicar [conceito] para um não-técnico

## 📚 Fontes Consultadas
- [Título](URL) — Autor/Instituição, Ano
- [Documentação oficial](URL) — Framework/Lib, Ano
```

---

## 🔍 Diretrizes de Conteúdo

### 1. Progressão didática
- **Zero pressuposto**: Nunca assuma conhecimento prévio de IA, estatística ou Python
- **Do simples ao complexo**: analogia → definição → implementação
- **Camadas por perfil**: cada seção serve a um dos 3 públicos

### 2. Precisão técnica
- Valide conceitos contra **documentação oficial** ou **artigos revisados por pares** (arXiv, conferências)
- Para ferramentas (LLMs, frameworks), consulte a documentação mais recente (2024-2026)
- Cite fontes explicitamente ao final de cada seção técnica

### 3. Contexto brasileiro
- Use exemplos adaptados ( substitua "Wall Street" por "B3", "FDA" por "ANVISA" quando relevante)
- Mencione **LGPD** (Lei 13.709/2018) em seções de governança
- Prefira datasets brasileiros quando disponíveis (Kaggle BR, dados.gov.br)

### 4. Código e notebooks
- Use Python 3.10+
- Bibliotecas principais: `pandas`, `numpy`, `scikit-learn`, `transformers`, `langchain`
- Código deve ser **executável** e **minimalista** (sem dependências desnecessárias)
- Links para Colab: `https://colab.research.google.com/` + path do notebook no repo

### 5. Terminologia
- Na primeira menção: termo em inglês + tradução entre parênteses
  > Ex: "embedding (vetor semântico)"
- Use a norma culta do português brasileiro
- Evite gírias e regionalismos excessivos

---

## 📚 Fontes Prioritárias

### Globais (inglês)
- **Documentação**: TensorFlow, PyTorch, scikit-learn, Hugging Face, LangChain
- **Acadêmico**: arXiv (cs.LG, cs.CL, cs.AI), Papers With Code, NeurIPS, ICML, ACL
- **Prático**: Google AI Blog, Meta AI, Towards Data Science, MLOps.com
- **Regulatório**: EU AI Act, NIST AI RMF, OECD AI Principles

### Brasil (português)
- **Regulatório**: ANPD (gov.br/anpd), LGPD (planalto.gov.br)
- **Acadêmico**: SIBGRAPI, CBSoft, ERBASE (anais)
- **Comunidade**: Data Hackers (podcast), IA Brasil (Slack), Alura, Imasters
- **Datasets**: dados.gov.br, Kaggle Brasil, IBGE

---

## 🚀 Fluxo de Trabalho

1. **Escolha o capítulo** — ver `src/index.qmd` para ordem
2. **Pesquise** — consulte fontes da lista acima (mínimo 3 por capítulo)
3. **Escreva** — siga a estrutura de capítulo, adaptando para os 3 perfis
4. **Traduza/adapte** — converta exemplos para contexto brasileiro
5. **Teste o código** — execute antes de commitar
6. **Adicione fontes** — seção `📚 Fontes Consultadas` ao final
7. **Commit** — mensagem: `Add: Capítulo X — Título`
8. **Render local** — `./ci-local.sh all` para validar Quarto
9. **PR** — abra pull request aguardando review

---

## ⚠️ Controle de Qualidade

### Antes de commit
- [ ] Estrutura de capítulo completa (todas seções)
- [ ] Código testado (mesmo que exemplos simples)
- [ ] 3+ fontes citadas (incluindo docs oficiais quando aplicável)
- [ ] Analogias para conceitos complexos
- [ ] Seções dedicadas aos 3 perfis (Dev/Gestor/Entusiasta)
- [ ] Exercícios em 3 níveis
- [ ] Checklist de validação
- [ ] Adaptação para contexto brasileiro (LGPD, exemplos locais)

### Restrições
- ❌ Não invente dados ou resultados
- ❌ Não use pacotes não-livres sem aviso
- ❌ Não promova ferramentas específicas sem comparar alternativas
- ✅ Para tópicos críticos (saúde, finanças, justiça): inclua aviso de consultar especialista

---

## 🔧 Configuração do Ambiente

```bash
# Clone e entre no diretório
git clone https://github.com/marciopaiva/ia-do-zero-a-producao.git
cd ia-do-zero-a-producao

# Instale Quarto (https://quarto.org/docs/get-started/)
# No Ubuntu/Debian, baixe o .deb da releases no GitHub

# Instale LaTeX para PDF
sudo apt-get install -y texlive-xetex texlive-fonts-recommended texlive-latex-extra texlive-lang-portuguese

# Opcional: ImageMagick (gera capa automática se src/assets/capa.png faltar)
sudo apt-get install -y imagemagick

# Build local
./ci-local.sh all
```

**Saída:** `output/book.pdf`, `output/book.epub`, `output/book.html`

---

## 📖 Capítulos Atuais

| Cap | Título | Status |
|-----|--------|--------|
| 1 | O que é Inteligência Artificial? | ✅ Completo |
| 2 | Histórico e evolução da IA | ✅ Completo |
| 3 | Aprendizado de máquina vs. IA generativa | ✅ Completo |
| 4 | Ética, viés e responsabilidade | ✅ Completo |
| 5 | Modelos de linguagem: ChatGPT, Claude, Gemini | 🚧 Esqueleto |
| 6 | Geração de imagens | 🚧 Esqueleto |
| 7 | Assistentes de código | 🚧 Esqueleto |
| 8 | Prompt engineering | 🚧 Esqueleto |
| 9-14 | Construção do Produto | 🚧 Esqueleto |
| 15-19 | Operação em Produção | 🚧 Esqueleto |
| 20-24 | Negócios e Distribuição | 🚧 Esqueleto |
| A-D | Apêndices | ✅ Completos |

---

## 🤝 Como Contribuir

1. **Escolha um capítulo em esqueleto**
2. **Desenvolva no formato acima** (copie a estrutura de Cap 1-4 como modelo)
3. **Valide local** com `./ci-local.sh all`
4. **Commit e push**
5. **Abra PR** — o workflow CI builda automaticamente no GitHub Actions

Para dúvidas, abra uma **issue** no repositório.

---

*Última atualização: 2026-05-11*
