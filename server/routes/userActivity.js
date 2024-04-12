const express = require('express');
const UserActivityController = require('../controllers/userActivityController');
const router = express.Router();

router.get('/listUserActivity', UserActivityController.listUserActivities);
router.post('/createUserActivity', UserActivityController.createUserActivity);
router.put('/updateUserActivity/:id', UserActivityController.updateUserActivity);
router.delete('/deleteUserActivity/:id', UserActivityController.deleteUserActivity);

module.exports = router;