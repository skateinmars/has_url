module HasUrl
  require 'rails'

  class Railtie < Rails::Railtie # :nodoc:
    railtie_name :has_url

    initializer 'has_url.insert_into_active_record' do |app|
      ActiveSupport.on_load :active_record do
        require 'has_url/hooks'
        HasUrl::Hooks.init
      end
    end
  end
end
