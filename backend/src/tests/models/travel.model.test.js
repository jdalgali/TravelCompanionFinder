const mongoose = require('mongoose');
const Travel = require('../../models/travel.model');
const { MongoMemoryServer } = require('mongodb-memory-server');

let mongoServer;

beforeAll(async () => {
  mongoServer = await MongoMemoryServer.create();
  const uri = mongoServer.getUri();
  await mongoose.connect(uri, { useNewUrlParser: true, useUnifiedTopology: true });
});

afterAll(async () => {
  await mongoose.disconnect();
  await mongoServer.stop();
});

afterEach(async () => {
  await Travel.deleteMany({});
});

describe('Travel Model Test', () => {
  it('should create a travel with required fields', async () => {
    const travel = new Travel({
      title: 'Test Travel',
      description: 'Test Description',
      destination: 'Test Destination',
      startDate: new Date(),
      endDate: new Date(),
      maxCompanions: 5,
      creator: new mongoose.Types.ObjectId(),
      preferences: {
        activityLevel: 'Medium',
        budget: 'Moderate'
      }
    });

    await travel.save();

    const savedTravel = await Travel.findOne({ title: 'Test Travel' });
    expect(savedTravel).toBeTruthy();
    expect(savedTravel.title).toBe('Test Travel');
  });

  it('should require title, description, destination, startDate, endDate, maxCompanions, and creator', async () => {
    const travel = new Travel({
      preferences: {
        activityLevel: 'Medium',
        budget: 'Moderate'
      }
    });

    let error;
    try {
      await travel.save();
    } catch (err) {
      error = err;
    }

    expect(error).toBeTruthy();
    expect(error.errors.title).toBeDefined();
    expect(error.errors.description).toBeDefined();
    expect(error.errors.destination).toBeDefined();
    expect(error.errors.startDate).toBeDefined();
    expect(error.errors.endDate).toBeDefined();
    expect(error.errors.maxCompanions).toBeDefined();
    expect(error.errors.creator).toBeDefined();
  });

  it('should have default status as "Open"', async () => {
    const travel = new Travel({
      title: 'Test Travel',
      description: 'Test Description',
      destination: 'Test Destination',
      startDate: new Date(),
      endDate: new Date(),
      maxCompanions: 5,
      creator: new mongoose.Types.ObjectId(),
      preferences: {
        activityLevel: 'Medium',
        budget: 'Moderate'
      }
    });

    await travel.save();

    const savedTravel = await Travel.findOne({ title: 'Test Travel' });
    expect(savedTravel).toBeTruthy();
    expect(savedTravel.status).toBe('Open');
  });

  it('should not allow invalid travelStyle values', async () => {
    const travel = new Travel({
      title: 'Test Travel',
      description: 'Test Description',
      destination: 'Test Destination',
      startDate: new Date(),
      endDate: new Date(),
      maxCompanions: 5,
      creator: new mongoose.Types.ObjectId(),
      preferences: {
        activityLevel: 'Medium',
        budget: 'Moderate',
        travelStyle: ['InvalidStyle']
      }
    });

    let error;
    try {
      await travel.save();
    } catch (err) {
      error = err;
    }

    expect(error).toBeTruthy();
    expect(error.errors['preferences.travelStyle.0']).toBeDefined();
  });
});