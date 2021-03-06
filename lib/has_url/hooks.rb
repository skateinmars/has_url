module HasUrl
  class Hooks # :nodoc:
    def self.init
      if defined?(ActiveRecord)
        require 'has_url/validations'
        ActiveRecord::Base.send(:extend, HasUrl::Validations)
      end
    end
  end
end
