assert = require "assert"
request = require "request"
bond = require "bondjs"
request = require "request"
intuitClient = require "../"
config = require "./config"
intuit = intuitClient config
fixture = require "./fixtures"

describe "Intuit Client", ->
  describe "API", ->
    describe "institutions", ->
      before -> fixture.load "institutions"
      it "should return institutions", (done) ->
        intuit.institutions "userId", (err, institutions) =>
          assert.equal institutions.length, 20
          done err

    describe "getInstitutionDetails", ->
      before -> fixture.load "getInstitutionDetails"
      it "should return an institution's details", (done) ->
        intuit.getInstitutionDetails "userId", 100000, (err, institutionDetails) ->
          assert.equal institutionDetails.institutionName, "CCBank-Beacon"
          done err

    describe.skip "discoverAndAddAccounts", ->
      it "should return newly created accounts", ->
        assert.notEqual intuit.discoverAndAddAccounts, undefined

    describe.skip "mfa", ->
      it "should handle MFA", ->
        assert.notEqual intuit.mfa, undefined

    describe "getCustomerAccounts", ->
      before -> fixture.load "oauth"
      before -> fixture.load "getCustomerAccounts"
      it "should return all accounts", (done) ->
        intuit.getCustomerAccounts "todd", (err, accounts) =>
          assert.equal accounts.length, 2
          done err

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
