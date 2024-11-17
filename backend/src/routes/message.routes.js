const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth.middleware');
const messageController = require('../controllers/message.controller');

router.post('/', auth, messageController.sendMessage);
router.get('/', auth, messageController.getMessages);

module.exports = router;