# encoding: utf-8
require 'test_helper'

class HasUrlTest < HasUrlTestCase
  
  context "A new Person instance" do
    setup do
      @person = Person.new :name => 'John Doe'
    end
    
    should "have a blog_link attribute" do
      assert_respond_to @person, :blog_link
      assert_respond_to @person, :blog_link=
    end
    
    should "have a fix_blog_link_url method" do
      assert_respond_to @person, :fix_blog_link_url
    end
    
    should "have class methods from cattr_accessor to store options" do
      assert_respond_to Person, :blog_link_default_scheme
      assert_respond_to Person, :blog_link_valid_schemes
      assert_equal 'http', Person.blog_link_default_scheme
      assert_equal ['http', 'https'], Person.blog_link_valid_schemes
    end
    
    should "be valid" do
      assert @person.valid?
    end
    
    context "with a blank blog_link attribute" do
      setup do
        @person.blog_link = ""
        @person.valid?
      end
      
      should "be valid" do
        assert @person.valid?
      end
      
      should "have a blog_link of nil after validation" do
        assert_equal nil, @person.blog_link
      end
    end
    
    context "with a blog_link equal to nil" do
      setup do
        @person.blog_link = nil
      end
      
      should "be valid" do
        assert @person.valid?
      end
      
      should "have a blog_link of nil after validation" do
        @person.valid?
        assert_equal nil, @person.blog_link
      end
    end
    
    context "with a blog_link equal to example.com" do
      setup do
        @person.blog_link = 'example.com'
      end
      
      should "be valid" do
        assert @person.valid?
      end
      
      should "prepend a http scheme and add a root path after validation" do
        @person.valid?
        assert_equal 'http://example.com/', @person.blog_link
      end
      
      should "have a raw_blog_link equal to example.com after validation" do
        @person.valid?
        assert_equal 'example.com', @person.raw_blog_link
      end
    end
    
    context "with a blog_link equal to www.example.com/profile/me" do
      setup do
        @person.blog_link = 'www.example.com/profile/me'
      end
      
      should "be valid" do
        assert @person.valid?
      end
      
      should "prepend a http scheme after validation" do
        @person.valid?
        assert_equal 'http://www.example.com/profile/me', @person.blog_link
      end
      
      should "have a raw_blog_link equal to www.example.com/profile/me after validation" do
        @person.valid?
        assert_equal 'www.example.com/profile/me', @person.raw_blog_link
      end
    end
    
    context "with a blog_link equal to http://www.example.com/profile/me" do
      setup do
        @person.blog_link = 'http://www.example.com/profile/me'
      end
      
      should "be valid" do
        assert @person.valid?
      end
      
      should "have an unchanged blog_link after validation" do
        @person.valid?
        assert_equal 'http://www.example.com/profile/me', @person.blog_link
      end
      
      should "have a raw_blog_link equal to www.example.com/profile/me" do
        assert_equal 'www.example.com/profile/me', @person.raw_blog_link
      end
    end
    
    context "with an invalid url" do
      setup do
        @person.blog_link = 'é"(_èf&;:§!zoij??"é'
      end
      
      should "have an invalid error on blog_link" do
        assert !@person.valid?
        assert_equal [I18n.t('errors.messages.invalid')], @person.errors[:blog_link]
      end
    end
    
    context "with an url without a scheme or a path and not looking like a domain name" do
      setup do
        @person.blog_link = 'domain'
      end
      
      should "have an invalid error on blog_link" do
        assert !@person.valid?
        assert_equal [I18n.t('errors.messages.invalid')], @person.errors[:blog_link]
      end
    end
    
    context "with an url with an invalid scheme" do
      setup do
        @person.blog_link = 'ftp://example.com'
      end
      
      should "have an invalid error on blog_link" do
        assert !@person.valid?
        assert_equal [I18n.t('errors.messages.invalid')], @person.errors[:blog_link]
      end
    end
  end
  
  context "A new Contact instance" do
    setup do
      @contact = Contact.new
    end
    
    should "have a url and a data_link attributes" do
      assert_respond_to @contact, :url
      assert_respond_to @contact, :url=
      
      assert_respond_to @contact, :data_link
      assert_respond_to @contact, :data_link=
    end
    
    should "have a fix_url_url and a fix_data_link_url methods" do
      assert_respond_to @contact, :fix_url_url
      assert_respond_to @contact, :fix_data_link_url
    end
    
    should "have corresponding raw_ methods" do
      assert_respond_to @contact, :raw_url
      assert_respond_to @contact, :raw_data_link
    end
    
    should "have class methods from cattr_accessor to store options" do
      assert_respond_to Contact, :url_default_scheme
      assert_respond_to Contact, :url_valid_schemes
      assert_equal 'https', Contact.url_default_scheme
      assert_equal ['http', 'https'], Contact.url_valid_schemes
      
      assert_respond_to Contact, :data_link_default_scheme
      assert_respond_to Contact, :data_link_valid_schemes
      assert_equal 'http', Contact.data_link_default_scheme
      assert_equal ['http', 'ftp'], Contact.data_link_valid_schemes
    end
  end
  
  context "A new Client instance" do
    setup do
      @client = Client.new
    end
    
    should "have a pro_link attribute" do
      assert_respond_to @client, :pro_link
      assert_respond_to @client, :pro_link=
    end
    
    should "have a fix_pro_link_url method" do
      assert_respond_to @client, :fix_pro_link_url
    end
    
    should "have class methods from cattr_accessor to store options" do
      assert_respond_to Client, :pro_link_default_scheme
      assert_respond_to Client, :pro_link_valid_schemes
      assert_equal 'http', Client.pro_link_default_scheme
      assert_equal ['http', 'https'], Client.pro_link_valid_schemes
    end
    
    should "provide a custom error message when the link is not valid" do
      @client.pro_link = "invalid"
      assert !@client.valid?
      assert_equal ['does not respect the validations rules'],  @client.errors[:pro_link]
    end
  end
  
  should "throw an error if the default scheme is not included in the valid schemes" do
    assert_raise ArgumentError do
      class InvalidClass < ActiveRecord::Base
        has_url :url, :valid_schemes => ['ftp']
      end
    end
  end
  
#  should "throw an error if a supplied attribute does not exist" do
#    assert_raise ArgumentError do
#      class BadGuy < ActiveRecord::Base
#        has_url :url
#      end
#    end
#  end
end
