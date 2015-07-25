assert = require "assert"
http = require "http"
bond = require "bondjs"
request = require "request"
intuitClient = require "../"
config = require "./config"
intuit = intuitClient config
helper = require "./helper"
helper.stubOAuth()

describe "Signed Request", ->
  before (done) ->
    institutionDetails =
      name: "Bank Name"
    @spy = bond(http, "request").through()
    intuit.getInstitutionDetails 100000, (err, @institutionDetails) ->
      done err

  it "should should send a signed request", ->
    assert @spy.calledArgs[0][0].headers.Authorization
