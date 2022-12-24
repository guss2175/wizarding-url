class ApplicationSerializer < ActiveModel::Serializer
  def attributes *_options
    type = (instance_options[:type] || :default).to_s.upcase
    # if serializer has defined a constant with name eq to `instance_option[:type]` before
    # then attributes is overrided by `attributes(instance_options[:type])`
    attrs = self.class.const_defined?(type) ? self.class.const_get(type) : self.class._attributes

    attrs.index_with do |attr|
      respond_to?(attr) ? public_send(attr) : object.send(attr)
    end
  end
end
