const mongoose = require('mongoose');

const travelSchema = new mongoose.Schema({
  title: {
    type: String,
    required: true,
    trim: true
  },
  description: {
    type: String,
    required: true
  },
  destination: {
    type: String,
    required: true
  },
  startDate: {
    type: Date,
    required: true
  },
  endDate: {
    type: Date,
    required: true
  },
  maxCompanions: {
    type: Number,
    required: true,
    min: 1
  },
  currentCompanions: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  }],
  creator: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  preferences: {
    activityLevel: {
      type: String,
      enum: ['Low', 'Medium', 'High'],
      required: true
    },
    budget: {
      type: String,
      enum: ['Budget', 'Moderate', 'Luxury'],
      required: true
    },
    travelStyle: [{
      type: String,
      enum: ['Adventure', 'Cultural', 'Relaxation', 'Food', 'Nature']
    }]
  },
  status: {
    type: String,
    enum: ['Open', 'Full', 'Completed', 'Cancelled'],
    default: 'Open'
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model('Travel', travelSchema);