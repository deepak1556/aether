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

  wrap: (rawCode, aether) ->
    @wrappedCodePrefix ?="""
    function #{aether.options.functionName or 'foo'}(#{aether.options.functionParameters.join(', ')})
    \n"""
    @wrappedCodeSuffix ?= "end"

    # Add indentation of 4 spaces to every line
    indentedCode = ('   ' + line for line in rawCode.split '\n').join '\n'

    @wrappedCodePrefix + indentedCode + @wrappedCodeSuffix

  parse: (code, aether) ->

    ast = luapegjs.parse code, {locations: true, range: true}

    ast
