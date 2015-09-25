cfg = require "../config"

express = require "express"
passport = require "passport"


router = express.Router()

passport.serializeUser (user, done)->done null, user
passport.deserializeUser (id, done)->done null, id

for n, c of cfg.auth
    
    strategy = require("passport-#{n}").Strategy

    c.callbackURL = "#{cfg.host}:#{cfg.port}/auth/#{n}/callback"
    passport.use new strategy c, (accessToken, refreshToken, profile, done)->
        done null, profile

    router.get "/#{n}"         , passport.authenticate n, c.params
    router.get "/#{n}/callback", 
        passport.authenticate(n, { successRedirect: "/", failureRedirect: "/" }) 


module.exports = router