# Backend FinUp

API REST em Node.js, Express e SQLite.

## Rodando

```powershell
npm install
npm start
```

Servidor:

```text
http://localhost:3000
```

## Variáveis

Use `.env`:

```text
PORT=3000
JWT_SECRET=troque_esta_chave
JWT_EXPIRES_IN=7d
```

## Rotas

### Autenticação e usuário

- `POST /users`: cria usuário.
- `POST /auth/login`: login.
- `GET /users/me`: dados do usuário logado.
- `PATCH /users/me`: atualiza nome/senha.

Ao criar usuário, a API também cria categorias padrão de receita e despesa.

### Categorias

- `GET /categories`
- `POST /categories`
- `PATCH /categories/:id`
- `DELETE /categories/:id`

### Receitas

- `GET /incomes`
- `POST /incomes`
- `PATCH /incomes/:id`
- `DELETE /incomes/:id`

### Despesas

- `GET /expenses`
- `POST /expenses`
- `PATCH /expenses/:id`
- `DELETE /expenses/:id`

### Metas

- `GET /goals`
- `POST /goals`
- `PATCH /goals/:id`
- `DELETE /goals/:id`

### Dashboard

- `GET /dashboard`

## Autenticação

Rotas protegidas usam:

```text
Authorization: Bearer <token>
```

