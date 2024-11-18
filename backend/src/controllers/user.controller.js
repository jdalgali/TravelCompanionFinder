const User = require('../models/user.model');
const logger = require('../utils/logger');

exports.getUserPreferences = async (req, res) => {
  try {
    const user = await User.findById(req.params.id);

    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    res.json(user.preferences);
  } catch (error) {
    logger.error('Error fetching user preferences:', error);
    res.status(500).json({ message: 'Error fetching user preferences' });
  }
};