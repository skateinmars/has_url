# encoding: utf-8
require 'has_url/validations'

ActiveRecord::Base.send :extend, HasUrl::Validations
