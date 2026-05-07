const express = require('express');
const router = express.Router();

const goalController = require('../controllers/goalController');
const auth = require('../middlewares/authMiddleware');

router.use(auth);

router.post('/', goalController.create);
router.get('/', goalController.list);
router.patch('/:id', goalController.update);
router.delete('/:id', goalController.remove);

module.exports = router;
