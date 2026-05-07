const express = require('express');
const cors = require('cors');
const app = express();

// importa o banco (executa criação das tabelas)
require('./database/db');

// middlewares globais
app.use(cors({
  origin: ['http://localhost:3000', 'http://127.0.0.1:3000', 'http://localhost:53795', 'http://127.0.0.1:53795', 'http://localhost:62199', 'http://127.0.0.1:62199'],
  credentials: true,
  methods: ['GET', 'POST', 'PATCH', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization']
})); // configuração CORS para desenvolvimento
app.use(express.json());

// rota de healthcheck
app.get('/', (req, res) => {
  res.json({ status: 'ok', message: 'API rodando 🚀' });
});

// importar rotas
const userRoutes = require('./routes/userRoutes');
const authRoutes = require('./routes/authRoutes');
const categoryRoutes = require('./routes/categoryRoutes');
const incomeRoutes = require('./routes/incomeRoutes');
const expenseRoutes = require('./routes/expenseRoutes');
const goalRoutes = require('./routes/goalRoutes');
const dashboardRoutes = require('./routes/dashboardRoutes');

// registrar rotas com prefixo
app.use('/users', userRoutes);
app.use('/auth', authRoutes);
app.use('/categories', categoryRoutes);
app.use('/incomes', incomeRoutes);
app.use('/expenses', expenseRoutes);
app.use('/goals', goalRoutes);
app.use('/dashboard', dashboardRoutes);

// middleware 404 (rota não encontrada)
app.use((req, res) => {
  res.status(404).json({ error: 'Rota não encontrada' });
});

// middleware de tratamento de erro genérico
app.use((err, req, res, next) => {
  console.error(err);
  res.status(500).json({ error: 'Erro interno do servidor' });
});

module.exports = app;
