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
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
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
  preferences: [{
    type: String,
    enum: ['Adventure', 'Relaxation', 'Cultural', 'Budget', 'Luxury']
  }],
  estimatedCost: {
    type: Number,
    required: true,
    min: 0
  },
  activities: [{
    type: String
  }],
  status: {
    type: String,
    enum: ['open', 'closed', 'in-progress'],
    default: 'open'
  },
  applicants: [{
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User'
    },
    status: {
      type: String,
      enum: ['pending', 'accepted', 'rejected'],
      default: 'pending'
    },
    appliedAt: {
      type: Date,
      default: Date.now
    }
  }],
  acceptedCompanions: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  }]
}, {
  timestamps: true
});

// Add index for search functionality
travelSchema.index({ destination: 'text', title: 'text' });

// Middleware to validate dates
travelSchema.pre('save', function(next) {
  if (this.startDate >= this.endDate) {
    next(new Error('End date must be after start date'));
  }
  if (this.startDate < new Date()) {
    next(new Error('Start date cannot be in the past'));
  }
  next();
});

module.exports = mongoose.model('Travel', travelSchema);