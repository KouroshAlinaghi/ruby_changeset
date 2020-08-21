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

params = {
  "name" => "krsh", 
  age: 16, 
  "bruh" => "brrrrrr", 
  password: "krsh/3183", 
  password_confirmation: "somethingelse",
  email: "kouroshalinaghi.gmail.com",
  agree: false
}

changeset = Changeset.new(params)
  .cast(:name, :age, :password, :password_confirmation, :email, :agree)
  .validate_required(:name)
  .validate_length(:name, 5..30)
  .validate_inclusion(:name, ["ali", "mmd"])
  .validate_inclusion(:age, 18..100)
  .validate_confirmation(:password)
  .validate_format(:email, /@/)
  .validate_acceptance(:agree)

puts """
#{changeset.valid?}
#{changeset.changes}
#{changeset.errors}
"""
