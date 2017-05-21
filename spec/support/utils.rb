def without_timestamps(data)
  h = if Hash === data
        data
      elsif data.respond_to?(:to_h)
        data.to_h
      else
        raise ArgumentError, 'data argument must be a hash or respond to to_h method'
      end
  h.delete_if { |k, _| %i(created_at updated_at).include?(k) }
end
