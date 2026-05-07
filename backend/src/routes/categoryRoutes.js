const express = require('express');
const router = express.Router();

const categoryController = require('../controllers/categoryController');
const auth = require('../middlewares/authMiddleware');

// todas as rotas exigem login
router.use(auth);

router.post('/', categoryController.create);
router.get('/', categoryController.list);
router.delete('/:id', categoryController.remove);

module.exports = router;
