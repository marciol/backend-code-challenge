require './config/environment'

require 'rack/cache'
require 'redis-rack-cache'

use Rack::Cache,
	metastore: 'redis://localhost:6379/0/metastore',
  entitystore: 'redis://localhost:6379/0/entitystore',  
  verbose:      true

run Hanami.app
