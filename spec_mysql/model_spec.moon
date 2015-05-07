db = require "lapis.db.mysql"

import setup_db, teardown_db from require "spec_mysql.helpers"
import drop_tables from require "lapis.spec.db"

import Model, enum from require "lapis.db.mysql.model"
import types, create_table from require "lapis.db.mysql.schema"

class Users extends Model
  @create_table: =>
    drop_tables @
    create_table @table_name!, {
      {"id", types.id}
      {"name", types.text}
    }

describe "model", ->
  setup ->
    setup_db!

  teardown ->
    teardown_db!

  describe "basic model", ->
    before_each ->
      Users\create_table!

    it "should find on empty table", ->
      nothing = Users\find 1
      assert.falsy nothing

    it "should insert new rows with autogenerated id", ->
      first = Users\create { name: "first" }
      second = Users\create { name: "second" }

      assert.same 1, first.id
      assert.same "first", first.name

      assert.same 2, second.id
      assert.same "second", second.name

      assert.same 2, Users\count!

    it "should get columns of model", ->
      assert.same {
        {
          "Extra": "auto_increment"
          "Field": "id"
          "Key": "PRI"
          "Null": "NO"
          "Type": "int(11)"
        }
        {
          "Extra": ""
          "Field": "name"
          "Key": ""
          "Null": "NO"
          "Type": "text"
        }
      }, Users\columns!
