const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth.middleware');
const { getProfile, updateProfile } = require('../controllers/profile.controller');

// Profile routes
router.get('/', auth, getProfile);
router.patch('/', auth, updateProfile);

module.exports = router;