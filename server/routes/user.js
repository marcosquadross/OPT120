const express = require('express');
const UserController = require('../controllers/userController');
const authenticationToken = require('../middleware/authMiddleware');

const router = express.Router();

router.post('/registerUser', UserController.createUser);
router.get('/listUsers', authenticationToken, UserController.listUsers);
router.get('/getUser/:id', authenticationToken, UserController.getUser);
router.put('/updateUser/:id', authenticationToken, UserController.updateUser);
router.delete('/deleteUser/:id', authenticationToken, UserController.deleteUser);

router.post('/login', UserController.login);

module.exports = router;
