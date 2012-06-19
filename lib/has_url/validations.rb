require 'active_record'
require 'addressable/uri'

module HasUrl # :nodoc:
  module Validations
    
    # This allows you to specify attributes you want to define as containing
    # a url. This will validate the URI and prepend a http scheme if needed.
    # Provide this with a required attributes array (or a single attribute symbol) and an options hash.
    #
    # ==== Examples
    #
    # class Person < ActiveRecord::Base
    #   has_url :blog_link
    # end
    #
    # class Person < ActiveRecord::Base
    #   has_url [:blog_link, :website_url]
    # end
    #
    # ===== Using options
    #
    # class Person < ActiveRecord::Base
    #   has_url :blog_link, {:valid_schemes => ['http', 'https', 'ftp'], :default_scheme => 'http', :message => 'does not look like a valid url'}
    # end
    #
    def has_url(attributes, options = {})
      attributes = [attributes].flatten
      
      options.reverse_merge!({:valid_schemes => ['http', 'https'], :default_scheme => 'http' })
      
      raise ArgumentError, "default scheme does not match a valid scheme" unless options[:valid_schemes].include?(options[:default_scheme])
      
      attributes.each do |attribute|
        #Doesnt work, raises ActiveRecord::ConnectionNotEstablished
        #raise ArgumentError, "attribute #{attribute} does not exist" if self.columns.select{|c| c.name == attribute }.empty?
        
        default_scheme_accessor = "#{attribute}_default_scheme".to_sym
        valid_schemes_accessor = "#{attribute}_valid_schemes".to_sym
        cattr_accessor default_scheme_accessor
        self.send("#{default_scheme_accessor}=", options[:default_scheme])
        cattr_accessor valid_schemes_accessor
        self.send("#{valid_schemes_accessor}=", options[:valid_schemes])
        
        define_method( "fix_#{attribute}_url") do
          value = read_attribute(attribute)
          if value.blank?
            value = nil
          else
            begin
              default_scheme = self.class.send("#{attribute}_default_scheme".to_sym)
              uri = Addressable::URI.heuristic_parse(value, {:scheme => default_scheme}).normalize
              value = uri.to_s
            rescue Addressable::URI::InvalidURIError
            end
          end
          write_attribute( attribute, value )
        end
        
        define_method( "raw_#{attribute}") do
          value = read_attribute(attribute)
          if value.blank?
            return nil
          else
            return value.sub('http://', '').sub('https://', '').sub(/\/$/, '')
          end
        end
        
        before_validation "fix_#{attribute}_url".to_sym
      end
      
      validates_each attributes do |record, attr, value|
        if !value.nil?
          if defined?(I18n)
            message = options[:message] ? options[:message] : :invalid
            error_args = [attr, message, {:value => value}]
          else
            error_args = [attr]
            error_args << options[:message] if options[:message]
          end
          
          begin
            uri = Addressable::URI.heuristic_parse(value).normalize
            scheme_is_valid = self.send("#{attr}_valid_schemes".to_sym).include?(uri.scheme)
            record.errors.add(*error_args) unless scheme_is_valid
          rescue Addressable::URI::InvalidURIError
            record.errors.add(*error_args)
          end
        end
      end
    end
      
  end
end