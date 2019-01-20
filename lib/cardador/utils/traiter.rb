# This is a modification of _why's Creature class from DWEMTHY's array
# The way _why had it, the initialize method would fail if there was not
# at least one trait defined.
require 'cardador/utils/metaid'
module Cardador
  module Utils
    class Traiter
      def self.traits( *arr )
        return @traits if arr.empty?
        attr_accessor *arr
        arr.each do |trait|
          meta_def trait do |val|
            @traits ||= {}
            @traits[trait] = val
          end
        end
        class_def :initialize do
          
          self.class.traits.each do |k,v|
            instance_variable_set( "@#{k}", v )
          end unless (self.class.traits.nil?)
      
        end
      end
    end
  end
end
