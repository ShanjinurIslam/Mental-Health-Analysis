const auth = (req, res, next) => {
    if (req.session.user_id) {
        next()
    } else {
        next()
            //return res.redirect('/')
    }
}

module.exports = auth