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
  end

  def test_cast
    @changeset = Changeset.new(@params).cast(:name, :age)
    assert_equal @changeset.valid?, true
    assert_equal @changeset.changes, {name: "", age: 16}
    assert_equal @changeset.errors, {name: {}, age: {}}
  end

  def test_validate_required
    @changeset = Changeset.new(@params).cast(:name, :email, :age).validate_required(:name, :email)
    assert_equal @changeset.valid?, false
    assert_equal @changeset.changes, {name: "", age: 16, email: "kouroshalinaghi.gmail.com"}
    assert_equal @changeset.errors, {name: {required: "Can't be blank"}, email: {}, age: {}}
  end

  def test_validate_length
    @changeset = Changeset.new(@params).cast(:password, :email, :age).validate_length(:password, min: 8, message: "length_error")
    assert_equal @changeset.valid?, false
    assert_equal @changeset.changes, {age: 16, password: "121212", email: "kouroshalinaghi.gmail.com"}
    assert_equal @changeset.errors, {password: {length: "length_error"}, email: {}, age: {}}
  end

  def test_validate_inclusion
    @changeset = Changeset.new(@params).cast(:email, :agree).validate_inclusion(:agree, [true, false])
    assert_equal @changeset.valid?, true
    assert_equal @changeset.changes, {agree: false, email: "kouroshalinaghi.gmail.com"}
    assert_equal @changeset.errors, {email: {}, agree: {}}
  end

  def test_validate_confirmation
    @changeset = Changeset.new(@params).cast(:password, :password_confirmation).validate_confirmation(:password, message: "Should Match Confirmation")
    assert_equal @changeset.valid?, false
    assert_equal @changeset.changes, {password: "121212", password_confirmation: "something else"}
    assert_equal @changeset.errors, {password: {confirmation: "Should Match Confirmation"}, password_confirmation: {}}
  end

  def test_validate_format
    @changeset = Changeset.new(@params).cast(:email).validate_format(:email, /@/, message: "format message")
    assert_equal @changeset.valid?, false
    assert_equal @changeset.changes, {email: "kouroshalinaghi.gmail.com"}
    assert_equal @changeset.errors, {email: {format: "format message"}}
  end

  def test_validate_acceptance
    @changeset = Changeset.new(@params).cast(:agree).validate_acceptance(:agree, message: "please accept")
    assert_equal @changeset.valid?, false
    assert_equal @changeset.changes, {agree: false}
    assert_equal @changeset.errors, {agree: {acceptance: "please accept"}}
  end

  def test_validate_number
    @changeset = Changeset.new(@params).cast(:age).validate_number(:age, equal_to: 16)
    assert_equal @changeset.valid?, true
    assert_equal @changeset.changes, {age: 16}
    assert_equal @changeset.errors, {age: {}}
  end

  def test_validate_exclusion
    @changeset = Changeset.new(@params).cast(:password).validate_exclusion(:password, ["111111", "123456"])
    assert_equal @changeset.valid?, true
    assert_equal @changeset.changes, {password: "121212"}
    assert_equal @changeset.errors, {password: {}}
  end

  def test_validate_subset
    @changeset = Changeset.new(@params).cast(:pets).validate_subset(:pets, ["dog", "cat", "duck"])
    assert_equal @changeset.valid?, true
    assert_equal @changeset.changes, {pets: ["dog", "cat"]}
    assert_equal @changeset.errors, {pets: {}}
  end

  def test_validate_change
    @changeset = Changeset.new(@params).cast(:age).validate_change(:age, message: "mohmal"){|name| false}
    assert_equal @changeset.valid?, false
    assert_equal @changeset.changes, {age: 16}
    assert_equal @changeset.errors, {age: {custom_validator: "mohmal"}}
  end
end
