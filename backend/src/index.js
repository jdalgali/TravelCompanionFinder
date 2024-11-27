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

const env = process.env.NODE_ENV || 'development';
const PORT = process.env.API_PORT || 3000;

const corsOptions = {
  origin: process.env.CORS_ORIGIN || '*',
  optionsSuccessStatus: 200,
  credentials: true
};

app.use(cors(corsOptions));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Health check endpoint
app.get('/api/v1/health', (req, res) => {
  res.status(200).json({ status: 'UP' });
});

// Routes
app.use('/api/v1/auth', authRoutes);
app.use('/api/v1/travels', travelRoutes);
app.use('/api/v1/profile', profileRoutes);
app.use('/api/v1/messages', messageRoutes);
app.use('/api/v1/users', userRoutes);

mongoose.connect(process.env.MONGODB_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true
}).then(() => {
  logger.info('Connected to MongoDB');
  app.listen(PORT, () => {
    logger.info(`Server is running on port ${PORT}`);
  });
}).catch(err => {
  logger.error('Failed to connect to MongoDB', err);
});