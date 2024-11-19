require('dotenv').config();
const express = require('express');
const cors = require('cors');
const mongoose = require('mongoose');
const logger = require('./utils/logger');
const authRoutes = require('./routes/auth.routes');
const travelRoutes = require('./routes/travel.routes');
const profileRoutes = require('./routes/profile.routes');
const messageRoutes = require('./routes/message.routes');
const userRoutes = require('./routes/index');

const app = express();

const corsOptions = {
  origin: process.env.CORS_ORIGIN || 'http://localhost',
  optionsSuccessStatus: 200,
  credentials: true
};

app.use(cors(corsOptions));

// Basic middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Routes
app.use('/api/v1/auth', authRoutes);
app.use('/api/v1/travels', travelRoutes);
app.use('/api/v1/profile', profileRoutes);
app.use('/api/v1/messages', messageRoutes);
app.use('/api/v1', userRoutes);

// Error handling for JSON parsing
app.use((err, req, res, next) => {
  if (err instanceof SyntaxError && err.status === 400 && 'body' in err) {
    logger.error('Bad JSON:', err);
    return res.status(400).json({ message: 'Invalid JSON' });
  }
  next(err);
});

// General error handling
app.use((err, req, res, next) => {
  logger.error('Error:', err);
  res.status(500).json({ message: 'Internal server error' });
});

// Determine environment-specific variables
const isTestEnvironment = process.env.NODE_ENV === 'test';
const PORT = isTestEnvironment ? process.env.TEST_PORT : process.env.PORT || 3000;
const MONGODB_URI = isTestEnvironment 
  ? process.env.TEST_MONGODB_URI || 'mongodb://localhost:27017/travel_companion_test'
  : process.env.MONGODB_URI || 'mongodb://localhost:27017/travel_companion';

if (!isTestEnvironment) {
  mongoose
    .connect(MONGODB_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
      serverSelectionTimeoutMS: 5000,
      retryWrites: true
    })
    .then(() => {
      app.listen(PORT, () => {
        logger.info(`Backend is running successfully on port ${PORT}`);
      });
    })
    .catch((err) => {
      logger.error('MongoDB connection error:', err);
      process.exit(1);
    });
}

module.exports = app;