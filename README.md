# Ringcaptcha API
Wrapper for using [Ringcaptcha](http://ringcaptcha.com/)'s API.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'ringcaptcha', git: 'https://github.com/paolodona/ringcaptcha.git'
```

And then execute:

    $ bundle
    
## Setup
In order to properly use the Ringcaptcha gem, it must be initialized by supplying your Ringcaptcha API key, as seen in the following code sample (which you could place in config/initializers/ringcaptcha.rb, if you are using rails):

```ruby
Ringcaptcha.api_key = '12345678901234567890' # your actual key will obviously differ from this
```

## Application keys
All calls using the gem are performed on behalf of a specific application registered with Ringcaptcha. For this reason, all calls receive an application key as their first argument. While we will denote this application key as `app_key` in all the following example, your actual application key will, of course, be different.

## Usage
###Normalize phone numbers:

```ruby
response = Ringcaptcha.normalize('app_key', '353 083 148 0349')

response.success?   #=> true
response.error?     #=> false
response.status     #=> "SUCCESS"
response.phone      #=> "+353831480349"
response.country    #=> "IE"
response.area       #=> nil
response.block      #=> nil
response.subscriber #=> nil
response.type       #=> "MOBILE"
response.carrier    #=> "Vodafone"
```

###Verify a phone number:

```ruby
# Step 1 - Send a PIN code to the phone number
 
phone = "+353831480349"
service = "sms"
code_response = Ringcaptcha.code('app_key', token, phone, service)

# Step 2 - Verify the PIN code

code = "1234" # You should request this from the PIN code recipient
verification_response = Ringcaptcha.verify('app_key', code_response.token, code)

verification_response #=> #<Ringcaptcha::Response status="SUCCESS",id="2381555c031619e61b3f81af30445b27a87ae97a", phone="+353831480349", geolocation=1, phone_type="MOBILE", carrier="Vodafone", threat_level="LOW">
```

## Test mode
The gem supports a test mode that eschews all communication with Ringcaptcha in favor of returning static, successful results. Test mode will be used if the application key supplied begins with "test", as in the example below:

```ruby
response = Ringcaptcha.verify('test_app_key', 'fake token', 'impossible code')

response #=> #<Ringcaptcha::Response status="SUCCESS",id="UUUUUUUUUUUUUUU", phone="+1234567890", geolocation=0, phone_type="MOBILE", carrier="AT&T", threat_level="LOW">
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
