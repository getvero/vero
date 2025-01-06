# frozen_string_literal: true

module Vero
  module Trackable
    include Base
    include Interface

    def self.included(base)
      @vero_trackable_map = []
      base.extend(Base::ClassMethods)
    end
  end
end
