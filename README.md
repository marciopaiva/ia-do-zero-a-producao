# IA do Zero à Produção

Ebook completo sobre Inteligência Artificial, do conceito básico à implementação em produção.

## 📚 Estrutura do Projeto

```
ia-do-zero-a-producao/
├── .github/workflows/
│   └── build-ebook.yml      # CI/CD automática no GitHub Actions
├── src/
│   ├── _quarto.yml          # Configuração do Quarto
│   ├── index.qmd            # Página inicial com sumário
│   ├── chapters/            # Capítulos do ebook
│   │   ├── 01-fundamentos.md
│   │   ├── 02-ferramentas.md
│   │   ├── 03-desenvolvimento.md
│   │   ├── 04-producao.md
│   │   ├── 05-negocios.md
│   │   └── apendices.md
│   ├── assets/
│   │   ├── capa.png         # Capa do ebook
│   │   └── styles.css       # Estilos para HTML
│   └── partials/
│       └── _cover.tex       # Layout da capa (PDF LaTeX)
├── .gitignore
├── README.md
├── LICENSE
├── requirements.txt
└── output/                  # Arquivos gerados (PDF, EPUB, HTML)
```

## 🛠️ Build

### Pré-requisitos

1. [Quarto](https://quarto.org/docs/get-started/) instalado
2. LaTeX (para PDF): `texlive-xetex` (Ubuntu/Debian) ou similar

### Compilação local

```bash
# Navegue até a pasta src
cd src

# Render todos os formatos (saída em ../output/)
quarto render

# Ou formato específico
quarto render index.qmd --to pdf
quarto render index.qmd --to epub
quarto render index.qmd --to html
```

### GitHub Actions

O workflow `build-ebook.yml` compila automaticamente o ebook em PDF e EPUB a cada push nas branches `main` ou `master`. Os artefatos podem ser baixados da aba Actions.

## 🎯 Uso

O projeto usa [Quarto](https://quarto.org) como sistema de publicação. Os arquivos `.qmd` são Markdown com extensões Quarto (YAML front matter, callouts, cross-references, etc.).

Adicione novos capítulos em `src/chapters/` e referencie no `_quarto.yml`.

## 📖 Conteúdo

**Parte I — Fundamentos** (Cap 1-4 completos)
**Parte II — Ferramentas** (Cap 5-8 esqueleto)
**Parte III — Construção** (Cap 9-14 esqueleto)
**Parte IV — Produção** (Cap 15-19 esqueleto)
**Parte V — Negócios** (Cap 20-24 esqueleto)
**Apêndices** (A-D completos)

## 🤝 Contribuindo

Contribuições são bem-vindas! Sinta-se livre para:

- Adicionar conteúdo aos capítulos em esqueleto
- Corrigir erros ou melhorar a redação
- Sugerir novas seções
- Enviar PRs com melhorias

## 📄 Licença

MIT License — uso livre, com atribuição.
