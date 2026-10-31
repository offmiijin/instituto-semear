# Instituto Semear — site institucional

Projeto do **Projeto Integrador Extensionista II** para a ONG Instituto Semear.
Aplicação **Vite (vanilla JavaScript)** com uma **API Express** que expõe a rota
`GET /api/health`; a página inicial consome essa rota através do proxy `/api` do
Vite e exibe o status retornado pela API.

## Tecnologias

- [Vite](https://vite.dev/) 8 — servidor de desenvolvimento e build
- JavaScript (ES Modules) e CSS puros
- [Express](https://expressjs.com/) 5 — API HTTP
- [dotenv](https://github.com/motdotla/dotenv) — leitura das variáveis do `.env`

## Estrutura do projeto

```
.
├── index.html          # entrada do Vite
├── vite.config.ts      # porta 5173 e proxy /api -> API Express
├── src/
│   ├── main.js         # consome /api/health e monta a página
│   └── style.css       # estilos da página
├── server/
│   └── index.js        # API Express com GET /api/health
├── .env.example        # modelo das variáveis de ambiente
└── package.json        # scripts e dependências
```

## Pré-requisitos

- [Node.js](https://nodejs.org/) 20 ou superior (testado com Node 26)
- npm (acompanha o Node.js)

## Como rodar o projeto

1. Clone o repositório e entre na pasta:

   ```bash
   git clone https://github.com/seu-usuario/instituto-semear.git
   cd instituto-semear
   ```

2. Instale as dependências:

   ```bash
   npm install
   ```

3. Crie o arquivo `.env` a partir do modelo (a porta padrão da API é `3001`):

   ```bash
   cp .env.example .env
   ```

4. Suba a **API** em um terminal:

   ```bash
   npm run api
   ```

   Saída esperada: `API disponível em http://localhost:3001/api/health`

5. Suba o **front-end** em outro terminal:

   ```bash
   npm run dev
   ```

6. Acesse <http://localhost:5173>. A página deve mostrar:

   ```
   Status da API: ok
   Resposta recebida em 31/10/2025 11:58:57 (servidor: instituto-semear-api)
   ```

## Variáveis de ambiente

| Variável | Padrão | Descrição                                        |
| -------- | ------ | ------------------------------------------------ |
| `PORT`   | `3001` | Porta da API Express (usada também pelo proxy)   |

O arquivo `.env` está no `.gitignore`; apenas o `.env.example` é versionado.

## Endpoints da API

| Método | Rota          | Resposta                                                              |
| ------ | ------------- | --------------------------------------------------------------------- |
| GET    | `/api/health` | `{ "status": "ok", "service": "instituto-semear-api", "timestamp": "..." }` |

A rota é acessada pelo front-end em `/api/health`; o Vite encaminha a chamada
para o servidor Express definido em `PORT` (proxy configurado em `vite.config.ts`).

## Scripts

| Script           | Descrição                                             |
| ---------------- | ----------------------------------------------------- |
| `npm run dev`    | Sobe o servidor de desenvolvimento do Vite (porta 5173) |
| `npm run api`    | Sobe a API Express (porta definida em `PORT`)          |
| `npm run build`  | Gera o build de produção em `dist/`                    |
| `npm run preview`| Serve o build de produção localmente                   |

## Testando a API manualmente

Com a API rodando:

```bash
curl http://localhost:3001/api/health
```

Resposta esperada:

```json
{
  "status": "ok",
  "service": "instituto-semear-api",
  "timestamp": "2025-10-31T14:58:57.798Z"
}
```

## Sobre a ONG

O Instituto Semear apoia crianças e adolescentes com reforço escolar, oficinas
de cultura e acompanhamento das famílias na comunidade.
