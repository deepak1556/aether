Language = require './language'
lua2js = require 'lua2js'
luapegjs = require 'luapegjs'

module.exports = class Lua extends Language
  name: 'Lua'
  id: 'lua'
  parserID: 'luapegjs'
  runtimeGlobals: require('lua2js').stdlib

  obviouslyCannotTranspile: (rawCode) ->
    false

  parse: (code, aether) ->

    ast = luapegjs.parse code
    console.log ast

    ast
