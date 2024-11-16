const mongoose = require('mongoose');

const travelSchema = new mongoose.Schema({
  title: {
    type: String,
    required: true,
    trim: true
  },
  creator: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
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

// Create indexes for better search performance
travelSchema.index({ destination: 1, startDate: 1 });
travelSchema.index({ status: 1 });

module.exports = mongoose.model('Travel', travelSchema);