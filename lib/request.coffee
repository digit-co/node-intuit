request = require "request"
OAuth = require "./oauth"

module.exports = class Request
  constructor: (@options) ->
    oauth = new OAuth @options

  _params: (method, url, done) ->
    @oauth.sign method, url, (err, signature) ->
      return done err if err
      params =
        uri: url
        method: method
        headers:
          "Content-Type": "application/json"
          "Authentication": signature
      done err, params

  get: (url, done) ->
    @_params "GET", url, (err, params) ->
      return done err if err
      request params, done
