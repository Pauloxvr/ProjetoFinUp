const bcrypt = require('bcrypt');
const db = require('../database/db');
const { validateEmail, validatePassword, validateString } = require('../utils/validators');

// POST /users - cadastrar novo usuário
exports.create = async (req, res) => {
  const { name, email, password } = req.body;

  // validação de campos obrigatórios
  if (!name || !email || !password) {
    return res.status(400).json({
      error: 'Os campos name, email e password são obrigatórios'
    });
  }

  // validação de email
  if (!validateEmail(email)) {
    return res.status(400).json({ error: 'Email inválido' });
  }

  // validação de senha
  if (!validatePassword(password)) {
    return res.status(400).json({
      error: 'A senha deve ter entre 6 e 100 caracteres'
    });
  }

  // validação de nome
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
        const defaultCategories = [
          { name: 'Salário', type: 'income' },
          { name: 'Investimentos', type: 'income' },
          { name: 'Freelance', type: 'income' },
          { name: 'Alimentação', type: 'expense' },
          { name: 'Transporte', type: 'expense' },
          { name: 'Saúde', type: 'expense' },
          { name: 'Lazer', type: 'expense' },
        ];

        defaultCategories.forEach((category) => {
          db.run(
            `INSERT INTO categories (name, type, user_id) VALUES (?, ?, ?)`,
            [category.name, category.type, userId],
            (categoryErr) => {
              if (categoryErr) {
                console.error('Erro ao criar categoria padrão:', categoryErr.message);
              }
            }
          );
        });

        res.status(201).json({
          id: userId,
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

// PATCH /users/me - atualizar dados do usuário logado
exports.update = async (req, res) => {
  const { name, password } = req.body;

  const fields = [];
  const params = [];

  if (name !== undefined) {
    if (typeof name !== 'string' || name.trim().length < 2 || name.length > 100) {
      return res.status(400).json({ error: 'Nome deve ter entre 2 e 100 caracteres' });
    }
    fields.push('name = ?');
    params.push(name);
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
