request = require "request"
nonce = require("nonce")()
Saml = require "./saml"

SAML_URL = "https://oauth.intuit.com/oauth/v1/get_access_token_by_saml"
ENCODING = "base64"

serialize = (params) ->
  str = []
  for k, v of params
    str.push "#{encodeURIComponent(k)}=#{encodeURIComponent(v)}"
  return str.join("&")

module.exports = class OAuth
  constructor: (@options) ->
    @saml = new Saml(@options).signAssertion()

  parseResponse: (responseBody) ->
    console.log unescape responseBody
    [oauthToken, oauthSecret] = responseBody.split "&"
    token = oauthToken?.split("=")?[1]
    secret = oauthSecret?.split("=")?[1]
    return {token, secret}

  request: (params, done) ->
    # TODO: replace with a fixture
    if process.env.NODE_ENV is "test"
      return done null, {token: "token", secret: "secret"}
    else
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
      done err, oauth?.token, oauth?.secret

  _params: ->
    "oauth_consumer_key": @options.consumerKey
    "oauth_nonce": nonce()
    "oauth_signature_method": "HMAC-SHA1"
    "oauth_timestamp": Math.floor((new Date()).getTime() / 1000)
    "oauth_version": "1.0"

  sign: (method, url, done) ->
    @getToken (err, token, secret) =>
      signatureBase = "#{method}&#{url}&#{serialize @_params()}"
      key = "#{@options.consumerKey}&#{@options.consumerSecret}"
      url = "#{signatureBase}"
      hash = require("crypto").createHmac("sha1", key).update(url).digest ENCODING
      done null, hash
