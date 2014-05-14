Aether = require '../aether'

describe "Lua test Suite!", ->
  describe "Lua compilation", ->
    aether = new Aether language: "lua"
    it "Should compile functions", ->
      code = """
        sum = 0
        while i<5 do
          sum = sum + i
        end 
      """
      aether.transpile(code)