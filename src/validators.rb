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

  def validate_required(*required_keys, opts) 
    required_keys.each do |key|
      unless @changes.keys.include?(key)
        generate_error_for(key, :required, message)
      end
    end
    self
  end

  def validate_length(key, opts)
    if opts.has_key?(:is)
      cond = @changes[key].length == opts[:is]
    elsif opts.has_key?(:in)
      cond = opts[:in].include? @changes[key].length
    elsif opts.has_key?(:min) && opts.has_key?(:max)
      cond = (opts[:min]..opts[:max]).include? @changes[key].length
    elsif opts.has_key?(:min)
      cond = @changes[key].length >= opts[:min]
    elsif opts.has_key?(:max)
      cond = @changes[key].length <= opts[:max]
    else
      raise "Should define at least one option for validate_length()"
    end
    unless cond
      generate_error_for(key, :length, opts[:message]) 
    end
    self
  end

  def validate_inclusion(key, inclusion, message: nil) 
    unless inclusion.include?(@changes[key])
      generate_error_for(key, :inclusion, message)
    end
    self
  end

  def validate_confirmation(key, message: nil) 
    confirmation_key = "#{key}_confirmation".to_sym
    unless @changes[key] == @changes[confirmation_key]
      generate_error_for(key, :confirmation, message)
    end
    self
  end

  def validate_format(key, regex, message: nil) 
    unless @changes[key].match?(regex)
      generate_error_for(key, :format, message)
    end
    self
  end

  def validate_acceptance(key, message: nil)
    unless @changes[key] == true
      generate_error_for(key, :acceptance, message)
    end
    self
  end

  def validate_number(key, opts)
    if opts.has_key?(:less_than)
      cond = @changes[key] < opts[:less_than]
    elsif opts.has_key?(:greater_than)
      cond = @changes[key] > opts[:greater_than]
    elsif opts.has_key?(:less_than_or_equal_to)
      cond = @changes[key] <= opts[:less_than_or_equal_to]
    elsif opts.has_key?(:greater_than_or_equal_to)
      cond = @changes[key] >= opts[:greater_than_or_equal_to]
    elsif opts.has_key?(:equal_to)
      cond = @changes[key] == opts[:equal_to]
    elsif opts.has_key?(:not_equal_to)
      cond = @changes[key] != opts[:not_equal_to]
    end
    unless cond
      generate_error_for(key, :number, opts[:message]) 
    end
    self
  end
  
  def validate_exclusion(key, exclusion, message: nil)
    if exclusion.include?(@changes[key])
      generate_error_for(key, :exclusion, message)
    end
    self
  end

  def validate_subset(key, arr, message: nil)
    unless @changes[key].all?{|k| arr.include?(k)}
      generate_error_for(key, :subset, message)
    end
    self
  end

  def validate_change(key, message: nil, &validator)
    unless validator.call(@changes[key])
      generate_error_for(key, :custom_validator, message)
    end
    self
  end
end
