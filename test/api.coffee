assert = require "assert"
request = require "request"
bond = require "bondjs"
request = require "request"
intuitClient = require "../"
config = require "./config"
intuit = intuitClient config
fixture = require "./fixtures"

describe "Intuit API Client", ->
  describe "institutions", ->
    it "should be defined", ->
      assert.notEqual intuit.institutions, undefined

  describe "getInstitutionDetails", ->
    before ->
      fixture.load "getInstitutionDetails"
      @spy = bond(request, "get").through()
    before (done) ->
      intuit.getInstitutionDetails 100000, (err, @institutionDetails) =>
        done err

    it "should request JSON", ->
      assert.equal @spy.calledArgs[0][0].headers["Content-Type"], "application/json"
      assert.equal @spy.calledArgs[0][0].headers["Accept"], "application/json"

    it "should use OAuth data to sign request", ->
      assert @spy.calledArgs[0][0].oauth.consumer_key
      assert @spy.calledArgs[0][0].oauth.consumer_secret
      assert @spy.calledArgs[0][0].oauth.token
      assert @spy.calledArgs[0][0].oauth.token_secret

    it "should return institution details", ->
      assert.equal @institutionDetails.institutionName, "CCBank-Beacon"

  describe "discoverAndAddAccounts", ->
    it "should be defined", ->
      assert.notEqual intuit.discoverAndAddAccounts, undefined

  describe "mfa", ->
    it.skip "should be defined", ->
      assert.notEqual intuit.mfa, undefined

  describe "getCustomerAccounts", ->
    it "should be defined", ->
      assert.notEqual intuit.getCustomerAccounts, undefined

  describe "getAccount", ->
    it "should be defined", ->
      assert.notEqual intuit.getAccount, undefined

  describe "getAccountTransactions", ->
    it "should be defined", ->
      assert.notEqual intuit.getAccountTransactions, undefined

  describe "updateInstitutionLogin", ->
    it "should be defined", ->
      assert.notEqual intuit.updateInstitutionLogin, undefined

  describe "deleteAccount", ->
    it "should be defined", ->
      assert.notEqual intuit.deleteAccount, undefined

  describe "deleteCustomer", ->
    it "should be defined", ->
      assert.notEqual intuit.deleteCustomer, undefined
