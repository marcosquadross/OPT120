const express = require('express');
const UserController = require('../controllers/userController');
const userController = require('../controllers/userController');
const router = express.Router();

router.get('/listUsers', userController.listUsers);
router.get('/getUser/:id', userController.getUser);
router.post('/createUser', userController.createUser);
router.put('/updateUser/:id', userController.updateUser);
router.delete('/deleteUser/:id', userController.deleteUser);

module.exports = router;