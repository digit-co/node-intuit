assert = require "assert"
intuitClient = require "../"
config = require "./config"
intuit = intuitClient config

describe "Intuit API Client", ->
  describe "institutions", ->
    it "should be defined", ->
      assert.notEqual intuit.institutions, undefined

  describe "getInstitutionDetails", ->
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
