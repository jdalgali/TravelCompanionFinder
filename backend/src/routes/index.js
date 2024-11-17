const express = require('express');
const router = express.Router();
const authController = require('../controllers/auth.controller');
const profileRoutes = require('./routes/profile.routes');

// Auth routes
router.post('/auth/register', authController.register);
router.post('/auth/login', authController.login);

app.use('/api/v1/profile', profileRoutes);

module.exports = router;