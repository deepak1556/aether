﻿_ = window?._ ? self?._ ? global?._ ? require 'lodash'  # rely on lodash existing, since it busts CodeCombat to browserify it--TODO

parser = require 'filbert'
parser_loose = require 'filbert/filbert_loose'

Language = require './language'

module.exports = class Python extends Language
  name: 'Python'
  id: 'python'
  parserID: 'filbert'
  runtimeGlobals:
    __pythonRuntime: parser.pythonRuntime

  hasChangedASTs: (a, b) ->
    try
      [aAST, bAST] = [null, null]
      options = {locations: false, ranges: false}
      aAST = parser_loose.parse_dammit a, options
      bAST = parser_loose.parse_dammit b, options
      unless aAST and bAST
        return true
      return not _.isEqual(aAST, bAST)
    catch error
      return true

  # Wrap the user code in a function. Store @wrappedCodePrefix and @wrappedCodeSuffix.
  wrap: (rawCode, aether) ->
    @wrappedCodePrefix ?="""
    def #{aether.options.functionName or 'foo'}(#{aether.options.functionParameters.join(', ')}):
    \n"""
    @wrappedCodeSuffix ?= "\n"

    # Add indentation of 4 spaces to every line
    indentedCode = ('    ' + line for line in rawCode.split '\n').join '\n'

    @wrappedCodePrefix + indentedCode + @wrappedCodeSuffix

  # Using a third-party parser, produce an AST in the standardized Mozilla format.
  parse: (code, aether) ->
    ast = parser.parse code, {locations: false, ranges: true}
    selfToThis ast
    ast

  parseDammit: (code, aether) ->
    try
      ast = parser_loose.parse_dammit code, {locations: false, ranges: true}
      selfToThis ast
    catch error
      ast = {type: "Program", body:[{"type": "EmptyStatement"}]}
    ast


# 'this' is not a keyword in Python, so it does not parse to a ThisExpression
# Instead, we expect the variable 'self', and map it to a ThisExpression
selfToThis = (ast) ->
  ast.body[0].body.body.unshift {"type": "VariableDeclaration","declarations": [{ "type": "VariableDeclarator", "id": {"type": "Identifier", "name": "self" },"init": {"type": "ThisExpression"} }],"kind": "var"}
  ast
