const auth = (req, res, next) => {
    if (req.session.user_id) {
        next()
    } else {
        return res.redirect('/')
    }
}

module.exports = auth