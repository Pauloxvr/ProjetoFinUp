# Backend - API Financeira

API REST em Node.js + Express + SQLite com autenticação JWT.

## Como rodar

```bash
# 1. Instalar dependências
npm install

# 2. Copiar o .env de exemplo (já vem um .env pronto para dev)
cp .env.example .env

# 3. Rodar em modo de desenvolvimento (auto-reload ao salvar)
npm run dev

# OU rodar em modo normal
npm start
```

O servidor sobe em `http://localhost:3000`.

## Estrutura

```
backend/
├── server.js                 # entrada da aplicação
├── .env                      # variáveis de ambiente (não commitar!)
├── .env.example              # template do .env
└── src/
    ├── app.js                # configuração do Express
    ├── database/
    │   └── db.js             # conexão e schema do SQLite
    ├── controllers/          # lógica de negócio
    ├── middlewares/
    │   └── authMiddleware.js # validação do JWT
    └── routes/               # definição das rotas
```

## Endpoints

### Autenticação

| Método | Rota | Descrição | Auth |
|--------|------|-----------|------|
| POST | `/users` | Cadastrar usuário | ❌ |
| POST | `/auth/login` | Login (retorna token) | ❌ |
| GET | `/users/me` | Dados do usuário logado | ✅ |

### Categorias (`/categories`)

| Método | Rota | Descrição |
|--------|------|-----------|
| POST | `/` | Criar categoria |
| GET | `/` | Listar (use `?type=income` ou `?type=expense` para filtrar) |
| DELETE | `/:id` | Deletar |

### Receitas (`/incomes`) e Despesas (`/expenses`)

| Método | Rota | Descrição |
|--------|------|-----------|
| POST | `/` | Criar |
| GET | `/` | Listar |
| DELETE | `/:id` | Deletar |

### Metas (`/goals`)

| Método | Rota | Descrição |
|--------|------|-----------|
| POST | `/` | Criar meta |
| GET | `/` | Listar metas |
| PATCH | `/:id` | Atualizar (title, target_amount, current_amount) |
| DELETE | `/:id` | Deletar |

## Como autenticar

Todas as rotas protegidas exigem o header:

```
Authorization: Bearer <token>
```

O token você obtém ao fazer login.

## Exemplos com cURL

### 1. Cadastro

```bash
curl -X POST http://localhost:3000/users \
  -H "Content-Type: application/json" \
  -d '{"name":"João","email":"joao@email.com","password":"123456"}'
```

### 2. Login

```bash
curl -X POST http://localhost:3000/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"joao@email.com","password":"123456"}'
```

Resposta:
```json
{
  "token": "eyJhbGciOiJI...",
  "user": { "id": 1, "name": "João", "email": "joao@email.com" }
}
```

### 3. Criar categoria (autenticado)

```bash
curl -X POST http://localhost:3000/categories \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer SEU_TOKEN_AQUI" \
  -d '{"name":"Alimentação","type":"expense"}'
```

### 4. Criar despesa

```bash
curl -X POST http://localhost:3000/expenses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer SEU_TOKEN_AQUI" \
  -d '{"amount":120.50,"description":"Mercado","date":"2026-05-04","category_id":1}'
```

## Próximos passos sugeridos

- [ ] Criar endpoint de resumo (`GET /dashboard`) com totais agregados
- [ ] Adicionar paginação nas listagens
- [ ] Adicionar testes (Jest + Supertest)
- [ ] Configurar CORS para o frontend Flutter consumir
