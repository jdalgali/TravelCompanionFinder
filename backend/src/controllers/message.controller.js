const Message = require('../models/message.model');
const logger = require('../utils/logger');

exports.sendMessage = async (req, res) => {
  try {
    const { receiver, content } = req.body;
    const sender = req.user.id;

    const message = new Message({
      sender,
      receiver,
      content,
    });

    await message.save();
    res.status(201).json(message);
  } catch (error) {
    logger.error('Error sending message:', error);
    res.status(500).json({ message: 'Error sending message' });
  }
};

exports.getMessages = async (req, res) => {
  try {
    const userId = req.user.id;
    const messages = await Message.find({
      $or: [{ sender: userId }, { receiver: userId }],
    })
      .populate('sender', 'name')
      .populate('receiver', 'name')
      .sort({ timestamp: -1 });

    res.json(messages);
  } catch (error) {
    logger.error('Error fetching messages:', error);
    res.status(500).json({ message: 'Error fetching messages' });
  }
};