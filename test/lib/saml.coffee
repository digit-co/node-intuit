assert = require "assert"
fs = require "fs"
Saml = require "../../lib/saml"
config = require "../config"

ENCODING = "base64"

describe "SAML", ->
  describe "signAssertion", ->
    it "should return valid SAML", ->
      samlSignature = new Saml(config).signAssertion()
      samlString = new Buffer(samlSignature, ENCODING).toString()
      assert.equal typeof(samlString), "string"

  describe "sign", ->
    it "should return verifiable signed content", ->
      content = "Data to sign"
      saml = new Saml(config).sign content
      assert.equal true, require("crypto").createVerify("RSA-SHA1").update(content).verify(config.certificate, saml, ENCODING)
