# FinUp

Aplicativo acadêmico de controle financeiro pessoal com frontend Flutter, API Node.js/Express e banco SQLite.

## Funcionalidades

- Cadastro, login e sessão com JWT.
- Categorias padrão criadas automaticamente para novos usuários.
- Cadastro, listagem, edição e remoção de receitas e despesas.
- Metas financeiras.
- Dashboard com saldo, entradas, saídas e gráficos.
- Histórico com filtros por período.
- Perfil com estatísticas reais de lançamentos, metas e economia.

## Stack

- Frontend: Flutter/Dart
- Backend: Node.js, Express
- Banco: SQLite
- Gráficos: fl_chart

## Como Rodar

### Backend

```powershell
cd backend
npm install
npm start
```

A API fica disponível em:

```text
http://localhost:3000
```

Healthcheck:

```powershell
Invoke-RestMethod http://localhost:3000/
```

### Frontend

Instale o Flutter SDK e garanta que o comando `flutter` esteja no PATH.

```powershell
cd frontend
flutter pub get
flutter run -d chrome --dart-define=API_URL=http://localhost:3000
```

Para validar:

```powershell
flutter analyze
flutter test
```

## Endpoints Principais

- `POST /users`: cria usuário e categorias padrão.
- `POST /auth/login`: autentica e retorna token.
- `GET /users/me`: usuário logado.
- `GET/POST/PATCH/DELETE /categories`
- `GET/POST/PATCH/DELETE /incomes`
- `GET/POST/PATCH/DELETE /expenses`
- `GET/POST/PATCH/DELETE /goals`
- `GET /dashboard`

Rotas protegidas exigem:

```text
Authorization: Bearer <token>
```

## Observações

O frontend usa `API_URL` via `--dart-define`. Se não for informado, usa `http://localhost:3000`.

Em Android emulator, normalmente a API local deve ser acessada por `http://10.0.2.2:3000`.

