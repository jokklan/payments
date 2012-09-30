# Payments
## About

Payments is a flexible payment solution. It uses [Active Merchant](https://github.com/Shopify/active_merchant) to handle transactions with 3'th party payment gateways (se [homepage](https://github.com/Shopify/active_merchant) for list of supported payment providers).

## Install
Add this line to your applications `Gemfile`

Open up your `Gemfile` and add at the bottom this line:

```ruby
gem 'payments', '~> 1.0.0'
```

Next to install, and generate migration run:

```bash
bundle install
rails generate payments:install
rake db:migrate
```

This generator will create a transaction table and a config file under initializers.
Finally you need to add some attributes and methods to your order model. You can do this by running this generator:

```bash
rails generate payments MODEL
```

Replace MODEL by the class name used for the applications orders, it's usually just 'Order'. This will create a model (if one does not exist) and configure it with default Payments methods. Next, you'll usually run "rake db:migrate" as the generator will have created a migration file (if your ORM supports them). This generator also configures your config/routes.rb file to point to the Payments controller.

Note that you should re-start your app here if you've already started it.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

