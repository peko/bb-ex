
cfg = require "../config"

express = require "express"
passport = require "passport"

router = express.Router()

router.get "/infographics", (req, res)->

    return res.send "{err: 1}" unless req.isAuthenticated()
    res.send JSON.stringify req.user
        

router.get "/method2", (req,res)->

    return res.send "{err: 1}" unless req.isAuthenticated()
    res.send JSON.stringify req.user

module.exports = router
