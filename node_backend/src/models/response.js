const mongoose = require('mongoose')

const responseSchema = new mongoose.Schema({
    responses: [{
        response: {
            type: Number,
            required: true,
        }
    }],
    catagory: {
        type: String,
        required: true,
    },
    problem: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Problem'
    },
    user: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User'
    },
    submittedAt: {
        type: Date,
    }
})

const Response = mongoose.model('Response', responseSchema)

module.exports = Response