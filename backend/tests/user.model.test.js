const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const User = require('../src/models/user.model');
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
    await User.deleteMany({});
});

describe('User Model Test', () => {
    it('should hash the password before saving', async () => {
        const user = new User({
            email: 'test@mail.com',
            password: 'password123',
            name: 'Test User',
            preferences: {
                activityLevel: 'Medium',
                budget: 'Moderate'
            }
        });

        await user.save();

        const savedUser = await User.findOne({ email: 'test@mail.com' });
        expect(savedUser).toBeTruthy();
        expect(savedUser.password).not.toBe('password123');
        const isMatch = await bcrypt.compare('password123', savedUser.password);
        expect(isMatch).toBe(true);
    });

    it('should validate the password correctly', async () => {
        const user = new User({
            email: 'test2@mail.com',
            password: 'password123',
            name: 'Test User 2',
            preferences: {
                activityLevel: 'Medium',
                budget: 'Moderate'
            }
        });

        await user.save();

        const savedUser = await User.findOne({ email: 'test2@mail.com' });
        const isValid = await savedUser.isValidPassword('password123');
        expect(isValid).toBe(true);

        const isInvalid = await savedUser.isValidPassword('wrongpassword');
        expect(isInvalid).toBe(false);
    });

    it('should not hash the password if it is not modified', async () => {
        const user = new User({
            email: 'test3@mail.com',
            password: 'password123',
            name: 'Test User 3',
            preferences: {
                activityLevel: 'Medium',
                budget: 'Moderate'
            }
        });

        await user.save();

        user.name = 'Updated Test User 3';
        await user.save();

        const savedUser = await User.findOne({ email: 'test3@mail.com' });
        const isMatch = await bcrypt.compare('password123', savedUser.password);
        expect(isMatch).toBe(true);
    });

    it('should require an email, password, and name', async () => {
        const user = new User({
            email: '',
            password: '',
            name: '',
            preferences: {
                activityLevel: 'Medium',
                budget: 'Moderate'
            }
        });

        let error;
        try {
            await user.save();
        } catch (err) {
            error = err;
        }

        expect(error).toBeTruthy();
        expect(error.errors.email).toBeDefined();
        expect(error.errors.password).toBeDefined();
        expect(error.errors.name).toBeDefined();
    });

    it('should require a unique email', async () => {
        const user1 = new User({
            email: 'test4@mail.com',
            password: 'password123',
            name: 'Test User 4',
            preferences: {
                activityLevel: 'Medium',
                budget: 'Moderate'
            }
        });

        const user2 = new User({
            email: 'test4@mail.com',
            password: 'password456',
            name: 'Test User 5',
            preferences: {
                activityLevel: 'Medium',
                budget: 'Moderate'
            }
        });

        await user1.save();

        let error;
        try {
            await user2.save();
        } catch (err) {
            error = err;
        }

        expect(error).toBeTruthy();
        expect(error.code).toBe(11000); // Duplicate key error code
    });
});