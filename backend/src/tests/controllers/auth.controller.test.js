const request = require('supertest');
const mongoose = require('mongoose');
const { MongoMemoryServer } = require('mongodb-memory-server');
const app = require('../../index');
const User = require('../../models/user.model');

let mongoServer;

beforeAll(async () => {
  mongoServer = await MongoMemoryServer.create();
  const uri = mongoServer.getUri();

  await mongoose.disconnect();
  await mongoose.connect(uri, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  });
});

afterAll(async () => {
  await mongoose.disconnect();
  await mongoServer.stop();
});

afterEach(async () => {
  await User.deleteMany({});
});

describe('Auth Controller Tests', () => {
  describe('POST /api/v1/auth/register', () => {
    it('should register a new user', async () => {
      const res = await request(app)
        .post('/api/v1/auth/register')
        .send({
          email: 'testuser@example.com',
          password: 'password123',
          name: 'Test User',
          preferences: {
            activityLevel: 'Medium',
            budget: 'Moderate',
          },
        });

      expect(res.statusCode).toBe(201);
      expect(res.body).toHaveProperty('token');
      expect(res.body.user).toHaveProperty('id');
      expect(res.body.user.email).toBe('testuser@example.com');
    });

    it('should not register a user with existing email', async () => {
      const user = new User({
        email: 'duplicate@example.com',
        password: 'password123',
        name: 'Duplicate User',
        preferences: {
          activityLevel: 'Medium',
          budget: 'Moderate',
        },
      });
      await user.save();

      const res = await request(app)
        .post('/api/v1/auth/register')
        .send({
          email: 'duplicate@example.com',
          password: 'password123',
          name: 'Duplicate User',
          preferences: {
            activityLevel: 'Medium',
            budget: 'Moderate',
          },
        });

      expect(res.statusCode).toBe(400);
      expect(res.body.message).toBe('User already exists');
    });

    it('should require email, password, name, and preferences', async () => {
      const res = await request(app)
        .post('/api/v1/auth/register')
        .send({});

      expect(res.statusCode).toBe(400);
      expect(res.body.message).toBe('Email, password, name, and preferences are required');
    });

    it('should require preferences when registering a user', async () => {
      const res = await request(app)
        .post('/api/v1/auth/register')
        .send({
          email: 'test@example.com',
          password: 'password123',
          name: 'Test User'
        });

      expect(res.statusCode).toBe(400);
      expect(res.body.message).toBe('Email, password, name, and preferences are required');
    });

    it('should validate preferences values', async () => {
      const res = await request(app)
        .post('/api/v1/auth/register')
        .send({
          email: 'test@example.com',
          password: 'password123',
          name: 'Test User',
          preferences: {
            activityLevel: 'Invalid',
            budget: 'Invalid'
          }
        });

      expect(res.statusCode).toBe(400);
      expect(res.body.message).toBe('Invalid preferences values');
    });
  });

  describe('POST /api/v1/auth/login', () => {
    beforeEach(async () => {
      const user = new User({
        email: 'testlogin@example.com',
        password: 'password123',
        name: 'Login User',
        preferences: {
          activityLevel: 'Medium',
          budget: 'Moderate',
        },
      });
      await user.save();
    });

    it('should login with valid credentials', async () => {
      const res = await request(app)
        .post('/api/v1/auth/login')
        .send({
          email: 'testlogin@example.com',
          password: 'password123',
        });

      expect(res.statusCode).toBe(200);
      expect(res.body).toHaveProperty('token');
      expect(res.body.user).toHaveProperty('id');
      expect(res.body.user.email).toBe('testlogin@example.com');
    });

    it('should not login with invalid credentials', async () => {
      const res = await request(app)
        .post('/api/v1/auth/login')
        .send({
          email: 'testlogin@example.com',
          password: 'wrongpassword',
        });

      expect(res.statusCode).toBe(401);
      expect(res.body.message).toBe('Invalid credentials');
    });

    it('should require email and password', async () => {
      const res = await request(app)
        .post('/api/v1/auth/login')
        .send({});

      expect(res.statusCode).toBe(400);
      expect(res.body.message).toBe('Email and password are required');
    });

    it('should handle malformed JSON in request body', async () => {
      const res = await request(app)
        .post('/api/v1/auth/login')
        .set('Content-Type', 'application/json')
        .send('{"malformed json"}');

      expect(res.statusCode).toBe(400);
    });
  });
});
