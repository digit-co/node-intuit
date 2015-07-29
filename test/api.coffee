assert = require "assert"
request = require "request"
bond = require "bondjs"
request = require "request"
intuitClient = require "../"
config = require "./config"
intuit = intuitClient config
fixture = require "./fixtures"

describe "Intuit Client", ->
  describe "Data", ->
    describe "headers", ->
      before ->
        fixture.load "signedJson"
      before (done) ->
        intuit.getInstitutionDetails "userId", 100000, (@err) =>
          done null

      it "should make a signed request for JSON", ->
        assert.equal @err, null

  describe "API", ->
    describe "institutions", ->
      it "should be defined", ->
        assert.notEqual intuit.institutions, undefined

    describe "getInstitutionDetails", ->
      before ->
        fixture.load "getInstitutionDetails"
        @spy = bond(request, "get").through()
      before (done) ->
        intuit.getInstitutionDetails "userId", 100000, (err, @institutionDetails) =>
          done err

      it "should use OAuth data to sign request", ->
        assert @spy.calledArgs[0][0].oauth.consumer_key
        assert @spy.calledArgs[0][0].oauth.consumer_secret
        assert @spy.calledArgs[0][0].oauth.token
        assert @spy.calledArgs[0][0].oauth.token_secret

      it "should return institution details", ->
        assert.equal @institutionDetails.institutionName, "CCBank-Beacon"

    describe.skip "discoverAndAddAccounts", ->
      it "should return newly created accounts", ->
        assert.notEqual intuit.discoverAndAddAccounts, undefined

    describe.skip "mfa", ->
      it "should handle MFA", ->
        assert.notEqual intuit.mfa, undefined

    describe "getCustomerAccounts", ->
      before ->
        fixture.load "oauth"
        fixture.load "getCustomerAccounts"
      before (done) ->
        intuit.getCustomerAccounts "todd", (err, @accounts) =>
          done err

      it "should return all accounts", ->
        assert.equal @accounts.length, 2

    describe.skip "getAccount", ->
      it "should return an account", ->
        assert.notEqual intuit.getAccount, undefined

    describe.skip "getAccountTransactions", ->
      it "should return transactions", ->
        assert.notEqual intuit.getAccountTransactions, undefined

    describe.skip "updateInstitutionLogin", ->
      it "should update bank credentials", ->
        assert.notEqual intuit.updateInstitutionLogin, undefined

    describe.skip "deleteAccount", ->
      it "should remove the account", ->
        assert.notEqual intuit.deleteAccount, undefined

    describe.skip "deleteCustomer", ->
      it "should remove the user", ->
        assert.notEqual intuit.deleteCustomer, undefined
