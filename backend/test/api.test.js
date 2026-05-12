const test = require('node:test');
const assert = require('node:assert/strict');
require('dotenv').config();
const app = require('../src/app');

const PORT = 3100 + Math.floor(Math.random() * 1000);
const BASE_URL = `http://localhost:${PORT}`;

let server;

test.before(() => {
  server = app.listen(PORT);
});

test.after(() => {
  server.close();
});

async function request(path, options = {}) {
  const response = await fetch(`${BASE_URL}${path}`, {
    ...options,
    headers: {
      'Content-Type': 'application/json',
      ...(options.headers || {}),
    },
  });

  const text = await response.text();
  const body = text ? JSON.parse(text) : null;
  return { response, body };
}

test('cadastro cria categorias padrão e permite editar lançamentos', async () => {
  const email = `test-${Date.now()}@finup.local`;

  const created = await request('/users', {
    method: 'POST',
    body: JSON.stringify({
      name: 'Teste FinUp',
      email,
      password: '123456',
    }),
  });
  assert.equal(created.response.status, 201);

  const login = await request('/auth/login', {
    method: 'POST',
    body: JSON.stringify({ email, password: '123456' }),
  });
  assert.equal(login.response.status, 200);
  assert.ok(login.body.token);

  const authHeaders = {
    Authorization: `Bearer ${login.body.token}`,
  };

  const categories = await request('/categories', { headers: authHeaders });
  assert.equal(categories.response.status, 200);
  assert.equal(categories.body.length, 8);

  const incomeCategory = categories.body.find((c) => c.type === 'income');
  const expenseCategory = categories.body.find((c) => c.type === 'expense');
  assert.ok(incomeCategory);
  assert.ok(expenseCategory);

  const income = await request('/incomes', {
    method: 'POST',
    headers: authHeaders,
    body: JSON.stringify({
      amount: 100,
      description: 'Receita teste',
      date: '2026-05-12',
      category_id: incomeCategory.id,
    }),
  });
  assert.equal(income.response.status, 201);

  const updatedIncome = await request(`/incomes/${income.body.id}`, {
    method: 'PATCH',
    headers: authHeaders,
    body: JSON.stringify({
      amount: 150,
      description: 'Receita editada',
    }),
  });
  assert.equal(updatedIncome.response.status, 200);

  const expense = await request('/expenses', {
    method: 'POST',
    headers: authHeaders,
    body: JSON.stringify({
      amount: 50,
      description: 'Despesa teste',
      date: '2026-05-12',
      category_id: expenseCategory.id,
    }),
  });
  assert.equal(expense.response.status, 201);

  const updatedExpense = await request(`/expenses/${expense.body.id}`, {
    method: 'PATCH',
    headers: authHeaders,
    body: JSON.stringify({
      amount: 75,
      description: 'Despesa editada',
      category_id: expenseCategory.id,
    }),
  });
  assert.equal(updatedExpense.response.status, 200);
});
