const portfinder = require('portfinder');

module.exports = async () => {
  process.env.MONGODB_URI = 'mongodb://localhost:27017/travel_companion_test';
  process.env.JWT_SECRET = 'your_secret_key';
  process.env.NODE_ENV = 'test';

  portfinder.basePort = 3001;
  portfinder.highestPort = 3100;

  process.env.PORT = await portfinder.getPortPromise();
};