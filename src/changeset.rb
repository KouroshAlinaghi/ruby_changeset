require_relative 'validators'
require_relative 'messages'

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

  def generate_error_for(key, validation, message)
    if @errors[key].nil?
      @errors[key] = {}
    end
    @errors[key][validation] = message || Messages.const_get("#{validation}_MESSAGE".upcase.to_sym)
  end

  def symbolized_keys(hash) 
    sym_keys = {}
    hash.each do |k, v|
      sym_keys[k.to_sym] = v
    end
    sym_keys
  end

end

