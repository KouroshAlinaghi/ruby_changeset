module Validators 

  def cast(*casted_keys) 
    new_changes = {}
    @changes.each do |k, v|
      if casted_keys.include?(k)
        new_changes[k] = v
      end
    end
    @changes = new_changes
    @errors = @errors.select { |k, v| casted_keys.include?(k) }
    self
  end

  def validate_required(*required_keys) 
    required_keys.each do |key|
      unless @changes.keys.include?(key)
        generate_error_for(key, :required)
      end
    end
    self
  end

  def validate_length(key, range)
    unless range.include?(@changes[key].length)
      generate_error_for(key, :length)
    end
    self
  end

  def validate_inclusion(key, inclusion) 
    unless inclusion.include?(@changes[key])
      generate_error_for(key, :inclusion)
    end
    self
  end

  def validate_confirmation(key) 
    confirmation_key = "#{key}_confirmation".to_sym
    unless @changes[key] == @changes[confirmation_key]
      generate_error_for(key, :confirmation)
    end
    self
  end

  def validate_format(key, regex) 
    unless @changes[key].match?(regex)
      generate_error_for(key, :format)
    end
    self
  end

end
