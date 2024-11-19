const request = require('supertest');
const mongoose = require('mongoose');
const { MongoMemoryServer } = require('mongodb-memory-server');
const app = require('../../index');
const Travel = require('../../models/travel.model');
const User = require('../../models/user.model');
const jwt = require('jsonwebtoken');

let mongoServer;
let token;
let userId;

beforeAll(async () => {
  // Set test environment
  process.env.NODE_ENV = 'test';
  
  // Start MongoDB Memory Server
  mongoServer = await MongoMemoryServer.create();
  const uri = mongoServer.getUri();

  await mongoose.disconnect();
  await mongoose.connect(uri, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  });

  // Create a Test User
  const user = new User({
    email: 'testuser@example.com',
    password: 'password123',
    name: 'Test User',
    preferences: {
      activityLevel: 'Medium',
      budget: 'Moderate',
    },
  });
  await user.save();
  userId = user._id;

  // Generate JWT Token
  token = jwt.sign({ userId: userId.toString() }, process.env.JWT_SECRET, {
    expiresIn: '1h',
  });
});

afterAll(async () => {
  await mongoose.disconnect();
  await mongoServer.stop();
});

beforeEach(async () => {
  await Travel.deleteMany({});
  // Create a fresh test user before each test if needed
  const user = await User.findById(userId);
  if (!user) {
    const newUser = new User({
      _id: userId,
      email: 'testuser@example.com',
      password: 'password123',
      name: 'Test User',
      preferences: {
        activityLevel: 'Medium',
        budget: 'Moderate',
      },
    });
    await newUser.save();
  }
});

afterEach(async () => {
  await Travel.deleteMany({});
});

describe('Travel Controller Tests', () => {
  it('should create a new travel', async () => {
    const res = await request(app) // Use app directly with supertest
      .post('/api/v1/travels')
      .set('Authorization', `Bearer ${token}`)
      .send({
        title: 'Test Travel',
        description: 'A wonderful journey',
        destination: 'Wonderland',
        startDate: new Date(),
        endDate: new Date(),
        maxCompanions: 4,
        preferences: {
          activityLevel: 'High',
          budget: 'Luxury',
          travelStyle: ['Adventure'],
        },
      });

    expect(res.statusCode).toBe(201);
    expect(res.body).toHaveProperty('_id');
    expect(res.body.title).toBe('Test Travel');
    expect(res.body.creator).toEqual(userId.toString());
  });

  it('should get a list of travels', async () => {
    const travel = new Travel({
      title: 'Sample Travel',
      description: 'Sample Description',
      destination: 'Sample Destination',
      startDate: new Date(),
      endDate: new Date(),
      maxCompanions: 3,
      creator: userId,
      preferences: {
        activityLevel: 'Low',
        budget: 'Budget',
        travelStyle: ['Relaxation'],
      },
    });
    await travel.save();

    const res = await request(app).get('/api/v1/travels');

    expect(res.statusCode).toBe(200);
    expect(res.body.travels.length).toBeGreaterThan(0);
    expect(res.body.travels[0]).toHaveProperty('_id');
  });

  it('should get a travel by ID', async () => {
    const travel = new Travel({
      title: 'Unique Travel',
      description: 'Unique Description',
      destination: 'Unique Destination',
      startDate: new Date(),
      endDate: new Date(),
      maxCompanions: 2,
      creator: userId,
      preferences: {
        activityLevel: 'Medium',
        budget: 'Moderate',
        travelStyle: ['Cultural'],
      },
    });
    await travel.save();

    const res = await request(app).get(`/api/v1/travels/${travel._id}`);

    expect(res.statusCode).toBe(200);
    expect(res.body.title).toBe('Unique Travel');
    expect(res.body._id).toEqual(travel._id.toString());
  });
});