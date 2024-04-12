const express = require('express');
const router = express.Router();

router.use('/', require('./user'));
router.use('/', require('./activity'));
router.use('/', require('./userActivity'));

module.exports = router;