const jwt = require('jsonwebtoken')

const api_auth = (req, res, next) => {
    const token = req.header('Authorization').replace('Bearer ', '')
    const decoded = jwt.decode(token)
    req.user_id = decoded._id
    req.token = token
    next()
}

module.exports = api_auth