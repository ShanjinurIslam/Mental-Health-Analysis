const mongoose = require('mongoose')

const responseSchema = new mongoose.Schema({
    /*
    responses: [{
        response: {
            type: Number,
            required: true,
        }
    }],*/
    tScore: {
        type: Number,
        required: true,
    },
    catagory: {
        type: String,
    },
    problem: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Problem'
    },
    user: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User'
    },
    submittedAt: { type: Date, default: Date.now }
})

const Response = mongoose.model('Response', responseSchema)

module.exports = Response