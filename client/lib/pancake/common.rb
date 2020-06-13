# frozen_string_literal: true

module Pancake
  MENU_TO_PROTO_VALUE = {
    'classic' => :CLASSIC,
    'banana_and_whip' => :BANANA_AND_WHIP,
    'bacon_and_cheese' => :BACON_AND_CHEESE,
    'mix_berry' => :MIX_BERRY,
    'baked_marshmallow' => :BAKED_MARSHMALLOW,
    'spicy_curry' => :SPICY_CURRY,
  }

  MENU_PROTO_VALUE_TO_STRING = {
    CLASSIC: 'Classic',
    BANANA_AND_WHIP: 'Banana and whip',
    BACON_AND_CHEESE: 'Bacon and cheese',
    MIX_BERRY: 'Mix berry',
    BAKED_MARSHMALLOW: 'Baked marshmallow',
    SPICY_CURRY: 'Spicy curry',
  }
end
