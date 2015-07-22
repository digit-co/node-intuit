assert = require "assert"
intuitClient = require "../"
config = require "./config"
intuit = intuitClient config

describe "Intuit API", ->
  describe "getInstitutionDetails", ->
    it "should be defined", ->
      assert.notEqual intuit.getInstitutionDetails, undefined
