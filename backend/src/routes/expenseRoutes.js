const express = require('express');
const router = express.Router();

const expenseController = require('../controllers/expenseController');
const auth = require('../middlewares/authMiddleware');

router.use(auth);

router.post('/', expenseController.create);
router.get('/', expenseController.list);
router.delete('/:id', expenseController.remove);

module.exports = router;
