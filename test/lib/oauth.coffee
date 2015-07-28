assert = require "assert"
bond = require "bondjs"
request = require "request"
OAuth = require "../../lib/oauth"
config = require "../config"
helper = require "../helper"
helper.stubOAuth(3)

describe "OAuth", ->
  describe "getToken", ->
    before -> @spy = bond(request, "post").through()
    before (done) ->
      oauth = new OAuth config
      oauth.getToken (@err, @token, @secret) =>
        done @err
    after -> @spy.restore()

    it "should return an OAuth token", ->
      assert.equal @err, null
      assert @token
      assert @secret

    it "should have an Authorization header with the consumer key", ->
      regex = new RegExp "#{config.consumerKey}"
      assert regex.test @spy.calledArgs[0][0].headers.Authorization

  describe "parseResponse", ->
    it "should parse the response for a token and a secret", ->
      oauth = new OAuth config
      response = "oauth_token_secret=L63cI4q5UhP4mQzpCi1RHBMSLe2TNOaI98vxyIBL&oauth_token=qyprdcvDh5V2XoJRwYmxxdL5vOJ54Z6sNVohlNLQHyyhHaAy"
      {token, tokenSecret} = oauth.parseResponse response
      assert token
      assert tokenSecret
