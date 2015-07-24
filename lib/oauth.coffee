request = require "request"
nonce = require("nonce")()
{sign} = require("oauth-sign")
Saml = require "./saml"

SAML_URL = "https://oauth.intuit.com/oauth/v1/get_access_token_by_saml"
ENCODING = "base64"

module.exports = class OAuth
  constructor: (@options) ->
    @saml = new Saml(@options).signAssertion()

  parseResponse: (responseBody) ->
    [oauthTokenSecret, oauthToken] = responseBody.split "&"
    tokenSecret = oauthTokenSecret?.split("=")?[1]
    token = oauthToken?.split("=")?[1]
    return {token, tokenSecret}

  request: (params, done) ->
    request params, (err, response, body) =>
      return done err if err
      done err, @parseResponse body

  getToken: (done) ->
    params =
      uri: SAML_URL
      method: "POST"
      headers:
        "Authorization": "OAuth oauth_consumer_key=\"#{@options.consumerKey}\""
      form:
        saml_assertion: @saml
    @request params, (err, oauth) ->
      done err, oauth?.token, oauth?.tokenSecret

  _params: ->
    "oauth_consumer_key": @options.consumerKey
    "oauth_nonce": nonce()
    "oauth_signature_method": "HMAC-SHA1"
    "oauth_timestamp": Math.floor(Date.now() / 1000).toString()
    "oauth_version": "1.0"

  sign: (method, url, done) ->
    @getToken (err, token, tokenSecret) =>
      signature = sign "HMAC-SHA1", method, url, @_params(), @options.consumerSecret, tokenSecret
      done err, signature
