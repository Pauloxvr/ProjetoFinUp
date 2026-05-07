const db = require('../database/db');

// POST /goals
exports.create = (req, res) => {
  const { title, target_amount, current_amount } = req.body;

  if (!title || target_amount === undefined || target_amount === null) {
    return res.status(400).json({
      error: 'title e target_amount são obrigatórios'
    });
  }
  if (typeof target_amount !== 'number' || target_amount <= 0) {
    return res.status(400).json({
      error: 'target_amount deve ser um número positivo'
    });
  }

  db.run(
    `INSERT INTO goals (title, target_amount, current_amount, user_id)
     VALUES (?, ?, ?, ?)`,
    [title, target_amount, current_amount || 0, req.userId],
    function (err) {
      if (err) return res.status(500).json({ error: err.message });
      res.status(201).json({
        id: this.lastID,
        title,
        target_amount,
        current_amount: current_amount || 0,
        user_id: req.userId
      });
    }
  );
};

// GET /goals
exports.list = (req, res) => {
  db.all(
    `SELECT * FROM goals WHERE user_id = ? ORDER BY created_at DESC`,
    [req.userId],
    (err, rows) => {
      if (err) return res.status(500).json({ error: err.message });
      res.json(rows);
    }
  );
};

// PATCH /goals/:id - atualiza progresso (current_amount)
exports.update = (req, res) => {
  const { id } = req.params;
  const { current_amount, title, target_amount } = req.body;

  const fields = [];
  const params = [];

  if (current_amount !== undefined) {
    fields.push('current_amount = ?');
    params.push(current_amount);
  }
  if (title !== undefined) {
    fields.push('title = ?');
    params.push(title);
  }
  if (target_amount !== undefined) {
    fields.push('target_amount = ?');
    params.push(target_amount);
  }

  if (fields.length === 0) {
    return res.status(400).json({ error: 'Nenhum campo para atualizar' });
  }

  params.push(id, req.userId);

  db.run(
    `UPDATE goals SET ${fields.join(', ')} WHERE id = ? AND user_id = ?`,
    params,
    function (err) {
      if (err) return res.status(500).json({ error: err.message });
      if (this.changes === 0) {
        return res.status(404).json({ error: 'Meta não encontrada' });
      }
      res.json({ message: 'Meta atualizada' });
    }
  );
};

// DELETE /goals/:id
exports.remove = (req, res) => {
  const { id } = req.params;

  db.run(
    `DELETE FROM goals WHERE id = ? AND user_id = ?`,
    [id, req.userId],
    function (err) {
      if (err) return res.status(500).json({ error: err.message });
      if (this.changes === 0) {
        return res.status(404).json({ error: 'Meta não encontrada' });
      }
      res.status(204).send();
    }
  );
};
