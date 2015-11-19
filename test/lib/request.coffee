assert = require "assert"
bond = require "bondjs"
request = require "request"
OAuth = require "../../lib/oauth"
config = require "../config"
fixture = require "../fixtures"
intuit = require("../../")(config)

describe "JSON Authentication", ->
  describe "Request", ->
    before -> @spy = bond(request, "get").through()
    before -> fixture.load "signedJson"
    before (done) ->
      intuit.getInstitutionDetails "userId", 100000, (@err) =>
        done null

    it "should use OAuth data to sign request", ->
      assert typeof @spy.calledArgs[0][0].oauth.consumer_key is "string"
      assert typeof @spy.calledArgs[0][0].oauth.consumer_secret is "string"
      assert typeof @spy.calledArgs[0][0].oauth.token_secret is "string"
      assert typeof @spy.calledArgs[0][0].oauth.token is "string"
    it "should make a signed request for JSON without error", ->
      assert.equal @err, null
