const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const Travel = require('./src/models/travel.model');
const User = require('./src/models/user.model');

// Load environment variables based on NODE_ENV
const env = process.env.NODE_ENV || 'development';
const envFile = `.env.${env}`;
require('dotenv').config({ path: envFile });

const insertTestData = async () => {
  try {
    const mongoUri = process.env.MONGODB_URI;
    if (!mongoUri) {
      throw new Error('MONGODB_URI is not defined in the environment variables');
    }

    console.log(`Connecting to MongoDB at ${mongoUri}`);
    await mongoose.connect(mongoUri, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });

    // Clear existing data
    await Travel.deleteMany({});
    await User.deleteMany({});

    // Create test users
    const adminUser = new User({
      email: 'admin@mail.com',
      password: 'admin1234',
      name: 'Admin User',
      preferences: {
        activityLevel: 'Medium',
        budget: 'Moderate',
        travelStyle: ['Cultural', 'Food'],
      },
    });

    const receiverUser = new User({
      email: 'receiver@mail.com',
      password: 'receiver1234',
      name: 'Receiver User',
      preferences: {
        activityLevel: 'High',
        budget: 'Luxury',
        travelStyle: ['Relaxation', 'Adventure'],
      },
    });

    await adminUser.save();
    await receiverUser.save();

    // Insert test travels related to Thailand
    const travels = [
      {
        title: 'Trip to Bangkok',
        description: 'Explore the vibrant city of Bangkok',
        destination: 'Bangkok',
        startDate: new Date(),
        endDate: new Date(),
        maxCompanions: 5,
        creator: adminUser._id,
        preferences: {
          activityLevel: 'Medium',
          budget: 'Moderate',
          travelStyle: ['Cultural', 'Food'],
        },
      },
      {
        title: 'Trip to Chiang Mai',
        description: 'Discover the cultural heritage of Chiang Mai',
        destination: 'Chiang Mai',
        startDate: new Date(),
        endDate: new Date(),
        maxCompanions: 4,
        creator: adminUser._id,
        preferences: {
          activityLevel: 'Low',
          budget: 'Budget',
          travelStyle: ['Cultural', 'Nature'],
        },
      },
      {
        title: 'Trip to Phuket',
        description: 'Enjoy the beautiful beaches of Phuket',
        destination: 'Phuket',
        startDate: new Date(),
        endDate: new Date(),
        maxCompanions: 6,
        creator: adminUser._id,
        preferences: {
          activityLevel: 'High',
          budget: 'Luxury',
          travelStyle: ['Relaxation', 'Adventure'],
        },
      },
      {
        title: 'ทริปไปพัทยา',
        description: 'สนุกกับชายหาดและสถานบันเทิงในพัทยา',
        destination: 'พัทยา',
        startDate: new Date(),
        endDate: new Date(),
        maxCompanions: 5,
        creator: adminUser._id,
        preferences: {
          activityLevel: 'Medium',
          budget: 'Moderate',
          travelStyle: ['Relaxation', 'Food'],
        },
      },
      {
        title: 'ทริปไปเชียงราย',
        description: 'เยี่ยมชมวัดร่องขุ่นและธรรมชาติที่เชียงราย',
        destination: 'เชียงราย',
        startDate: new Date(),
        endDate: new Date(),
        maxCompanions: 4,
        creator: adminUser._id,
        preferences: {
          activityLevel: 'Low',
          budget: 'Budget',
          travelStyle: ['Cultural', 'Nature'],
        },
      },
    ];

    for (const travelData of travels) {
      const travel = new Travel(travelData);
      await travel.save();
    }

    console.log('Test data inserted successfully');
    process.exit(0);
  } catch (error) {
    console.error('Error inserting test data:', error);
    process.exit(1);
  }
};

insertTestData();