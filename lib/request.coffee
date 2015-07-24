request = require "request"
OAuth = require "./oauth"

module.exports = class Request
  constructor: (@options) ->
    @oauth = new OAuth @options

  _params: (method, url, done) ->
    @oauth.sign method, url, (err, signature) ->
      return done err if err
      params =
        method: method
        uri: url
        headers:
          "Content-Type": "application/json"
          "Authentication": signature
      done err, params

  get: (url, body, done) ->
    @_params "GET", url, (err, params) ->
      return done err if err
      request params, done

  post: (url, body, done) ->
    @_params "POST", url, (err, params) ->
      return done err if err
      params.body = body
      request params, done

  put: (url, body, done) ->
    @_params "PUT", url, (err, params) ->
      return done err if err
      params.body = body
      request params, done

  delete: (url, body, done) ->
    @_params "PUT", url, (err, params) ->
      return done err if err
      request params, done
