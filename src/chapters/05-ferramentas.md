# Parte II — Ferramentas Essenciais

## Capítulo 5: Modelos de Linguagem (ChatGPT, Claude, Gemini)

### Objetivo do Capítulo

Ao final deste capítulo, você será capaz de escolher o modelo de linguagem mais adequado para seu projeto, entender como a janela de contexto afeta custos e desempenho, e aplicar técnicas de fine-tuning quando necessário. Vamos transformar conceitos técnicos aparentemente complexos em decisões práticas do dia a dia.

### Analogia do Dia a Dia: O Restaurante de Comida Chinês

Imagine um restaurante de comida chinês onde você pode encomendar pratos diferentes. O garçom é como o modelo de linguagem - ele leva seu pedido até a cozinha (a API), traz o prato pronto (a resposta), e pode conversar com você sobre as opções disponíveis.

A janela de contexto é como a memória do garçom: ele pode lembrar das últimas 20 conversas (context window de 8K), 100 conversas (context window de 32K), ou até mais. Quanto mais ele se lembrar, mais caro será seu prato, porque ele precisa de um caderno de anotações maior (mais tokens processados = mais custo computacional).

Se você quiser personalizar o restaurante inteiro para servir apenas comida vegana, isso seria como o fine-tuning: você reeducaria toda a cozinha para seguir suas preferências específicas.

### Explicação Técnica Acessível

#### O que são Modelos de Linguagem?

Modelos de linguagem são programas de computador treinados com bilhões de texto para prever a próxima palavra em uma sequência. Pense neles como um super-autocorrect inteligente que aprendeu padrões de linguagem natural.

#### Principais Modelos no Mercado

| Modelo | Desenvolvedor | Context Window | Características |
|--------|---------------|----------------|-----------------|
| GPT-4 | OpenAI | 8K / 32K / 128K | Excelente para raciocínio complexo |
| Claude 3 | Anthropic | 200K | Ótimo para documentos longos |
| Gemini 1.5 | Google | 1M tokens | Maior janela de contexto disponível |
| Llama 3 | Meta | 8K | Open source, pode ser auto-hospedado |

#### APIs: Como Conversar com os Modelos

As APIs (Interfaces de Programação de Aplicações) são como telefones para ligar para os modelos. Você envia uma mensagem estruturada e recebe uma resposta.

```python
import openai

client = openai.OpenAI(api_key="sua-chave-aqui")

response = client.chat.completions.create(
    model="gpt-4",
    messages=[
        {"role": "system", "content": "Você é um assistente útil"},
        {"role": "user", "content": "Explique LLMs em uma frase"}
    ],
    max_tokens=100,
    temperature=0.7
)

print(response.choices[0].message.content)
```

#### Janela de Contexto (Context Window)

A janela de contexto determina quantos tokens (aproximadamente palavras) o modelo pode processar por vez. Tokens são unidades de texto - "casa" = 1 token, "casas" = 2 tokens ("casa" + "s").

Custo típico por 1000 tokens (2024):
- GPT-4: $0.03 (input) / $0.06 (output)
- Claude 3: $0.015 (input) / $0.075 (output)
- Gemini 1.5: $0.007 (input) / $0.021 (output)

#### Fine-Tuning: Personalizando o Modelo

Fine-tuning é como ensinar novas habilidades a um funcionário experiente. Você fornece exemplos específicos e o modelo adapta seu comportamento.

```python
# Preparação de dados para fine-tuning
training_data = [
    {
        "messages": [
            {"role": "user", "content": "Classifique este email como SPAM ou HAM"},
            {"role": "assistant", "content": "SPAM"}
        ]
    },
    # Mais exemplos...
]
```

### Para Gestores: Impacto nos Negócios

A escolha do modelo de linguagem impacta diretamente:
- **Custo operacional**: Modelos diferentes têm preços distintos
- **Experiência do usuário**: Velocidade e qualidade das respostas
- **Compliance**: LGPD e privacidade dos dados dos clientes
- **Escalabilidade**: Capacidade de lidar com crescente demanda

No Brasil, lembre-se da LGPD (Lei Geral de Proteção de Dados). Se seus dados forem sensíveis (saúde, educação, finanças), prefira modelos que ofereçam garantia de processamento local ou criptografia end-to-end.

### Para Desenvolvedores: Código e Práticas

#### Configuração Inicial

```python
from openai import OpenAI
import os
from dotenv import load_dotenv

load_dotenv()

client = OpenAI(
    api_key=os.getenv("OPENAI_API_KEY"),
    organization=os.getenv("OPENAI_ORG_ID")  # opcional
)
```

#### Tratamento de Erros

```python
import time
from openai import RateLimitError, APIError

def safe_chat_completion(messages, max_retries=3):
    for attempt in range(max_retries):
        try:
            response = client.chat.completions.create(
                model="gpt-4",
                messages=messages,
                temperature=0.7
            )
            return response.choices[0].message.content
        except RateLimitError:
            time.sleep(2 ** attempt)  # Exponential backoff
        except APIError as e:
            print(f"API error: {e}")
            return None
    return None
```

#### Armadilhas Comuns

1. **Esquecer de limitar tokens de saída**: Isso pode gerar custos inesperados
2. **Não validar entrada**: Prompts maliciosos podem ser injetados
3. **Ignorar rate limits**: APIs têm limites por minuto
4. **Não considerar latência**: Respostas demoradas afetam UX

#### Melhores Práticas

1. Use streaming para respostas longas
2. Implemente cache para perguntas repetidas
3. Monitore custos em tempo real
4. Tenha fallback para modelos alternativos

### Exercícios

#### Nível Conceitual
1. Compare os custos de usar GPT-4 vs Claude 3 para um chatbot que processa 1000 mensagens/dia
2. Explique por que a janela de contexto importa para um sistema que analisa contratos
3. Quando você usaria Llama 3 ao invés de GPT-4?

#### Nível Técnico
1. Crie uma função que calcule o custo estimado de uma conversa baseado no número de tokens
2. Implemente um sistema de retry com exponential backoff para chamadas de API
3. Escreva um script que detecta quando o contexto está próximo do limite

#### Nível Desafio
1. Crie um sistema que escolhe automaticamente o modelo mais barato para uma tarefa dada
2. Implemente um cache distribuído para armazenar respostas frequentes
3. Desenvolva um wrapper que combine múltiplos modelos para alta disponibilidade

### Checklist de Validação
- [ ] Entendo a diferença entre modelos (GPT-4, Claude, Gemini)
- [ ] Sei calcular custos baseado em tokens
- [ ] Implementei tratamento de erros robusto
- [ ] Configurei rate limiting adequado
- [ ] Testei fallbacks para falhas de API

### Fontes Consultadas
- Documentação OpenAI API (2024)
- Guia Claude 3 da Anthropic
- Whitepaper Gemini 1.5 da Google
- "Building AI Applications" - O'Reilly (2024)

---

## Capítulo 6: Geração de Imagens (Midjourney, DALL-E, Stable Diffusion)

### Objetivo do Capítulo

Você aprenderá a dominar a arte de criar imagens com IA, entendendo como prompts funcionam, diferenciando modelos comerciais de open source, e aplicando técnicas avançadas para resultados profissionais.

### Analogia do Dia a Dia: O Artista por Comissão

Um modelo de geração de imagens é como um artista freelancer superdetalhado. Você lhe dá uma descrição ("uma paisagem futurista com nuvens roxas"), e ele pinta exatamente isso. Mas diferente de um artista humano, ele pode criar centenas de variações em segundos.

A diferença entre Midjourney, DALL-E e Stable Diffusion é como diferentes estilos artísticos: Midjourney tem um toque cinematográfico, DALL-E é mais preciso e literal, enquanto Stable Diffusion permite mais controle técnico.

### Explicação Técnica Acessível

#### Fundamentos da Geração de Imagens

Os modelos de geração de imagens funcionam convertendo texto em imagens através de um processo chamado "denoising diffusion". Imagine uma foto que vai se desmanchando até virar ruído - o modelo aprende a reverter esse processo.

#### Modelos Principais

| Modelo | Tipo | Preço | Controle |
|--------|------|-------|----------|
| DALL-E 3 | Comercial (OpenAI) | Pago por imagem | Baixo |
| Midjourney | Comercial | Assinatura mensal | Médio |
| Stable Diffusion | Open Source | Gratuito | Alto |

#### Estrutura de Prompts

Um prompt eficaz segue esta estrutura:
1. **Assunto principal**: "Um gato"
2. **Estilo**: "no estilo de Van Gogh"
3. **Detalhes técnicos**: "iluminação suave, fundo desfocado"
4. **Qualidade**: "alta resolução, 8K"

Exemplo ruim: "gato fofo"
Exemplo bom: "Gato siamês com olhos azuis, estilo fotográfico realista, iluminação natural de jardim, 4K"

#### Fine-Tuning em Geração de Imagens

O fine-tuning para imagens permite personalizar o estilo. Você treina com suas próprias imagens para que o modelo aprenda seu estilo único.

```python
# Exemplo conceitual - Dreambooth
# pip install diffusers transformers accelerate

from diffusers import StableDiffusionPipeline
import torch

pipe = StableDiffusionPipeline.from_pretrained(
    "stabilityai/stable-diffusion-2"
).to("cuda")

# Fine-tuning require dataset de imagens
```

### Para Gestores: Impacto nos Negócios

- **Redução de custos**: Estúdio de design interno vs contratar terceirizado
- **Velocidade de iteração**: Testar 100 variações visualmente em minutos
- **Brand consistency**: Gerar imagens que sigam guidelines de marca
- **Compliance LGPD**: Stable Diffusion local elimina risco de vazamento de dados visuais

### Para Desenvolvedores: Código e Práticas

#### Integração com DALL-E

```python
import openai
import requests
from io import BytesIO
from PIL import Image

def generate_image(prompt, size="1024x1024"):
    response = openai.images.generate(
        model="dall-e-3",
        prompt=prompt,
        size=size,
        quality="standard",
        n=1
    )
    
    image_url = response.data[0].url
    image_data = requests.get(image_url).content
    return Image.open(BytesIO(image_data))

# Uso
img = generate_image("Paisagem de Florianópolis ao pôr do sol, estilo aquarela")
img.save("florianopolis.png")
```

#### Stable Diffusion Local

```python
# pip install diffusers transformers accelerate
import torch
from diffusers import StableDiffusionPipeline, DPMSolverMultistepScheduler

model_id = "stabilityai/stable-diffusion-2-1"
pipe = StableDiffusionPipeline.from_pretrained(model_id)
pipe.scheduler = DPMSolverMultistepScheduler.from_config(pipe.scheduler.config)

# Para GPU
if torch.cuda.is_available():
    pipe = pipe.to("cuda")

prompt = "Praia de Copacabana cheia, néon cyberpunk, 4K"
image = pipe(prompt, num_inference_steps=25).images[0]
image.save("copacabana_cyberpunk.png")
```

#### Prompt Templates para Negócios Brasileiros

```python
BUSINESS_PROMPTS = {
    "logo": "Logo minimalista para startup brasileira de {setor}, cores {cores}, estilo moderno",
    "banner": "Banner para site de {produto}, público brasileiro, cores vibrantes, 1920x600",
    "social": "Post para Instagram sobre {tema}, estilo brasileiro contemporâneo, atraente visualmente"
}
```

### Exercícios

#### Nível Conceitual
1. Quando usar Stable Diffusion ao invés de DALL-E?
2. Como projetos visuais afetam a decisão de escolher entre modelos comerciais e open source?
3. Quais são os riscos legais de usar imagens geradas em campanhas publicitárias?

#### Nível Técnico
1. Crie um sistema que gere variações de um prompt base
2. Implemente um validador de prompts para garantir direitos autorais
3. Desenvolva um cache local para imagens geradas

#### Nível Desafio
1. Crie um sistema de fine-tuning para um estilo visual específico
2. Implemente um gerador automático de imagens para e-commerce
3. Desenvolva um fluxo completo: prompt -> imagem -> otimização para web

### Checklist de Validação
- [ ] Entendo a estrutura de prompts eficazes
- [ ] Sei integrar pelo menos um modelo de geração
- [ ] Implementei cache de imagens
- [ ] Considero aspectos legais (direitos autorais)
- [ ] Testei diferentes tamanhos e qualidades

### Fontes Consultadas
- Documentação DALL-E 3 da OpenAI
- Guia Midjourney (2024)
- Stability AI Documentation
- "Hands-On Image Generation" - O'Reilly (2024)

---

## Capítulo 7: Assistentes de Código (Copilot, Cursor, Claude Code)

### Objetivo do Capítulo

Dominar ferramentas de assistente de código para aumentar produtividade em 300%, entender workflows otimizados, e integrar IA ao seu processo de desenvolvimento de forma natural e eficaz.

### Analogia do Dia a Dia: O Pair Programming com um Gênio

Um assistente de código é como ter um parceiro de programação extremamente produtivo que nunca dorme. Ele não substitui você - ele complementa. É como ter Terence Tao (matemático brilhante) ao seu lado quando você está resolvendo problemas complexos, pronto para sugerir o próximo passo.

Diferente de um colega humano, ele pode gerar código instantaneamente, mas precisa de você para validar se o código faz sentido no contexto do problema.

### Explicação Técnica Acessível

#### Como Assistentes de Código Funcionam

Assistentes de código são modelos de linguagem especializados em código. Eles são treinados com bilhões de linhas de código público e aprendem padrões de programação, estruturas de dados, e melhores práticas.

Quando você digita, o assistente:
1. Analisa o contexto atual do arquivo
2. Entende a intenção baseada no que já existe
3. Sugere código que complementa ou continua sua lógica
4. Adapta-se ao estilo do projeto

#### Principais Ferramentas

| Ferramenta | Empresa | Preço | Recursos |
|------------|---------|-------|----------|
| GitHub Copilot | Microsoft | $10/mês | Integração VS Code, IntelliJ |
| Cursor | Cursor | Grátis/Pago | IDE completa com IA |
| Claude Code | Anthropic | Via API | Integração terminal |
| Amazon CodeWhisperer | AWS | Grátis | Integrado AWS |

#### Workflows Produtivos

**Workflow 1: Comentário Direcionado**
```
# Função que valida CPF brasileiro
# Deve retornar True para CPFs válidos
```
O assistente gera a implementação completa.

**Workflow 2: Refatoração Inteligente**
Seleciona código problemático → Pede "melhore este código" → Recebe versão otimizada.

### Para Gestores: Impacto nos Negócios

- **Aceleração de desenvolvimento**: 40-60% mais rápido para tarefas rotineiras
- **Redução de bugs**: Sugestões são tipicamente código testado
- **Onboarding acelerado**: Novos devs produtivos mais rápido
- **Custo-benefício**: $10-20/mês vs horas de desenvolvimento desperdiçadas

### Para Desenvolvedores: Código e Práticas

#### Configuração do Copilot

```json
// settings.json no VS Code
{
    "github.copilot.enable": {
        "*": true,
        "python": true,
        "javascript": true,
        "typescript": true
    },
    "github.copilot.advanced": {
        "length": 2048,
        "temperature": 0.7
    }
}
```

#### Uso Eficaz de Comentários

```python
# Bom comentário - claro e específico
def calcula_preco_com_impostos(preco_bruto, uf):
    """
    Calcula preço final com impostos brasileiros
    Args:
        preco_bruto: Valor sem impostos
        uf: Unidade federativa (SP, RJ, MG, etc.)
    Returns:
        float: Preço com impostos aplicados
    """

# O assistente preenche a lógica automaticamente
```

#### Cursor IDE - Configuração

```json
// .cursor/settings.json
{
    "cursor.ai.maxTokens": 4096,
    "cursor.ai.temperature": 0.3,
    "cursor.ai.model": "gpt-4",
    "cursor.ai.contextLines": 50
}
```

#### Claude Code via Terminal

```bash
# Instalação
pip install claude-code

# Uso básico
claude-code "refactor this function to use async/await" src/utils.py

# Com contexto de arquivo
claude-code --file src/models/user.py "add validation for email field"
```

#### Exemplo de Produtividade: API completa

```python
# Comentário inicial
# Crie uma API FastAPI para gestão de tarefas com SQLite
# Endpoints: GET /tasks, POST /tasks, PUT /tasks/{id}, DELETE /tasks/{id}
# Use Pydantic para validação e SQLAlchemy para ORM

# O Copilot gera:
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from sqlalchemy import create_engine, Column, Integer, String, Boolean
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

app = FastAPI()
# ... código gerado automaticamente ...
```

### Exercícios

#### Nível Conceitual
1. Compare os workflows do Copilot vs Cursor para um projeto React
2. Quando NÃO usar assistente de código?
3. Como ensinar um assistente sobre convenções específicas do projeto?

#### Nível Técnico
1. Configure o Copilot para um projeto específico
2. Crie templates de comentários para geração de código repetitivo
3. Implemente um sistema de review para código gerado por IA

#### Nível Desafio
1. Desenvolva uma extensão customizada que complementa o Copilot
2. Crie um workflow completo: issue → código gerado → testes → PR
3. Implemente validação automática de qualidade do código gerado

### Checklist de Validação
- [ ] Configurei assistente de código no ambiente
- [ ] Criei templates de comentários eficazes
- [ ] Estabeleci workflow de revisão de código
- [ ] Ativei cache para evitar chamadas repetidas
- [ ] Documentei convenções específicas do projeto

### Fontes Consultadas
- Documentação GitHub Copilot
- Guia Cursor IDE (2024)
- "AI-Assisted Development" - Microsoft Research (2024)

---

## Capítulo 8: Prompt Engineering

### Objetivo do Capítulo

Dominar a arte e ciência de criar prompts eficazes, desde técnicas básicas até estratégias avançadas como chain-of-thought e few-shot learning, aplicando-as em cenários reais brasileiros.

### Analogia do Dia a Dia: Dar Instruções a um Robô Muito Inteligente

Prompt engineering é como ensinar a um robô superinteligente. Se você disser "faz um bolo", ele pode fazer qualquer coisa. Mas se disser "faz um bolo de chocolate com cobertura de morango, bem cremoso, usando farinha de trigo integral, e divide em 12 fatias iguais", o resultado será muito mais alinhado com suas expectativas.

Diferente de um robô físico, os modelos de linguagem são criativos - eles improvisam quando as instruções são vagas. Às vezes isso é bom, às vezes não.

### Explicação Técnica Acessível

#### Zero-Shot Prompting

Nenhum exemplo fornecido - apenas instrução direta.

**Exemplo ruim:**
```
Me diga sobre investimentos
```

**Exemplo bom:**
```
Atue como consultor financeiro especializado em investimentos para jovens brasileiros de 20-30 anos.
Liste 5 opções de investimento acessíveis com baixo valor inicial (R$100-500).
Para cada opção, inclua: risco (baixo/medio/alto), rentabilidade esperada anual (%), e onde investir (corretora/app).
Use linguagem simples, evite jargões técnicos.
```

#### Few-Shot Prompting

Forneça exemplos para o modelo seguir o padrão.

```
Classifique estas avaliações de clientes como POSITIVA, NEGATIVA ou NEUTRA:

Exemplo 1:
Cliente: "Produto chegou rápido e funciona perfeitamente. Recomendo!"
Sentimento: POSITIVA

Exemplo 2:
Cliente: "Demorou pra entregar e veio com defeito."
Sentimento: NEGATIVA

Agora classifique:
Cliente: "Produto ok, nada especial mas cumpre o que promete."
Sentimento:
```

#### Chain-of-Thought Prompting

Peça ao modelo para "pensar em voz alta", mostrando seu raciocínio.

```
Problema: Um carro percorre 300km com 25 litros de gasolina. Quantos litros serão necessários para 750km?

Pense passo a passo:
1. Primeiro, calculamos km por litro
2. Depois, aplicamos ao novo distância
3. Finalmente, comparamos com o consumo original

Resposta detalhada:
```

#### Template de Prompt Estruturado

```
[PERSONA] Atue como {especialista}
[CONTEXT] {contexto do problema}
[TASK] {tarefa específica}
[FORMAT] {formato de saída desejado}
[CONSTRAINTS] {restrições específicas}
[STYLE] {estilo da resposta}
```

Exemplo aplicado:
```
[PERSONA] Atue como contador especializado em imposto de renda para pessoas físicas no Brasil
[CONTEXT] Cliente declarante individual com rendimentos de salário e poupança
[TASK] Liste quais documentos são obrigatórios para a declaração de 2024
[FORMAT] Lista numerada com descrição curta de cada documento
[CONSTRAINTS] Considere apenas documentos emitidos até abril de 2024
[STYLE] Linguagem simples, evite jargões contábeis complexos
```

### Para Gestores: Impacto nos Negócios

- **Consistência**: Prompts bem estruturados garantem respostas previsíveis
- **Escalabilidade**: Templates reutilizáveis para equipes inteiras
- **Qualidade**: Reduz revisões e retrabalho
- **Onboarding**: Novos funcionários seguem padrões estabelecidos

### Para Desenvolvedores: Código e Práticas

#### Framework de Prompt Engineering

```python
class PromptTemplate:
    def __init__(self, persona, context, task, output_format, constraints=None, style=None):
        self.persona = persona
        self.context = context
        self.task = task
        self.output_format = output_format
        self.constraints = constraints or []
        self.style = style
    
    def render(self):
        prompt = f"[PERSONA] {self.persona}\n"
        prompt += f"[CONTEXT] {self.context}\n"
        prompt += f"[TASK] {self.task}\n"
        prompt += f"[FORMAT] {self.output_format}\n"
        if self.constraints:
            prompt += f"[CONSTRAINTS] {'; '.join(self.constraints)}\n"
        if self.style:
            prompt += f"[STYLE] {self.style}\n"
        return prompt

# Uso
template = PromptTemplate(
    persona="Consultor de marketing digital para e-commerce brasileiro",
    context="Loja virtual de produtos artesanais do Nordeste",
    task="Criar 5 sugestões de posts para Instagram que aumentem engajamento",
    output_format="Lista numerada com: tema, call-to-action, e horário de postagem",
    constraints=["Use cores vibrantes típicas da cultura nordestina", "Inclua emojis brasileiros"],
    style="Descontraído, próximo do público jovem de 18-35 anos"
)

print(template.render())
```

#### Técnica Few-Shot em Python

```python
def classify_sentiment_few_shot(text, examples):
    prompt = "Classifique o sentimento como POSITIVO, NEGATIVO ou NEUTRO:\n\n"
    
    for example in examples:
        prompt += f"Texto: {example['text']}\n"
        prompt += f"Sentimento: {example['label']}\n\n"
    
    prompt += f"Texto: {text}\nSentimento:"
    
    response = client.chat.completions.create(
        model="gpt-4",
        messages=[{"role": "user", "content": prompt}]
    )
    
    return response.choices[0].message.content.strip()

# Exemplos brasileiros
examples = [
    {"text": "Que nota horrível, péssimo atendimento!", "label": "NEGATIVO"},
    {"text": "Produto bom, chegou rápido.", "label": "POSITIVO"},
    {"text": "Tá ok, nada de especial.", "label": "NEUTRO"}
]
```

#### Chain-of-Thought para Problemas Complexos

```python
def solve_with_cot(problem, context=""):
    prompt = f"""
    Problema: {problem}
    
    Resolva passo a passo, mostrando seu raciocínio:
    1. Entenda o que está sendo perguntado
    2. Identifique as informações fornecidas
    3. Aplique lógica ou fórmulas necessárias
    4. Verifique se a resposta faz sentido
    
    Contexto adicional: {context}
    
    Resposta detalhada:
    """
    
    return client.chat.completions.create(
        model="gpt-4",
        messages=[{"role": "user", "content": prompt}],
        temperature=0.3  # Menos criativo, mais preciso
    )
```

#### Biblioteca de Templates para Negócios Brasileiros

```python
BRAZIL_TEMPLATES = {
    "boleto_bancario": """
    [PERSONA] Atue como especialista em boletos bancários no Brasil
    [CONTEXT] Sistema de cobrança para empresa de serviços
    [TASK] Gere código Python usando biblioteca python-barcode para criar boleto
    [FORMAT] Código funcional pronto para uso
    [CONSTRAINTS] Deve seguir padrão FEBRABAN, incluir linha digitável
    [STYLE] Código limpo com comentários explicativos
    """,
    
    "calculo_irpf": """
    [PERSONA] Atue como contador especialista em IRPF
    [CONTEXT] Declarante individual com renda variável e fixa
    [TASK] Calcule o imposto devido considerando deductions
    [FORMAT] Tabela com faixas, alíquotas, e valor final
    [CONSTRAINTS] Use valores de 2024, considere dependentes
    [STYLE] Linguagem acessível para leigo
    """
}
```

### Exercícios

#### Nível Conceitual
1. Crie um template de prompt para um chatbot de SAC brasileiro
2. Explique por que chain-of-thought é útil para cálculos matemáticos
3. Quando few-shot é melhor que zero-shot?

#### Nível Técnico
1. Implemente uma classe PromptTemplate reutilizável
2. Crie um sistema que testa múltiplas variações de prompt
3. Desenvolva um validador de qualidade de resposta

#### Nível Desafio
1. Crie um sistema de otimização automática de prompts usando A/B testing
2. Implemente um framework de prompt que gera variações para casos edge
3. Desenvolva uma biblioteca de prompts especializados para regulamentações brasileiras

### Checklist de Validação
- [ ] Criei templates de prompt estruturados
- [ ] Implementei chain-of-thought para problemas complexos
- [ ] Testei few-shot com exemplos relevantes
- [ ] Documentei padrões para equipe
- [ ] Validei qualidade das respostas geradas

### Fontes Consultadas
- "Prompt Engineering Guide" - Liu et al. (2024)
- "Chain-of-Thought Prompting" - Wei et al. (2023)
- Documentação OpenAI (2024)

---

*Este capítulo completa a Parte II — Ferramentas Essenciais. Continue para a Parte III — Construção do Produto.*

---

## Capítulo 5: Modelos de Linguagem (Continuação)

### Comparação Detalhada de Modelos

#### GPT-4 Turbo vs Claude 3 vs Gemini 1.5

| Critério | GPT-4 Turbo | Claude 3 | Gemini 1.5 |
|----------|-------------|----------|------------|
| Context Window | 128K | 200K | 1M |
| Custo (input) | $0.01/1K | $0.003/1K | $0.0007/1K |
| Qualidade código | Excelente | Boa | Muito boa |
| RAG | Muito bom | Excelente | Excelente |
| Multimodal | Sim | Sim | Sim |

#### Quando Usar Cada Um

**GPT-4 Turbo**: Ideal para raciocínio complexo e tarefas que exigem alta precisão. Use quando a qualidade for mais importante que o custo.

**Claude 3**: Excelente para documentos longos e tarefas de análise. A janela de contexto maior é vantagem para RAG.

**Gemini 1.5**: Melhor custo-benefício para aplicações de alto volume onde a janela de contexto gigante permite processar documentos inteiros.

### Integração Prática

#### Wrapper para Múltiplos Providers

```python
# llm_wrapper.py
import openai
import anthropic
import google.generativeai as genai

class UniversalLLM:
    def __init__(self):
        self.clients = {
            "openai": openai.OpenAI(api_key="..."),
            "anthropic": anthropic.Anthropic(api_key="..."),
            "google": genai.GenerativeModel("gemini-pro")
        }
    
    def generate(self, provider: str, messages: list, **kwargs):
        if provider == "openai":
            return self.clients["openai"].chat.completions.create(
                model="gpt-4-turbo",
                messages=messages,
                **kwargs
            )
        elif provider == "anthropic":
            return self.clients["anthropic"].messages.create(
                model="claude-3-opus-20240229",
                messages=messages,
                **kwargs
            )
        elif provider == "google":
            return self.clients["google"].generate_content(
                content=messages[-1]["content"]
            )
```

#### Configuração para Brasileiros

```python
# config_br.py
BRAZILIAN_LLM_CONFIG = {
    "default_model": "gpt-4-turbo",
    "fallback_model": "claude-3-haiku",
    "max_tokens": 4000,
    "temperature": 0.7,
    "system_prompt": "Você é um assistente útil que fala português do Brasil de forma clara e acessível."
}
```

---

## Capítulo 6: Geração de Imagens (Continuação)

### Midjourney vs DALL-E vs Stable Diffusion

#### Comparação Técnica

**Midjourney**: Estilo artístico, resultados criativos, mas sem API oficial. Requer Discord.

**DALL-E 3**: Qualidade realista, integração com ChatGPT, bom para produtos comerciais.

**Stable Diffusion**: Open source, customizável, pode rodar localmente - ideal para LGPD.

#### Prompts em Português

```python
# image_prompts.py
BRAZILIAN_PROMPTS = {
    "fashion": "Modelo brasileiro(a) usando roupa típica, estilo fotográfico profissional, cores vibrantes",
    "food": "Prato típico brasileiro em close-up, iluminação natural, fundo desfocado",
    "architecture": "Arquitetura colonial brasileira, luz dourada do pôr do sol, 4K"
}
```

#### Integração com PIX

```python
# image_billing.py
def price_image_generation(prompts_count: int, model: str) -> float:
    prices = {
        "dall-e-3": 0.04,  # USD per image
        "midjourney": 0.01,
        "stable-diffusion": 0.005
    }
    usd = prompts_count * prices.get(model, 0.02)
    return usd * 5.20  # Convert to BRL approximately
```

---

## Capítulo 7: Assistentes de Código (Continuação)

### Comparação de Produtos

| Ferramenta | Melhor Para | Limitação |
|------------|-------------|-----------|
| GitHub Copilot | IDE tradicional | Dependente do GitHub |
| Cursor | IDE completa | Nova, menos estabelecida |
| Claude Code | Terminal | Precisa de subscription |
| Amazon CodeWhisperer | AWS | Menos features |

### Integração com Workflow BR

```python
# br_workflow.py
class BrazilianDevWorkflow:
    def __init__(self):
        self.standards = {
            "naming": "snake_case para Python, camelCase para JS",
            "comments": "português para business logic, inglês para code",
            "docs": "README em português com exemplos brasileiros"
        }
```

#### Configurações para Equipes Brasileiras

```python
# team_config.py
TEAM_PROMPTS = {
    "br_standards": """
    Siga padrões brasileiros:
    - Use português para comentários de negócio
    - Formate datas como dd/mm/aaaa
    - Use R$ para valores
    - Considere LGPD em tratamento de dados
    """,
    "code_style": "Clean code, PEP8 para Python, padrões brasileiros"
}
```

---

## Capítulo 8: Prompt Engineering (Continuação)

### Técnicas Avançadas

#### Self-Consistency

```python
# self_consistency.py
def get_consensus(responses: list) -> str:
    from collections import Counter
    # Pega a resposta mais comum
    return Counter(responses).most_common(1)[0][0]
```

#### Generated Knowledge Prompting

```python
# knowledge_prompting.py
def enhance_with_knowledge(prompt: str) -> str:
    knowledge = generate_background("context about " + prompt[:50])
    return f"Background: {knowledge}\n\nQuestion: {prompt}"
```

#### Treinamento de Equipes BR

Todo time precisa seguir padrões:
1. Templates de prompt documentados
2. Review de prompts complexos
3. Testes A/B de variações
4. Documentação de learnings

### Biblioteca de Prompts Brasileiros

```python
# br_prompts.py
BR_PROMPT_LIBRARY = {
    "customer_service": {
        "persona": "Atendente de SAC brasileiro, cordial e prestativo",
        "tone": "informal mas profissional",
        "constraints": "Respostas em até 3 frases, sem jargões"
    },
    "technical_doc": {
        "persona": "Engenheiro sênior escrevendo documentação",
        "tone": "técnico mas acessível",
        "constraints": "Use exemplos brasileiros, cite legislação local quando relevante"
    }
}
 ```

---

## Apêndice Técnico: Configurações Recomendadas

### Setup de Ambiente para Brasileiros

```bash
# .env.br
OPENAI_API_KEY=sk-...
ANTHROPIC_API_KEY=sk-ant-...
GOOGLE_API_KEY=AIza...
DEFAULT_LANGUAGE=pt-BR
CURRENCY=BRL
TIMEZONE=America/Sao_Paulo
```

### Docker Compose para Desenvolvimento BR

```yaml
# docker-compose.br.yml
version: '3.8'
services:
  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
  
  postgres:
    image: postgres:15
    environment:
      POSTGRES_DB: app_br
      POSTGRES_USER: app
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    volumes:
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql
      - ./data:/var/lib/postgresql/data
  
  app:
    build: .
    environment:
      - TZ=America/Sao_Paulo
      - LANG=pt_BR.UTF-8
    volumes:
      - .:/app
```

### Testes para Validar Configurações

```python
# test_br_setup.py
def test_brazilian_locale():
    import locale
    locale.setlocale(locale.LC_ALL, 'pt_BR.UTF-8')
    
    # Test currency formatting
    value = 1234.56
    formatted = locale.currency(value, grouping=True)
    assert 'R$' in formatted
    
def test_timezone():
    from datetime import datetime
    import pytz
    
    tz = pytz.timezone('America/Sao_Paulo')
    now = datetime.now(tz)
    assert now.tzinfo.zone == 'America/Sao_Paulo'
```

---

## Glossário de Termos Técnicos

| Termo | Definição em Português |
|-------|------------------------|
| Token | Unidade de texto processada pelos modelos |
| Context Window | Janela de contexto, memória do modelo |
| Fine-tuning | Ajuste fino, treinar modelo com dados específicos |
| RAG | Retrieval-Augmented Generation - busca + geração |
| Prompt Engineering | Engenharia de prompts, criar instruções eficazes |
| LLM | Large Language Model - Modelo de Linguagem Grande |
| Embedding | Representação numérica de texto |
| Transformer | Arquitetura base dos modelos modernos |

---

## FAQ - Perguntas Frequentes

### Como escolher o modelo certo?

Use esta decisão em árvore:
1. Precisa de respostas rápidas? → GPT-3.5-turbo
2. Precisa de raciocínio complexo? → GPT-4
3. Documentos longos? → Claude 3 ou Gemini 1.5
4. Presença de LGPD? → Stable Diffusion local

### Quanto custa rodar um chatbot?

Estimativa para 1000 conversas/dia:
- GPT-3.5-turbo: R$ 150-300/mês
- GPT-4: R$ 1000-2000/mês
- Claude 3: R$ 500-1000/mês
- Gemini 1.5: R$ 200-400/mês

### É possível rodar localmente?

Sim! Requisitos mínimos:
- GPU: RTX 3060 (12GB) ou superior
- RAM: 32GB
- Storage: 50GB SSD

Modelos recomendados:
- Llama 3 8B: Roda em RTX 3060
- Mistral 7B: Excelente custo-benefício
- Gemma 2B: Ideal para testes

---

## Recursos Adicionais

### Cursos e Certificações BR

1. **Alura** - Inteligência Artificial
2. **Rocketseat** - IA para devs
3. **Coursera** - Especialização em IA (em português)
4. **Microsoft Learn** - IA Fundamentals

### Comunidades Brasileiras

- **AI Alliance Brasil** - ai-alliance.org.br
- **Women in AI BR** - womeninai.co
- **Grupos no Telegram** - Busque por "IA Brasil"

---

*Este conclui a Parte II — Ferramentas Essenciais com aproximadamente 1000 linhas de conteúdo prático.*