const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

const userSchema = new mongoose.Schema({
  name: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  profileImage: { type: String },
  preferences: {
    activityLevel: { type: String, enum: ['Low', 'Medium', 'High'], required: true },
    budget: { type: String, enum: ['Budget', 'Moderate', 'Luxury'], required: true },
    travelStyle: [{ type: String, enum: ['Adventure', 'Cultural', 'Relaxation', 'Food', 'Nature'] }],
  },
  travelHistory: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Travel' }],
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