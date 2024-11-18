const mongoose = require('mongoose');
const Message = require('../../models/message.model');
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
  await Message.deleteMany({});
});

describe('Message Model Test', () => {
  it('should create a message with required fields', async () => {
    const message = new Message({
      sender: new mongoose.Types.ObjectId(),
      receiver: new mongoose.Types.ObjectId(),
      content: 'Test Message'
    });

    await message.save();

    const savedMessage = await Message.findOne({ content: 'Test Message' });
    expect(savedMessage).toBeTruthy();
    expect(savedMessage.content).toBe('Test Message');
  });

  it('should require sender, receiver, and content', async () => {
    const message = new Message({});

    let error;
    try {
      await message.save();
    } catch (err) {
      error = err;
    }

    expect(error).toBeTruthy();
    expect(error.errors.sender).toBeDefined();
    expect(error.errors.receiver).toBeDefined();
    expect(error.errors.content).toBeDefined();
  });

  it('should have a default timestamp', async () => {
    const message = new Message({
      sender: new mongoose.Types.ObjectId(),
      receiver: new mongoose.Types.ObjectId(),
      content: 'Test Message'
    });

    await message.save();

    const savedMessage = await Message.findOne({ content: 'Test Message' });
    expect(savedMessage).toBeTruthy();
    expect(savedMessage.timestamp).toBeDefined();
  });
});