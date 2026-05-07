const db = require('../database/db');

// POST /categories
exports.create = (req, res) => {
  const { name, type } = req.body;

  if (!name || !type) {
    return res.status(400).json({ error: 'name e type são obrigatórios' });
  }
  if (!['income', 'expense'].includes(type)) {
    return res.status(400).json({ error: "type deve ser 'income' ou 'expense'" });
  }

  db.run(
    `INSERT INTO categories (name, type, user_id) VALUES (?, ?, ?)`,
    [name, type, req.userId],
    function (err) {
      if (err) return res.status(500).json({ error: err.message });
      res.status(201).json({
        id: this.lastID,
        name,
        type,
        user_id: req.userId
      });
    }
  );
};

// GET /categories
exports.list = (req, res) => {
  const { type } = req.query;

  let sql = `SELECT * FROM categories WHERE user_id = ?`;
  const params = [req.userId];

  if (type) {
    sql += ` AND type = ?`;
    params.push(type);
  }

  sql += ` ORDER BY name ASC`;

  db.all(sql, params, (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(rows);
  });
};

// DELETE /categories/:id
exports.remove = (req, res) => {
  const { id } = req.params;

  db.run(
    `DELETE FROM categories WHERE id = ? AND user_id = ?`,
    [id, req.userId],
    function (err) {
      if (err) return res.status(500).json({ error: err.message });
      if (this.changes === 0) {
        return res.status(404).json({ error: 'Categoria não encontrada' });
      }
      res.status(204).send();
    }
  );
};
