const express = require('express');
const activityController = require('../controllers/activityController');
const authenticationToken = require('../middleware/authMiddleware');

const router = express.Router();
router.use(authenticationToken);

router.get('/getActivity/:id', activityController.getActivity);
router.get('/listActivities', activityController.listActivities);
router.post('/createActivity', activityController.createActivity);
router.put('/updateActivity/:id', activityController.updateActivity);
router.delete('/deleteActivity/:id', activityController.deleteActivity);

module.exports = router;