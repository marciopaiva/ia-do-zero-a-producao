# IA do Zero à Produção

> 📘 Guia completo e prático para construir produtos com Inteligência Artificial — do conceito inicial até aplicações reais em produção.

![Status](https://img.shields.io/badge/status-em%20desenvolvimento-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Quarto](https://img.shields.io/badge/built%20with-Quarto-39729E)
![Python](https://img.shields.io/badge/python-3.11+-yellow)

---

# 📖 Sobre o Projeto

**IA do Zero à Produção** é um eBook técnico e prático voltado para:

* Desenvolvedores
* Estudantes
* Empreendedores
* Gestores
* Entusiastas de IA

O objetivo é ensinar, de forma acessível e moderna, como sair do básico da Inteligência Artificial até a criação de aplicações reais, escaláveis e prontas para produção.

O conteúdo mistura:

* Explicações conceituais
* Exemplos reais
* Código prático
* Arquitetura moderna
* MLOps
* IA generativa
* Automação
* Negócios
* Deploy
* Casos reais

---

# 🎯 Objetivos do Livro

Ao final deste material você será capaz de:

* Entender os fundamentos da IA moderna
* Utilizar modelos como GPT, Claude e Gemini
* Criar aplicações com IA generativa
* Construir MVPs rapidamente
* Aplicar RAG e embeddings
* Desenvolver APIs com IA
* Implantar sistemas em produção
* Monitorar aplicações inteligentes
* Reduzir custos operacionais
* Criar produtos reais baseados em IA

---

# 📖 Estrutura do Projeto

```text
ia-do-zero-a-producao/
├── .github/
│   └── workflows/
│       └── build-ebook.yml       # CI/CD automatizado (GitHub Actions)
│
├── src/
│   ├── _quarto.yml               # Configuração do Quarto (output-dir: ../output)
│   ├── index.qmd                 # Página inicial do livro (sumário + introdução)
│   │
│   ├── chapters/                 # Capítulos em Markdown
│   │   ├── 01-fundamentos.md     # Capítulo 1: O que é IA?
│   │   ├── 02-histórico.md       # Capítulo 2: Histórico e evolução
│   │   ├── 03-ml-generative.md   # Capítulo 3: ML vs IA generativa
│   │   ├── 04-etica.md           # Capítulo 4: Ética, viés, responsabilidade
│   │   ├── 05-ferramentas.md     # Parte II — Caps 5-8: Modelos, imagens, code, prompts
│   │   ├── 06-desenvolvimento.md # Parte III — Caps 9-14: Validação, MVP, arquitetura, deploy
│   │   ├── 07-mlops.md           # Parte IV — Caps 15-19: Monitoramento, escalabilidade, segurança, custos
│   │   ├── 08-negocios.md        # Parte V — Caps 20-24: Monetização, marketing, métricas, casos BR
│   │   └── apendices.md          # Apêndices A-D (glossário, recursos, templates, checklist)
│   │
│   ├── assets/
│   │   ├── capa.png              # Capa do ebook (gerada automaticamente se ausente)
│   │   └── styles.css            # Estilos customizados para HTML
│   │
│   └── partials/
│       └── _cover.tex            # Layout LaTeX para capa PDF
│
├── output/                       # Arquivos gerados (não versionado)
│   ├── book.pdf
│   ├── book.epub
│   └── index.html
│
├── .gitignore
├── LICENSE                       # MIT License
├── README.md
├── CONTRIBUTING.md               # Guia de contribuição
├── ci-local.sh                   # Script de build local
└── requirements.txt              # Dependências Python (opcional)
```

---

# 🧠 Conteúdo do Livro

## Parte I — Fundamentos

* O que é IA
* História da Inteligência Artificial
* Machine Learning vs IA Generativa
* Ética e responsabilidade

---

## Parte II — Ferramentas Essenciais

* GPT, Claude e Gemini
* Stable Diffusion e DALL-E
* Copilot, Cursor e Claude Code
* Prompt Engineering

---

## Parte III — Construção do Produto

* Validação de ideia
* MVP
* Arquitetura de IA
* Desenvolvimento assistido por IA
* Qualidade e testes
* Deploy

---

## Parte IV — Produção

* Monitoramento
* Escalabilidade
* Segurança
* Custos
* Manutenção contínua

---

## Parte V — Negócios

* Monetização
* Marketing
* Métricas
* Casos reais

---

# 🚀 Tecnologias Utilizadas

## Publicação

* [Quarto](https://quarto.org/)
* Markdown
* LaTeX
* EPUB

## Stack técnica

### Publicação
* [Quarto](https://quarto.org/) — sistema de publicação científica
* Markdown + extensions Quarto
* LaTeX (XeLaTeX) para PDF
* EPUB3

### Desenvolvimento (exemplos do livro)
* Python 3.11+
* scikit-learn, pandas, numpy
* transformers (Hugging Face)
* FastAPI (exemplo de API)
* Docker (exemplo de containerização)
* LangChain (RAG, agents)

## IA

* OpenAI
* Anthropic
* Gemini
* LangChain
* Sentence Transformers

---

# ⚙️ Pré-requisitos

Antes de começar, instale:

## 1. Quarto

[https://quarto.org/docs/get-started/](https://quarto.org/docs/get-started/)

---

## 2. Python 3.11+

[https://www.python.org/](https://www.python.org/)

---

## 3. LaTeX (para geração PDF)

### Ubuntu/Debian

```bash
sudo apt install texlive-full
```

### macOS

```bash
brew install --cask mactex
```

### Windows

Instale:

* MiKTeX
  ou
* TeX Live

---

# 🔧 Instalação

## Clone o repositório

```bash
git clone https://github.com/marciopaiva/ia-do-zero-a-producao.git
```

```bash
cd ia-do-zero-a-producao
```

---

## Crie ambiente virtual

```bash
python -m venv .venv
```

### Linux/macOS

```bash
source .venv/bin/activate
```

### Windows

```powershell
.venv\Scripts\activate
```

---

## Instale dependências

```bash
pip install -r requirements.txt
```

---

# 🔐 Variáveis de Ambiente (opcional)

Alguns exemplos de código podem usar chaves de API. Crie um arquivo `.env` se necessário:

```env
OPENAI_API_KEY=
ANTHROPIC_API_KEY=
GOOGLE_API_KEY=
PINECONE_API_KEY=
```

⚠️ Nunca commit chaves reais. O `.env` está no `.gitignore`.

---

# 🛠️ Build do Livro

## Gerar todos os formatos

```bash
cd src
quarto render
```

---

## Gerar PDF

```bash
quarto render index.qmd --to pdf
```

---

## Gerar EPUB

```bash
quarto render index.qmd --to epub
```

---

## Gerar HTML

```bash
quarto render index.qmd --to html
```

---

# 📦 Saídas Geradas

Os arquivos ficam em:

```text
/output
```

Formatos:

* PDF
* EPUB
* HTML

---

# 🤖 CI/CD Automatizado

O projeto utiliza GitHub Actions para:

* Build automático
* Geração PDF/EPUB/HTML
* Deploy GitHub Pages
* Releases automáticas

---

# 🌐 GitHub Pages

O workflow faz deploy automático para GitHub Pages na branch `main`.

**Configuração:**
- `publish_dir: ../output` (definido no workflow)
- Build automático a cada push
- Disponível em: `https://marciopaiva.github.io/ia-do-zero-a-producao/`

---

# 🧪 Qualidade do Projeto

## Checklist

- [x] Build automatizado (GitHub Actions)
- [x] Estrutura modular com Quarto
- [x] Formatos: PDF, EPUB, HTML
- [x] Conteúdo técnico atualizado (2024–2026)
- [x] Exemplos práticos com código
- [x] Localização brasileira (LGPD, exemplos BR)
- [ ] Revisão ortográfica completa
- [ ] Testes automatizados dos snippets de código
- [ ] Link checker (validar URLs)
- [ ] Índice remissivo (futuro)

---

# 📚 Filosofia do Livro

Este projeto segue alguns princípios:

## 1. Aprendizado prático

Menos teoria acadêmica desnecessária.
Mais construção real.

---

## 2. Explicações acessíveis

O objetivo não é impressionar.
É ensinar.

---

## 3. Produção desde o início

O foco é criar sistemas reais, escaláveis e sustentáveis.

---

## 4. Atualização contínua

IA muda rápido.
O livro evolui constantemente.

---

# 🤝 Contribuições

Contribuições são muito bem-vindas.

Você pode ajudar com:

* Correções técnicas
* Revisão textual
* Novos capítulos
* Exemplos práticos
* Casos de uso
* Melhorias no build
* Correção de links
* Otimizações de CI/CD

---

## Fluxo de contribuição

1. Fork do projeto
2. Crie uma branch

```bash
git checkout -b minha-feature
```

3. Commit

```bash
git commit -m "feat: adiciona novo capítulo"
```

4. Push

```bash
git push origin minha-feature
```

5. Abra um Pull Request

---

# 🧭 Roadmap

## Conteúdo

* [ ] Agentes de IA
* [ ] MCP (Model Context Protocol)
* [ ] Fine-tuning moderno
* [ ] Avaliação de LLMs
* [ ] Guardrails
* [ ] IA multimodal
* [ ] Sistemas autônomos
* [ ] Benchmarking
* [ ] Observabilidade para IA

---

## Infraestrutura

* [ ] Testes automatizados
* [ ] Docker Compose completo
* [ ] Ambiente DevContainer
* [ ] Deploy automático
* [ ] Preview por PR
* [ ] Cache de build


---

# 👨‍💻 Autor

**Marcio Paiva Barbosa**

* GitHub: [https://github.com/marciopaiva](https://github.com/marciopaiva)
* LinkedIn: [https://linkedin.com/in/marcio-paiva-barbosa](https://linkedin.com/in/marcio-paiva-barbosa)

---

# ⭐ Apoie o Projeto

Se este material te ajudar:

* ⭐ Dê uma estrela no repositório
* 📢 Compartilhe com outras pessoas
* 🛠️ Contribua com melhorias
* ☕ Ajude divulgando o projeto

---

# 🚀 IA não é o futuro.

Ela já é infraestrutura.

E quem aprender a construir agora terá vantagem real nos próximos anos.
