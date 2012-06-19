# encoding: utf-8
require 'test/unit'
require 'active_support'
require 'active_support/test_case'
require 'active_record'
require 'sqlite3'
require 'shoulda'

require 'has_url/hooks'
HasUrl::Hooks.init

class Person < ActiveRecord::Base
  validates_presence_of :name
  
  has_url :blog_link
end

class Contact < ActiveRecord::Base
  has_url :url, :default_scheme => 'https'
  has_url :data_link, :valid_schemes => ['http', 'ftp']
end

class Client < ActiveRecord::Base
  has_url :pro_link, :message => 'does not respect the validations rules'
end

ActiveRecord::Schema.verbose = false
ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

def setup_db
  ActiveRecord::Schema.define(:version => 1) do
    create_table :people do |t|
      t.column :name, :string
      t.column :blog_link, :string
    end
    
    create_table :contacts do |t|
      t.column :url, :string
      t.column :data_link, :string
    end
    
    create_table :clients do |t|
      t.column :pro_link, :string
    end
    
    create_table :bad_guys do |t|
      t.column :name, :string
    end
  end
end
 
def teardown_db
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end
end
 
class HasUrlTestCase < ActiveSupport::TestCase
  def setup
    setup_db
  end
  
  def teardown
    teardown_db
  end
end
