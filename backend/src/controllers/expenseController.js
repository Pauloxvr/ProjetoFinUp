const db = require('../database/db');

// POST /expenses
exports.create = (req, res) => {
  const { amount, description, date, category_id } = req.body;

  if (amount === undefined || amount === null || !date || !category_id) {
    return res.status(400).json({
      error: 'amount, date e category_id são obrigatórios'
    });
  }
  if (typeof amount !== 'number' || amount <= 0) {
    return res.status(400).json({ error: 'amount deve ser um número positivo' });
  }

  db.run(
    `INSERT INTO expenses (amount, description, date, category_id, user_id)
     VALUES (?, ?, ?, ?, ?)`,
    [amount, description || null, date, category_id, req.userId],
    function (err) {
      if (err) return res.status(500).json({ error: err.message });
      res.status(201).json({
        id: this.lastID,
        amount,
        description: description || null,
        date,
        category_id,
        user_id: req.userId
      });
    }
  );
};

// GET /expenses
exports.list = (req, res) => {
  db.all(
    `SELECT e.*, c.name AS category_name
     FROM expenses e
     LEFT JOIN categories c ON c.id = e.category_id
     WHERE e.user_id = ?
     ORDER BY e.date DESC, e.id DESC`,
    [req.userId],
    (err, rows) => {
      if (err) return res.status(500).json({ error: err.message });
      res.json(rows);
    }
  );
};

// DELETE /expenses/:id
exports.remove = (req, res) => {
  const { id } = req.params;

  db.run(
    `DELETE FROM expenses WHERE id = ? AND user_id = ?`,
    [id, req.userId],
    function (err) {
      if (err) return res.status(500).json({ error: err.message });
      if (this.changes === 0) {
        return res.status(404).json({ error: 'Despesa não encontrada' });
      }
      res.status(204).send();
    }
  );
};
