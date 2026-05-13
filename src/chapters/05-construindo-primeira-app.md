# Capítulo 5 — Construindo sua Primeira Aplicação com IA

## Objetivo do capítulo

Levar o leitor da teoria para a prática pela primeira vez. Aqui ele constrói uma aplicação funcional, conectada a um modelo real, com interface simples e pronta para evoluir.

Este capítulo transforma "entendimento" em "capacidade real de construir".

---

## 5.1 O que vamos construir

### Projeto: Assistente Inteligente de Documentos

Vamos criar um sistema onde o usuário pode:

1. **Upload de arquivos** (PDF, TXT, MD)
2. **Chat** com o assistente sobre o conteúdo
3. **Respostas contextualizadas** baseadas nos documentos
4. **Interface simples** (web)
5. **Deploy online** para compartilhar

### Por que esse projeto?

- Prepara naturalmente para **RAG** (próximo capítulo)
- Ensina **fluxo completo**: upload → processamento → chat → response
- Introduz **embeddings** e **bancos vetoriais** de forma prática
- Resultado **real e útil** — não só exemplo sintético

### Arquitetura final

```text
Usuário (frontend)
   ↓
Upload de documento
   ↓
Backend:
  1. Extrai texto
  2. Gera embeddings
  3. Armazena em banco vetorial
   ↓
Chat:
  Pergunta → embedding → busca → contexto → LLM → resposta
```

---

## 5.2 Arquitetura mínima da aplicação

### Stack enxuta

| Camada | Tecnologia | Razão |
|--------|------------|-------|
| **Frontend** | Streamlit | Zero config, Python only, rápido |
| **Backend** | FastAPI (ou dentro do Streamlit) | API robusta, async |
| **LLM** | OpenAI GPT-4o-mini ou Claude Haiku | Custo baixo, qualidade boa |
| **Embeddings** | OpenAI text-embedding-3-small | Barato, eficaz |
| **Vector DB** | Chroma (local) ou pgvector | Simples, zero infra |
| **Deploy** | Railway ou Render | Grátis, simples |

**Total de arquivos:** ~5–8 arquivos Python.

---

## 5.3 Configurando o ambiente

### Passo a passo

```bash
# 1. Crie projeto
mkdir assistente-documentos
cd assistente-documentos

# 2. Ambiente virtual
python -m venv .venv
source .venv/bin/activate  # Linux/Mac
# .venv\Scripts\activate   # Windows

# 3. Dependências
pip install fastapi uvicorn python-multipart python-dotenv
pip install openai chromadb tiktoken PyPDF2 streamlit

# 4. Estrutura
mkdir -p app/{api,core,models,services,static}
touch app/main.py app/requirements.txt .env
```

### `.env` seguro

```env
OPENAI_API_KEY=sua-chave-aqui
ANTHROPIC_API_KEY=
CHROMA_PERSIST_DIR=./chroma_db
```

Gitignore: `.env` nunca sobe.

---

## 5.4 Primeira chamada para um modelo

### Código mais simples possível

```python
# app/services/llm.py
from openai import OpenAI
import os

client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

def perguntar(prompt: str) -> str:
    response = client.chat.completions.create(
        model="gpt-4o-mini",
        messages=[
            {"role": "system", "content": "Você é um assistente útil."},
            {"role": "user", "content": prompt}
        ],
        temperature=0.7,
        max_tokens=500
    )
    return response.choices[0].message.content
```

### Teste no console

```python
>>> from app.services.llm import perguntar
>>> print(perguntar("Olá, quem é você?"))
"Olá! Sou um assistente de IA..."
```

**Parabéns:** você acabou de fazer sua primeira chamada real.

---

## 5.5 Criando uma API simples

### FastAPI básico

```python
# app/api/main.py
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from app.services import llm, rag

app = FastAPI(title="Assistente de Documentos")

class ChatRequest(BaseModel):
    message: str
    session_id: str = None  # para manter histórico

@app.post("/chat")
async def chat(req: ChatRequest):
    try:
        resposta = llm.perguntar(req.message)
        return {"reply": resposta}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/health")
def health():
    return {"status": "ok"}
```

### Teste local

```bash
uvicorn app.api.main:app --reload
# Acesse: http://localhost:8000/docs
```

---

## 5.6 Construindo a interface

### Opção 1: Streamlit (recomendado para Cap 5)

```python
# app/ui/streamlit_app.py
import streamlit as st
import requests

st.title("📄 Assistente de Documentos")

# Inicializa histórico
if "messages" not in st.session_state:
    st.session_state.messages = []

# Mostra histórico
for msg in st.session_state.messages:
    with st.chat_message(msg["role"]):
        st.write(msg["content"])

# Input do usuário
if prompt := st.chat_input("Pergunte sobre os documentos..."):
    # Mostra pergunta
    st.session_state.messages.append({"role": "user", "content": prompt})
    with st.chat_message("user"):
        st.write(prompt)

    # Chama API
    response = requests.post(
        "http://localhost:8000/chat",
        json={"message": prompt}
    ).json()

    # Mostra resposta
    st.session_state.messages.append({"role": "assistant", "content": response["reply"]})
    with st.chat_message("assistant"):
        st.write(response["reply"])
```

```bash
streamlit run app/ui/streamlit_app.py
```

**Resultado:** interface de chat funcional em 3 minutos.

---

### Opção 2: HTML + JavaScript (para quem prefere frontend)

```html
<!-- static/index.html -->
<!DOCTYPE html>
<html>
<body>
  <div id="chat"></div>
  <input id="msg" placeholder="Digite...">
  <button onclick="send()">Enviar</button>

  <script>
    async function send() {
      const input = document.getElementById('msg').value;
      const res = await fetch('http://localhost:8000/chat', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({message: input})
      });
      const data = await res.json();
      // adiciona ao chat
    }
  </script>
</body>
</html>
```

---

## 5.7 Mantendo contexto da conversa

### Histórico simples

```python
# Armazenar histórico na sessão
class SessionManager:
    def __init__(self):
        self.history = {}  # {session_id: [mensagens]}

    def get_history(self, session_id: str):
        return self.history.get(session_id, [])

    def add_message(self, session_id: str, role: str, content: str):
        if session_id not in self.history:
            self.history[session_id] = []
        self.history[session_id].append({
            "role": role,
            "content": content
        })
```

### Enviando histórico para o LLM

```python
def chat_com_historico(session_id: str, nova_msg: str):
    hist = session_manager.get_history(session_id)
    messages = [
        {"role": "system", "content": "Você é um assistente útil."},
        *hist[-10:],  # últimos 10 mensagens (corta o excesso)
        {"role": "user", "content": nova_msg}
    ]
    # chamada OpenAI
```

**Importante:** limite o histórico (ex: últimos 10 mensagens) para controlar tokens.

---

## 5.8 Streaming de respostas

### Por que streaming?

Respostas aparecem **conforme geradas**, não after completo. UX muito melhor.

### Implementação FastAPI

```python
from fastapi import FastAPI
from fastapi.responses import StreamingResponse

app = FastAPI()

async def generate_stream(prompt: str):
    stream = client.chat.completions.create(
        model="gpt-4o-mini",
        messages=[{"role": "user", "content": prompt}],
        stream=True
    )
    for chunk in stream:
        if chunk.choices[0].delta.content:
            yield chunk.choices[0].delta.content

@app.post("/chat/stream")
async def chat_stream(req: ChatRequest):
    return StreamingResponse(
        generate_stream(req.message),
        media_type="text/plain"
    )
```

### Frontend consumindo stream

```javascript
const response = await fetch('/chat/stream', {method: 'POST', ...});
const reader = response.body.getReader();
while (true) {
  const {done, value} = await reader.read();
  if (done) break;
  const text = new TextDecoder().decode(value);
  // adiciona texto ao chat em tempo real
}
```

---

## 5.9 Tratamento de erros

### Erros comuns

1. **Timeout** — modelo demora
2. **Rate limit** — muitos requests
3. **Chave inválida** — API key errada
4. **Serviço indisponível** — OpenAI down

### Código robusto

```python
import time
from tenacity import retry, stop_after_attempt, wait_exponential

@retry(stop=stop_after_attempt(3), wait=wait_exponential(multiplier=1, min=2, max=10))
def chamar_openai(prompt: str):
    try:
        response = client.chat.completions.create(...)
        return response
    except openai.APIError as e:
        if e.status_code == 429:  # rate limit
            time.sleep(5)
            raise  # retry
        elif e.status_code == 500:
            # fallback para modelo menor
            return client.chat.completions.create(model="gpt-3.5-turbo", ...)
        else:
            raise
```

### Fallback strategy

Se GPT-4 falhar: usa GPT-3.5  
Se API cair: resposta cacheada ou mensagem amigável

---

## 5.10 Controle de custo

### Estimativa de custo

```python
import tiktoken

def contar_tokens(texto: str) -> int:
    encoder = tiktoken.encoding_for_model("gpt-4")
    return len(encoder.encode(texto))

def estimar_custo(prompt: str, resposta: str):
    tokens_in = contar_tokens(prompt)
    tokens_out = contar_tokens(resposta)
    custo = (tokens_in * 0.01 + tokens_out * 0.03) / 1000  # GPT-4
    return custo
```

### Estratégias

- **Limite por usuário**: max 1000 tokens/dia
- **Cache**: armazena perguntas frequentes
- **Modelo menor** para tarefas simples (gpt-4o-mini vs gpt-4)
- **Trim contexto**: não envie histórico completo se for longo

---

## 5.11 Deploy inicial

### Railway (mais fácil)

1. Crie conta em railway.app
2. Link com GitHub
3. Adicione variáveis de ambiente (OPENAI_API_KEY)
4. Deploy automático a cada push

`railway.json`:
```json
{
  "build": "pip install -r requirements.txt",
  "start": "uvicorn app.api.main:app --host 0.0.0.0 --port $PORT"
}
```

### Render

Similar: git push → deploy automático.

### Docker (opcional)

```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
CMD ["uvicorn", "app.api.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

---

## 5.12 Melhorias futuras

O projeto atual é MVP. Evoluções possíveis:

1. **RAG** — ler documentos e responder com base neles (Cap 6)
2. **Upload de arquivos** — PDF, TXT, DOCX
3. **Autenticação** — usuários próprios
4. **Histórico persistente** — banco de dados
5. **Streaming** — already done, but better UX
6. **Agentes** — que tomam ações (buscar, calcular)
7. **Observabilidade** — logs, custos, métricas
8. **Testes** — unitários, integração
9. **CI/CD** — GitHub Actions
10. **Frontend completo** — Next.js com React

---

## Exercícios

### Nível 1 — conceitual

1. Desenhe o fluxo completo da aplicação em um diagrama.
2. Explique a diferença entre frontend, backend e LLM.
3. Por que streaming melhora a experiência do usuário?

### Nível 2 — técnico

1. Siga o tutorial passo a passo e construa o assistente do zero.
2. Adicione contador de tokens e custo por conversa.
3. Implemente fallback: se GPT-4 falhar, use GPT-3.5.

### Nível 3 — desafio

1. Adicione upload de PDF e extração de texto (PyPDF2).
2. Salve conversas em SQLite para histórico persistente.
3. Implemente auth básica (usuário/senha) e limite de uso.

---

## Checklist de validação

- [ ] Ambiente configurado (Python, venv, dependências)
- [ ] Primeira chamada à API funcionou
- [ ] API FastAPI criada e rodando
- [ ] Interface Streamlit funcionando
- [ ] Chat com histórico simples
- [ ] Streaming implementado
- [ ] Tratamento de erros básico
- [ ] Deploy online (Railway/Render)
- [ ] Custo monitorado (token counter)
- [ ] Código versionado no Git

---

## Fontes consultadas

- **FastAPI Documentation** — https://fastapi.tiangolo.com
- **Streamlit Documentation** — https://docs.streamlit.io
- **OpenAI API Reference** — https://platform.openai.com/docs/api-reference
- **Tenacity** — https://github.com/jd/tenacity (retries)
- **Railway Docs** — https://docs.railway.app
- **Tiktoken** — https://github.com/openai/tiktoken

---

## Próximo capítulo

No Capítulo 6, vamos levar esse projeto para o próximo nível: **RAG** — fazendo o assistente ler e responder com base em documentos enviados pelo usuário.
