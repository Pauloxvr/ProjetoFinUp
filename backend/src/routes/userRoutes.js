const express = require('express');
const router = express.Router();

const userController = require('../controllers/userController');
const auth = require('../middlewares/authMiddleware');

// rota pública - cadastro
router.post('/', userController.create);

// rota protegida - dados do usuário logado
router.get('/me', auth, userController.me);

module.exports = router;
