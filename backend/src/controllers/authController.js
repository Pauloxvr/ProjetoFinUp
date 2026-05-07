const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const db = require('../database/db');

// POST /auth/login
exports.login = (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({
      error: 'Email e password são obrigatórios'
    });
  }

  db.get(
    `SELECT * FROM users WHERE email = ?`,
    [email],
    async (err, user) => {
      if (err) return res.status(500).json({ error: err.message });
      if (!user) {
        return res.status(401).json({ error: 'Email ou senha inválidos' });
      }

      try {
        const isValid = await bcrypt.compare(password, user.password);
        if (!isValid) {
          return res.status(401).json({ error: 'Email ou senha inválidos' });
        }

        const token = jwt.sign(
          { id: user.id, email: user.email },
          process.env.JWT_SECRET,
          { expiresIn: process.env.JWT_EXPIRES_IN || '7d' }
        );

        res.json({
          token,
          user: {
            id: user.id,
            name: user.name,
            email: user.email
          }
        });
      } catch (e) {
        res.status(500).json({ error: e.message });
      }
    }
  );
};
