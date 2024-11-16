const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

const userSchema = new mongoose.Schema({
  email: {
    type: String,
    required: true,
    unique: true,
    lowercase: true,
    trim: true
  },
  password: {
    type: String,
    required: true,
    minlength: 6
  },
  name: {
    type: String,
    required: true
  },
  preferences: {
    travelStyle: {
      type: String,
      enum: ['adventure', 'relaxation', 'cultural', 'budget', 'luxury'],
      default: 'adventure'
    },
    destinations: {
      type: [String],
      default: []
    },
    languages: {
      type: [String],
      default: []
    },
    ageRange: {
      min: {
        type: Number,
        default: 18
      },
      max: {
        type: Number,
        default: 100
      }
    }
  },
  bio: String,
  profileImage: String,
  createdAt: {
    type: Date,
    default: Date.now
  }
});

// Hash password before saving
userSchema.pre('save', async function(next) {
  if (!this.isModified('password')) return next();
  
  try {
    const salt = await bcrypt.genSalt(10);
    this.password = await bcrypt.hash(this.password, salt);
    next();
  } catch (error) {
    next(error);
  }
});

// Method to check password validity
userSchema.methods.isValidPassword = async function(password) {
  return await bcrypt.compare(password, this.password);
};

module.exports = mongoose.model('User', userSchema);