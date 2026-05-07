const express = require('express');
const router = express.Router();
const auth = require('../middlewares/authMiddleware');
const db = require('../database/db');

router.use(auth);

// GET /dashboard - retorna totais agregados do usuário logado
router.get('/', (req, res) => {
  // Totais de receitas
  db.get(
    `SELECT COALESCE(SUM(amount), 0) as total_receitas
     FROM incomes WHERE user_id = ?`,
    [req.userId],
    (err, receitasRow) => {
      if (err) return res.status(500).json({ error: err.message });

      // Totais de despesas
      db.get(
        `SELECT COALESCE(SUM(amount), 0) as total_despesas
         FROM expenses WHERE user_id = ?`,
        [req.userId],
        (err2, despesasRow) => {
          if (err2) return res.status(500).json({ error: err2.message });

          const totalReceitas = receitasRow.total_receitas;
          const totalDespesas = despesasRow.total_despesas;
          const saldo = totalReceitas - totalDespesas;

          // Metas
          db.all(
            `SELECT * FROM goals WHERE user_id = ?`,
            [req.userId],
            (err3, metas) => {
              if (err3) return res.status(500).json({ error: err3.message });

              res.json({
                totalReceitas,
                totalDespesas,
                saldo,
                metas: metas || [],
              });
            }
          );
        }
      );
    }
  );
});

module.exports = router;
