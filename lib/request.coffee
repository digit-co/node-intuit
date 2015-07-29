request = require "request"
debug = require("debug")("node-intuit:request")
OAuth = require "./oauth"
SAML_URL = "https://oauth.intuit.com/oauth/v1/get_access_token_by_saml"

module.exports = class Request
  constructor: (@options) ->
    @oauth = new OAuth @options

  _params: (method, url, done) ->
    @oauth.getToken (err, token, tokenSecret) =>
      return done err if err
      params =
        method: method
        uri: url
        headers:
          "Content-Type": "application/json"
          "Accept": "application/json"
        oauth:
          consumer_key: @options.consumerKey
          consumer_secret: @options.consumerSecret
          token: token
          token_secret: tokenSecret
      done err, params

  request: (params, done) ->
    method = if params.method is "DELETE" then params.method.toLowerCase()[0..2] else params.method.toLowerCase()
    requestMethod = request[method]
    requestMethod params, (err, response, body) ->
      debug "#{response.statusCode} - #{response.statusMessage} - #{response.request.uri.path}"
      return done null, response.statusCode if response.statusCode is 200 and not body
      try
        parsed = JSON.parse body
      catch e
        err = e
        parsed = body
      done err, parsed

  get: (url, body, done) ->
    @_params "GET", url, (err, params) =>
      return done err if err
      @request params, done

  post: (url, body, done) ->
    @_params "POST", url, (err, params) =>
      return done err if err
      params.form = body
      @request params, done

  put: (url, body, done) ->
    @_params "PUT", url, (err, params) =>
      return done err if err
      params.form = body
      @request params, done

  delete: (url, body, done) ->
    @_params "DELETE", url, (err, params) =>
      return done err if err
      @request params, done
