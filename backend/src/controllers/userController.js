const bcrypt = require('bcrypt');
const db = require('../database/db');

// POST /users - cadastrar novo usuário
exports.create = async (req, res) => {
  const { name, email, password } = req.body;

  // validação de campos obrigatórios
  if (!name || !email || !password) {
    return res.status(400).json({
      error: 'Os campos name, email e password são obrigatórios'
    });
  }

  // validação simples de email
  if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
    return res.status(400).json({ error: 'Email inválido' });
  }

  // validação de tamanho mínimo da senha
  if (password.length < 6) {
    return res.status(400).json({
      error: 'A senha deve ter pelo menos 6 caracteres'
    });
  }

  try {
    const hashedPassword = await bcrypt.hash(password, 10);

    db.run(
      `INSERT INTO users (name, email, password) VALUES (?, ?, ?)`,
      [name, email, hashedPassword],
      function (err) {
        if (err) {
          if (err.message.includes('UNIQUE')) {
            return res.status(409).json({ error: 'Email já cadastrado' });
          }
          return res.status(500).json({ error: err.message });
        }

        res.status(201).json({
          id: this.lastID,
          name,
          email
        });
      }
    );
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// GET /users/me - dados do usuário logado
exports.me = (req, res) => {
  db.get(
    `SELECT id, name, email, created_at FROM users WHERE id = ?`,
    [req.userId],
    (err, row) => {
      if (err) return res.status(500).json({ error: err.message });
      if (!row) return res.status(404).json({ error: 'Usuário não encontrado' });
      res.json(row);
    }
  );
};
