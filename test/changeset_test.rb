require_relative "../src/changeset"
require "minitest/autorun"

class ChangesetTest < Minitest::Test
  def setup
    @params = {
      "name" => "krsh", 
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
      .validate_confirmation(:password)
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
    assert_equal @changeset.changes, {pets: ["dog", "cat"], agree: false, :name=>"krsh", :age=>16, :password=>"121212", :password_confirmation=>"something else", :email=>"kouroshalinaghi.gmail.com"}
  end

  def test_errors
    assert_equal @changeset.errors, {pets: {}, agree: {acceptance: "Error For acceptance"}, :name=>{:length=>"Error For length", :inclusion=>"Error For inclusion"}, :age=>{:inclusion=>"Error For inclusion"}, :password=>{:confirmation=>"Error For confirmation"}, :password_confirmation=>{}, :email=>{:format=>"Error For format"}}
  end
end