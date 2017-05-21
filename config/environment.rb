require 'bundler/setup'
require 'hanami/setup'
# require 'hanami/model'
require_relative '../lib/hack_commerce'
require_relative '../apps/web/application'
require_relative '../apps/shipping/application'

Hanami.configure do
  mount Shipping::Application, at: '/shipping'
  mount Web::Application, at: '/'

#  model do
    ##
    # Database adapter
    #
    # Available options:
    #
    #  * SQL adapter
    #    adapter :sql, 'sqlite://db/hack_commerce_development.sqlite3'
    #    adapter :sql, 'postgresql://localhost/hack_commerce_development'
    #    adapter :sql, 'mysql://localhost/hack_commerce_development'
    #
    # adapter :sql, ENV['DATABASE_URL']

    ##
    # Migrations
    #
    # migrations 'db/migrations'
    # schema     'db/schema.sql'
#  end

  mailer do
    root 'lib/hack_commerce/mailers'

    # See http://hanamirb.org/guides/mailers/delivery
    delivery :test
  end

  environment :development do
    # See: http://hanamirb.org/guides/projects/logging
    logger level: :debug
  end

  environment :production do
    logger level: :info, formatter: :json

    mailer do
      delivery :smtp, address: ENV['SMTP_HOST'], port: ENV['SMTP_PORT']
    end
  end
end
