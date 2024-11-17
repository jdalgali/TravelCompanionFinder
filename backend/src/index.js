require('dotenv').config();
const express = require('express');
const cors = require('cors');
const mongoose = require('mongoose');
const logger = require('./utils/logger');
const authRoutes = require('./routes/auth.routes');
const travelRoutes = require('./routes/travel.routes');
const profileRoutes = require('./routes/profile.routes');
const messageRoutes = require('./routes/message.routes');
const userRoutes = require('./routes/index'); // Ensure this is imported

const app = express();

// Simple CORS setup
const corsOptions = {
  origin: 'http://localhost',
  optionsSuccessStatus: 200
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

// Error handling
app.use((err, req, res, next) => {
  logger.error('Error:', err);
  res.status(500).json({
    message: err.message || 'Internal server error'
  });
});

// Database connection
mongoose
  .connect(process.env.MONGODB_URI, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(() => logger.info('MongoDB connected'))
  .catch((err) => logger.error('MongoDB connection error:', err));

// Start server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  logger.info(`Server running on port ${PORT}`);
});