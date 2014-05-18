Aether = require '../aether'

describe "Lua test Suite!", ->
  describe "Basic compilation", ->
    aether = new Aether language: "lua"
    it "Should return stuff", ->
      code = """
        return 1000 
      """
      aether.transpile(code)
      expect(aether.run()).toEqual 1000

    it "Perform arithmetic operations", ->
      code = "
        return (2*2 + 2/2 - 2*2/2)
      "
      aether.transpile(code)
      expect(aether.run()).toEqual 3