const jwt = require('jsonwebtoken')
const User = require('../models/user')

const api_auth = async(req, res, next) => {
    const token = req.header('Authorization').replace('Bearer ', '')
    const decoded = jwt.decode(token)

    try {
        const user = await User.findById(decoded._id)
        if (!user) {
            return res.status(400).send()
        }
        const isAuth = user.checkAuth(token)

        if (isAuth) {
            req.user = user
            req.token = token
            next()
        } else {
            return res.status(401).send()
        }
    } catch (e) {
        return res.status(502).send(e)
    }

}

module.exports = api_auth