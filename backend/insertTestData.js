const mongoose = require('mongoose');
const Travel = require('./src/models/travel.model');
require('dotenv').config();

const insertTestData = async () => {
  try {
    await mongoose.connect(process.env.MONGODB_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });

    // Clear existing travel data
    await Travel.deleteMany({});

    // Insert test travels related to Thailand
    const travels = [
      {
        title: 'Trip to Bangkok',
        description: 'Explore the vibrant city of Bangkok',
        destination: 'Bangkok',
        startDate: new Date(),
        endDate: new Date(),
        maxCompanions: 5,
        creator: new mongoose.Types.ObjectId(),
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
        creator: new mongoose.Types.ObjectId(),
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
        creator: new mongoose.Types.ObjectId(),
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
        creator: new mongoose.Types.ObjectId(),
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
        creator: new mongoose.Types.ObjectId(),
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