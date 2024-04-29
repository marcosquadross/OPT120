const express = require('express');
const UserActivityController = require('../controllers/userActivityController');
const authenticationToken = require('../middleware/authMiddleware');

const router = express.Router();
router.use(authenticationToken);

router.get('/getUserActivity', UserActivityController.getUserActivity);
router.get('/listUserActivity', UserActivityController.listUserActivities);
router.get('/listUserActivityByUser/:id', UserActivityController.listUserActivitiesByUser);
router.get('/listUserActivityByActivity/:id', UserActivityController.listUserActivitiesByActivity);
router.post('/createUserActivity', UserActivityController.createUserActivity);
router.put('/updateScore', UserActivityController.updateScore);
router.delete('/deleteUserActivity', UserActivityController.deleteUserActivity);

module.exports = router;