require_relative "../lib/changeset"
require "minitest/autorun"

class ChangesetTest < Minitest::Test
  def setup
    @params = {
      "name" => "", 
      age: 16, 
      "bruh" => "brrrrrr", 
      password: "121212", 
      password_confirmation: "something else",
      email: "kouroshalinaghi.gmail.com",
      agree: false,
      pets: ["dog", "cat"]
    }
    @changeset = Changeset.new(@params)
      .cast(:name, :age, :password, :password_confirmation, :email, :agree, :pets)
      .validate_required(:name)
      .validate_length(:name, in: 5..30)
      .validate_inclusion(:name, ["ali", "mmd"])
      .validate_inclusion(:age, 18..100)
      .validate_confirmation(:password, message: "Should Match Confirmation")
      .validate_format(:email, /@/)
      .validate_acceptance(:agree)
      .validate_number(:age, not_equal_to: 45)
      .validate_exclusion(:password, ["111111", "123456"])
      .validate_length(:password, min: 6)
      .validate_subset(:pets, ["dog", "cat", "duck"])
      .validate_change(:pets){|c| true }
  end

  def test_valid
    assert_equal @changeset.valid?, false
  end

  def test_changes
    assert_equal @changeset.changes, {pets: ["dog", "cat"], agree: false, :name=>"", :age=>16, :password=>"121212", :password_confirmation=>"something else", :email=>"kouroshalinaghi.gmail.com"}
  end

  def test_errors
    assert_equal @changeset.errors, {pets: {}, agree: {acceptance: "Is not true"}, :name=>{:length=>"Length does not match", :inclusion=>"Is not included in enumerable", :required => "Can't be blank"}, :age=>{:inclusion=>"Is not included in enumerable"}, :password=>{:confirmation=>"Should Match Confirmation"}, :password_confirmation=>{}, :email=>{:format=>"Does not match the regex"}}
  end
end
