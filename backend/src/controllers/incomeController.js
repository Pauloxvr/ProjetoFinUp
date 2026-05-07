const db = require('../database/db');

// POST /incomes
exports.create = (req, res) => {
  const { amount, description, date, category_id } = req.body;

  if (amount === undefined || amount === null || !date) {
    return res.status(400).json({ error: 'amount e date são obrigatórios' });
  }
  if (typeof amount !== 'number' || amount <= 0) {
    return res.status(400).json({ error: 'amount deve ser um número positivo' });
  }

  db.run(
    `INSERT INTO incomes (amount, description, date, category_id, user_id)
     VALUES (?, ?, ?, ?, ?)`,
    [amount, description || null, date, category_id || null, req.userId],
    function (err) {
      if (err) return res.status(500).json({ error: err.message });
      res.status(201).json({
        id: this.lastID,
        amount,
        description: description || null,
        date,
        category_id: category_id || null,
        user_id: req.userId
      });
    }
  );
};

// GET /incomes
exports.list = (req, res) => {
  db.all(
    `SELECT i.*, c.name AS category_name
     FROM incomes i
     LEFT JOIN categories c ON c.id = i.category_id
     WHERE i.user_id = ?
     ORDER BY i.date DESC, i.id DESC`,
    [req.userId],
    (err, rows) => {
      if (err) return res.status(500).json({ error: err.message });
      res.json(rows);
    }
  );
};

// DELETE /incomes/:id
exports.remove = (req, res) => {
  const { id } = req.params;

  db.run(
    `DELETE FROM incomes WHERE id = ? AND user_id = ?`,
    [id, req.userId],
    function (err) {
      if (err) return res.status(500).json({ error: err.message });
      if (this.changes === 0) {
        return res.status(404).json({ error: 'Receita não encontrada' });
      }
      res.status(204).send();
    }
  );
};
