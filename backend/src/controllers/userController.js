const bcrypt = require('bcrypt');
const db = require('../database/db');
const { validateEmail, validatePassword, validateString } = require('../utils/validators');

const defaultCategories = [
  { name: 'Salário', type: 'income' },
  { name: 'Investimentos', type: 'income' },
  { name: 'Freelance', type: 'income' },
  { name: 'Alimentação', type: 'expense' },
  { name: 'Transporte', type: 'expense' },
  { name: 'Moradia', type: 'expense' },
  { name: 'Saúde', type: 'expense' },
  { name: 'Lazer', type: 'expense' },
];

function createDefaultCategories(userId, callback) {
  const stmt = db.prepare(
    `INSERT INTO categories (name, type, user_id) VALUES (?, ?, ?)`
  );
  let pending = defaultCategories.length;
  let failed = false;

  defaultCategories.forEach((category) => {
    stmt.run([category.name, category.type, userId], (err) => {
      if (failed) return;
      if (err) {
        failed = true;
        stmt.finalize();
        callback(err);
        return;
      }

      pending -= 1;
      if (pending === 0) {
        stmt.finalize(callback);
      }
    });
  });
}

exports.create = async (req, res) => {
  const { name, email, password } = req.body;

  if (!name || !email || !password) {
    return res.status(400).json({
      error: 'Os campos name, email e password são obrigatórios'
    });
  }

  if (!validateEmail(email)) {
    return res.status(400).json({ error: 'Email inválido' });
  }

  if (!validatePassword(password)) {
    return res.status(400).json({
      error: 'A senha deve ter entre 6 e 100 caracteres'
    });
  }

  if (!validateString(name, 2, 100)) {
    return res.status(400).json({
      error: 'O nome deve ter entre 2 e 100 caracteres'
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

        const userId = this.lastID;
        createDefaultCategories(userId, (categoryErr) => {
          if (categoryErr) {
            return res.status(500).json({ error: categoryErr.message });
          }

          res.status(201).json({
            id: userId,
            name,
            email
          });
        });
      }
    );
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

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

exports.update = async (req, res) => {
  const { name, password } = req.body;

  const fields = [];
  const params = [];

  if (name !== undefined) {
    if (typeof name !== 'string' || name.trim().length < 2 || name.length > 100) {
      return res.status(400).json({ error: 'Nome deve ter entre 2 e 100 caracteres' });
    }
    fields.push('name = ?');
    params.push(name.trim());
  }

  if (password !== undefined) {
    if (password.length < 6 || password.length > 100) {
      return res.status(400).json({ error: 'Senha deve ter entre 6 e 100 caracteres' });
    }
    try {
      const hashedPassword = await bcrypt.hash(password, 10);
      fields.push('password = ?');
      params.push(hashedPassword);
    } catch (err) {
      return res.status(500).json({ error: 'Erro ao processar senha' });
    }
  }

  if (fields.length === 0) {
    return res.status(400).json({ error: 'Nenhum campo para atualizar' });
  }

  params.push(req.userId);

  db.run(
    `UPDATE users SET ${fields.join(', ')} WHERE id = ?`,
    params,
    function (err) {
      if (err) return res.status(500).json({ error: err.message });
      res.json({ message: 'Perfil atualizado com sucesso' });
    }
  );
};

