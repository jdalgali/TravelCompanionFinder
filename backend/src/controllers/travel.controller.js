const Travel = require('../models/travel.model');
const logger = require('../utils/logger');

exports.createTravel = async (req, res) => {
  try {
    const travelData = {
      ...req.body,
      userId: req.user.id, // From auth middleware
    };

    const travel = new Travel(travelData);
    await travel.save();

    res.status(201).json(travel);
  } catch (error) {
    logger.error('Error creating travel:', error);
    res.status(400).json({
      message: error.message || 'Error creating travel listing'
    });
  }
};

exports.getTravels = async (req, res) => {
  try {
    const {
      destination,
      startDate,
      endDate,
      preferences,
      page = 1,
      limit = 10
    } = req.query;

    const query = {};

    if (destination) {
      query.destination = new RegExp(destination, 'i');
    }

    if (startDate) {
      query.startDate = { $gte: new Date(startDate) };
    }

    if (endDate) {
      query.endDate = { $lte: new Date(endDate) };
    }

    if (preferences) {
      query.preferences = { $in: preferences.split(',') };
    }

    const travels = await Travel.find(query)
      .populate('userId', 'name')
      .sort({ createdAt: -1 })
      .skip((page - 1) * limit)
      .limit(parseInt(limit));

    const total = await Travel.countDocuments(query);

    res.json({
      travels,
      totalPages: Math.ceil(total / limit),
      currentPage: page
    });
  } catch (error) {
    logger.error('Error fetching travels:', error);
    res.status(500).json({
      message: 'Error fetching travel listings'
    });
  }
};

exports.getTravelById = async (req, res) => {
  try {
    const travel = await Travel.findById(req.params.id)
      .populate('userId', 'name')
      .populate('acceptedCompanions', 'name');

    if (!travel) {
      return res.status(404).json({ message: 'Travel not found' });
    }

    res.json(travel);
  } catch (error) {
    logger.error('Error fetching travel:', error);
    res.status(500).json({
      message: 'Error fetching travel details'
    });
  }
};

exports.updateTravel = async (req, res) => {
  try {
    const travel = await Travel.findOne({
      _id: req.params.id,
      userId: req.user.id
    });

    if (!travel) {
      return res.status(404).json({
        message: 'Travel not found or you don\'t have permission'
      });
    }

    Object.assign(travel, req.body);
    await travel.save();

    res.json(travel);
  } catch (error) {
    logger.error('Error updating travel:', error);
    res.status(400).json({
      message: error.message || 'Error updating travel listing'
    });
  }
};

exports.applyForTravel = async (req, res) => {
  try {
    const travel = await Travel.findById(req.params.id);

    if (!travel) {
      return res.status(404).json({ message: 'Travel not found' });
    }

    if (travel.userId.toString() === req.user.id) {
      return res.status(400).json({
        message: 'You cannot apply to your own travel listing'
      });
    }

    const alreadyApplied = travel.applicants.some(
      applicant => applicant.userId.toString() === req.user.id
    );

    if (alreadyApplied) {
      return res.status(400).json({
        message: 'You have already applied for this travel'
      });
    }

    travel.applicants.push({
      userId: req.user.id,
      status: 'pending'
    });

    await travel.save();
    res.json({ message: 'Application submitted successfully' });
  } catch (error) {
    logger.error('Error applying for travel:', error);
    res.status(500).json({
      message: 'Error submitting application'
    });
  }
};