# This is a portion of the War library, a library of utilities
# and methods for wargaming.
#
#
# Author::    Matt Williams  (mailto:matt@aetherical.com)
# Copyright:: Copyright (c) 2008 Matthew Williams, All Rights Reserved
# License::   MIT License

require 'yaml'

module Cardador
  module Utils
    # This class loads and creates classes which have been defined in
    # a yaml file.  The file is expected to contain two elements,
    # templates and classes.  A sample file looks like:
    # ---
    # templates:
    #   soldier:
    #     movement: 1
    #     vision: 1
    #     zone_of_control: 1
    #     range: 1
    # classes:
    # - name: militia
    #   template: soldier
    #   attributes:
    #     strength: 50
    #     attack: -10
    #     defence: 10
    #     cost: 50
    #     symbol: m
    #
    # The classes are then created from the information in the yaml file
    class Loader
      # This method loads the classes defined in the yaml file.
      # +parent+ represents the parent class of classes being loaded;
      # if not present, it's expected to be in the yaml.
      def self.load_classes(file, parent = Object)
        begin
          y = YAML.load(File.open(file))
          templates = y["templates"] || { }
          klasses = y["classes"] || []
          klasses.each do |klass|
            puts klass['name']
            k = Object.const_set(klass['name'].capitalize,
                                 Class.new(parent || Object.const_get(klass['parent'].capitalize)))
            k.class_eval  <<EOF
  #{(klass['traits'].nil? ? "" : "traits #{klass['traits'].map{ |trait| ":#{trait}"}.join(",")}")}
  #{(templates["#{klass['template']}"] || {}).merge((klass['attributes'] || {})).sort.map{|t| t[1]="\"#{t[1]}\"" if t[1].instance_of?(String); t.join(" ").downcase}.join("\n")}
EOF
          end
        rescue Exception => e
          puts "Error parsing File #{file}: #{e}"
        end
      end
    end
  end
end
