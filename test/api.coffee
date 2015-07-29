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

    describe "discoverAndAddAccounts", ->
      it "should return newly created accounts"

    describe "mfa", ->
      it "should handle MFA"

    describe "getCustomerAccounts", ->
      before -> fixture.load "getCustomerAccounts"
      it "should return all accounts", (done) ->
        intuit.getCustomerAccounts "userId", (err, accounts) ->
          assert.equal accounts.length, 2
          done err

    describe "getAccount", ->
      before -> fixture.load "getAccount"
      it "should return an account", (done) ->
        intuit.getAccount "userId", 400107846787, (err, account) ->
          assert.equal account.bankingAccountType, "CHECKING"
          done err

    describe "getAccountTransactions", ->
      it "should return transactions"

    describe "updateInstitutionLogin", ->
      it "should update bank credentials"

    describe "deleteAccount", ->
      before -> fixture.load "deleteAccount"
      it "should remove the account", (done) ->
        intuit.deleteAccount "userId", 400107846793, (err, response) ->
          assert.equal response, 200
          done err

    describe "deleteCustomer", ->
      it "should remove the user"
