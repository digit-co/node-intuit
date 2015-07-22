Request = require "./request"

BASE_URL = "https://financialdatafeed.platform.intuit.com/v1"

get = (path, options, done) ->
  new Request(options).get "#{BASE_URL}#{path}", done

module.exports = class IntuitClient
  constructor: (@options) ->

  getInstitutionDetails: (institutionId, done) ->
    get "/institutions/#{institutionId}", @options, done
