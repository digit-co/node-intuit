assert = require "assert"
http = require "http"
bond = require "bondjs"
request = require "request"
intuitClient = require "../"
config = require "./config"
intuit = intuitClient config
helper = require "./helper"
helper.stubOAuth()

describe "Intuit API Client", ->
  describe "institutions", ->
    it "should be defined", ->
      assert.notEqual intuit.institutions, undefined

  describe "getInstitutionDetails", ->
    it "should should send a signed request", (done) ->
      institutionDetails =
        name: "Bank Name"
      spy = bond(http, "request").through()
      intuit.getInstitutionDetails 100000, (err, @institutionDetails) ->
        assert /oauth_signature/.test spy.calledArgs[0][0].headers.Authorization
        done err

    it "should be defined", ->
      assert.notEqual intuit.getInstitutionDetails, undefined

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
