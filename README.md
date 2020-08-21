# Ruby Changeset
An [Ecto Changeset](https://hexdocs.pm/ecto/Ecto.Changeset.html) like validator for ruby

## Fields
| Key | Type | Example |
| --- | ---- | ------- |
| changes | hash {} | `{name: "Kourosh"}` |
| errors | hash {} | `{name: {required: "Can't Be Blank"}}` |

There is also a `#valid?` instance method that returns boolean based on `@errors`

## List of available validators
* `validate_required()`
* `validate_length()`
* `validate_inclusion()`
* `validate_confirmation()`
* `validate_format()`
* `validate_acceptance()`
* `validate_number()`
* `validate_subset()`
* `validate_change()`
* `validate_exclusion()`

You can visit [Ecto Changeset](https://hexdocs.pm/ecto/Ecto.Changeset.html) for more information about validators.

## Example usage
```
params = {
  "name" => "krsh", 
  age: 16, 
  "bruh" => "brrrrrr", 
  password: "121212", 
  password_confirmation: "something else",
  email: "kouroshalinaghi.gmail.com",
  agree: false,
  pets: ["dog", "cat"]
}

changeset = Changeset.new(@params)
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

changeset.valid? # => false
changeset.changes # => {pets: ["dog", "cat"], agree: false, :name=>"krsh", :age=>16, :password=>"121212", :password_confirmation=>"something else", :email=>"kouroshalinaghi.gmail.com"}
changeset.errors # => {pets: {}, agree: {acceptance: "Is not true"}, :name=>{:length=>"Length does not match", :inclusion=>"Is not included in enumerable"}, :age=>{:inclusion=>"Is not included in enumerable"}, :password=>{:confirmation=>"Should Match Confirmation"}, :password_confirmation=>{}, :email=>{:format=>"Does not match the regex"}}
```

## TODO

- [x] Add more validator methods
- [x] Make error messages more human-friendly
- [x] Allow custom error messages
