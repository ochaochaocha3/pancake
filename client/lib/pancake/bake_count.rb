# frozen_string_literal: true

require_relative 'common'

module Pancake
  BakeCount = Struct.new(:menu, :count, keyword_init: true) do
    def self.from_proto_obj(o)
      new(
        menu: MENU_PROTO_VALUE_TO_STRING[o.menu],
        count: o.count
      )
    end
  end
end
