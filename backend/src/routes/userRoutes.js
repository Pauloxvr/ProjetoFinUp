const express = require('express');
const router = express.Router();

const userController = require('../controllers/userController');
const auth = require('../middlewares/authMiddleware');

// rota pública - cadastro
router.post('/', userController.create);

// rotas protegidas
router.get('/me', auth, userController.me);
router.patch('/me', auth, userController.update);

module.exports = router;
