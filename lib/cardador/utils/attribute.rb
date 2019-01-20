class Object
  def self.attribute(*arg,&block)
    (name, default) = arg
    short_name = name.to_s.sub(/\?/,"")
    self.send(:define_method, name) {
      if instance_variables.include? "@#{short_name}"
           self.instance_eval "@#{short_name}"
      else
        if block_given?
          instance_eval &block
        else
          default
        end
      end
    }
    self.send(:define_method, "#{short_name}="){ |value|
      self.instance_eval "@#{short_name} = value"
    }
  end
end
