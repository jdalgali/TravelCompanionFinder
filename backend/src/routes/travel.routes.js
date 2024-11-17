const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth.middleware');
const travelController = require('../controllers/travel.controller');

router.post('/', auth, travelController.createTravel);
router.get('/search', travelController.searchTravels);
router.get('/', travelController.getTravels); // Ensure this line is present
router.get('/:id', travelController.getTravelById);
router.patch('/:id', auth, travelController.updateTravel);
router.delete('/:id', auth, travelController.deleteTravel);
router.post('/:id/join', auth, travelController.joinTravel);

module.exports = router;