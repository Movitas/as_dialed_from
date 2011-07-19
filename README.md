# as_dialed_from

Figure out how a number should be dialed from another country.
A fork of a port of Google's libphonenumber.

## Examples

as_dialed_from prototypes the String class with an as_dialed_from method.

```rb
"+12155551212".as_dialed_from "US"
 => "12155551212"

"+12155551212".as_dialed_from 52 # Mexico
 => "0012155551212"
 
"+12155551212".as_dialed_from "74957285000" # Russia
 => "8~1012155551212"
```

The "from" argument can be one of many things

* An ISO 3166-2 code (`"US"`)
* Any valid country code digits, as an Integer (`1`) or String (`"1"`)
* If a phone number is passed, it will try to find the country code for that number (`"12155551212"`)

## Installing

### Shell

```sh
gem install as_dialed_from
```

### Gemfile

```rb
gem 'as_dialed_from'
```

And then `bundle install`
