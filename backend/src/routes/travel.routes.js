const express = require('express');
const router = express.Router();
const travelController = require('../controllers/travel.controller');
const authMiddleware = require('../middleware/auth.middleware');

// Apply auth middleware to all routes
router.use(authMiddleware);

// Create new travel listing
router.post('/', travelController.createTravel);

// Get all travels with filters
router.get('/', travelController.getTravels);

// Get specific travel by ID
router.get('/:id', travelController.getTravelById);

// Update travel
router.put('/:id', travelController.updateTravel);

// Apply for travel
router.post('/:id/apply', travelController.applyForTravel);

module.exports = router;