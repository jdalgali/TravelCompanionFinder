const jwt = require('jsonwebtoken');
const User = require('../models/user.model');
const logger = require('../utils/logger');

exports.register = async (req, res) => {
  try {
    const { email, password, name, preferences } = req.body;
    logger.info('Registration attempt', { email, name }); // Log attempt

    // Validate required fields
    if (!email || !password || !name) {
      return res.status(400).json({ 
        message: 'Missing required fields',
        details: {
          email: !email ? 'Email is required' : null,
          password: !password ? 'Password is required' : null,
          name: !name ? 'Name is required' : null
        }
      });
    }

    // Check if user already exists
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ message: 'User already exists' });
    }

    // Create new user with default preferences if not provided
    const userData = {
      email,
      password,
      name,
      preferences: preferences || {
        travelStyle: 'adventure',
        destinations: [],
        languages: [],
        ageRange: { min: 18, max: 100 }
      }
    };

    logger.info('Creating new user', { email }); // Log user creation
    const user = new User(userData);
    await user.save();

    // Generate JWT token
    const token = jwt.sign(
      { userId: user._id },
      process.env.JWT_SECRET || 'default_secret_key',
      { expiresIn: '24h' }
    );

    logger.info('User registered successfully', { email }); // Log success
    res.status(201).json({
      message: 'User created successfully',
      token,
      user: {
        id: user._id,
        email: user.email,
        name: user.name,
        preferences: user.preferences
      }
    });
  } catch (error) {
    logger.error('Registration error:', error);
    res.status(500).json({ 
      message: 'Error creating user',
      details: error.message
    });
  }
};

exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;
    logger.info('Login attempt', { email }); // Log attempt

    // Validate required fields
    if (!email || !password) {
      return res.status(400).json({ 
        message: 'Missing required fields',
        details: {
          email: !email ? 'Email is required' : null,
          password: !password ? 'Password is required' : null
        }
      });
    }

    // Find user
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(401).json({ message: 'Invalid credentials' });
    }

    // Check password
    const isValid = await user.isValidPassword(password);
    if (!isValid) {
      return res.status(401).json({ message: 'Invalid credentials' });
    }

    // Generate token
    const token = jwt.sign(
      { userId: user._id },
      process.env.JWT_SECRET || 'default_secret_key',
      { expiresIn: '24h' }
    );

    logger.info('User logged in successfully', { email }); // Log success
    res.json({
      token,
      user: {
        id: user._id,
        email: user.email,
        name: user.name,
        preferences: user.preferences
      }
    });
  } catch (error) {
    logger.error('Login error:', error);
    res.status(500).json({ 
      message: 'Error during login',
      details: error.message
    });
  }
};