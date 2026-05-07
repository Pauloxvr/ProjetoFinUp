const express = require('express');
const router = express.Router();

const incomeController = require('../controllers/incomeController');
const auth = require('../middlewares/authMiddleware');

router.use(auth);

router.post('/', incomeController.create);
router.get('/', incomeController.list);
router.delete('/:id', incomeController.remove);

module.exports = router;
