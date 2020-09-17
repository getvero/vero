# frozen_string_literal: true

require 'vero/trackable/base'
require 'vero/trackable/interface'

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
