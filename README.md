# Ruby Changeset
A [Ecto Changeset](https://hexdocs.pm/ecto/Ecto.Changeset.html) like validator for ruby

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

You can visit [Ecto Changeset](https://hexdocs.pm/ecto/Ecto.Changeset.html) for more information about validators.

## Example usage
```
params = {
  "name" => "krsh", 
  age: 16, 
  "uncasted_field" => "brrrrrr", 
  password: "121212", 
  password_confirmation: "something else",
  email: "kouroshalinaghi.gmail.com"
}

changeset = Changeset.new(params)
  .cast(:name, :age, :password, :password_confirmation, :email)
  .validate_required(:name)
  .validate_length(:name, 5..30)
  .validate_inclusion(:name, ["Kourosh", "Ali"])
  .validate_inclusion(:age, 18..100)
  .validate_confirmation(:password)
  .validate_format(:email, /@/)

changeset.valid? # => false
changeset.changes # => {:name=>"krsh", :age=>16, :password=>"121212", :password_confirmation=>"something else", :email=>"kouroshalinaghi.gmail.com"}
changeset.errors # => {:name=>{:length=>"Error For length", :inclusion=>"Error For inclusion"}, :age=>{:inclusion=>"Error For inclusion"}, :password=>{:confirmation=>"Error For confirmation"}, :password_confirmation=>{}, :email=>{:format=>"Error For format"}}
```

## TODO

- [ ] Add more validator methods
- [ ] Make error messages more human-friendly
- [ ] Allow custom error messages