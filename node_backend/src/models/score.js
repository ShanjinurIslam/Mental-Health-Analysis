const mongoose = require('mongoose')

const scoreSchema = new mongoose.Schema({
    scores: [{ rawScore: { type: Number, required: true }, tScore: { type: Number, required: true } }],
    problem: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Problem'
    }
})

const Scores = mongoose.model('Scores', scoreSchema)

module.exports = Scores