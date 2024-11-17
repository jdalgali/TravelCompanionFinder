const express = require('express');
const router = express.Router();
const authController = require('../controllers/auth.controller');
const profileRoutes = require('./profile.routes');
const travelRoutes = require('./travel.routes');
const messageRoutes = require('./message.routes');
const userRoutes = require('./user.routes');

// Auth routes
router.post('/auth/register', authController.register);
router.post('/auth/login', authController.login);

// Profile routes
router.use('/profile', profileRoutes);

// Travel routes
router.use('/travels', travelRoutes);

// Message routes
router.use('/messages', messageRoutes);

// User routes
router.use('/users', userRoutes);

module.exports = router;