require_relative 'validators'

class Changeset 

  include Validators

  attr_reader :changes, :errors
  def initialize(params) 
    @changes = symbolized_keys(params)
    @errors = {}
    @changes.keys.each do |k|
      @errors[k] = {} 
    end
  end

  def valid? 
    @errors.values.all?(&:empty?)
  end
  
  private

  def generate_error_for(key, validation)
    if @errors[key].nil?
      @errors[key] = {}
    end
    @errors[key][validation] = "Error For #{validation}"
  end

  def symbolized_keys(hash) 
    sym_keys = {}
    hash.each do |k, v|
      sym_keys[k.to_sym] = v
    end
    sym_keys
  end

end

