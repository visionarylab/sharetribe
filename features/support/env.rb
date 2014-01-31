# IMPORTANT: This file is generated by cucumber-rails - edit at your own peril.
# It is recommended to regenerate this file in the future when you upgrade to a 
# newer version of cucumber-rails. Consider adding your own code to a new file 
# instead of editing this one. Cucumber will automatically load all features/**/*.rb
# files.

require 'rubygems'
require File.expand_path('../../../test/helper_modules', __FILE__)
include TestHelpers

require 'cucumber/rails'
require 'email_spec/cucumber'
 

# NOTE: Zeus doesn't load this part, it only runs custom_plan.rb and each_run block  
prefork = lambda {
  #puts "CUCUMBER PREFORK"
 
  # Uncomment this if needed to keep the browser open after the test
  # Capybara::Selenium::Driver.class_eval do
  #   def quit
  #     puts "Press RETURN to quit the browser"
  #     $stdin.gets
  #     @browser.quit
  #   rescue Errno::ECONNREFUSED
  #     # Browser must have already gone
  #   end
  # end

  # Default categories and share types
  # CategoriesHelper.load_test_categories_and_transaction_types_to_db
}
 
each_run = lambda {

  #puts "CUCUMBER EACH_RUN"

  # Capybara defaults to XPath selectors rather than Webrat's default of CSS3. In
  # order to ease the transition to Capybara we set the default here. If you'd
  # prefer to use XPath just remove this line and adjust any selectors in your
  # steps to use the XPath syntax.
  Capybara.default_selector = :css
  Capybara.ignore_hidden_elements = true
  # These settigs could be in prefork block, but Zeus wouldn't run that, so moved here.

  # By default, any exception happening in your Rails application will bubble up
  # to Cucumber so that your scenario will fail. This is a different from how 
  # your application behaves in the production environment, where an error page will 
  # be rendered instead.
  #
  # Sometimes we want to override this default behaviour and allow Rails to rescue
  # exceptions and display an error page (just like when the app is running in production).
  # Typical scenarios where you want to do this is when you test your error pages.
  # There are two ways to allow Rails to rescue exceptions:
  #
  # 1) Tag your scenario (or feature) with @allow-rescue
  #
  # 2) Set the value below to true. Beware that doing this globally is not
  # recommended as it will mask a lot of errors for you!
  #
  ActionController::Base.allow_rescue = false
  
  # Ensure sphinx directories exist for the test environment
  ThinkingSphinx::Test.init
  # Configure and start Sphinx, and automatically
  # stop Sphinx at the end of the test suite.
  ThinkingSphinx::Test.start_with_autostop
  # This makes tests bit slower, but it's better to use Zeus if wanting to keep sphinx running

  # Remove/comment out the lines below if your app doesn't have a database.
  # For some databases (like MongoDB and CouchDB) you may need to use :truncation instead.
  begin
    # General setting is :transaction, but see below for changes
    #DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.strategy = :truncation, {:except => %w[categories transaction_types category_transaction_types category_translations transaction_type_translations]}
    #:truncation, {:except => %w[categories share_types community_categories category_translations share_type_translations]}
  rescue NameError
    raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
  end
  
  # You may also want to configure DatabaseCleaner to use different strategies for certain features and scenarios.
  # See the DatabaseCleaner documentation for details. Example:
  #
  # Before('@sphinx,@selenium,@culerity,@celerity,@javascript') do
  #   # { :except => [:widgets] } may not do what you expect here
  #   # as tCucumber::Rails::Database.javascript_strategy overrides
  #   # this setting.
  #   DatabaseCleaner.strategy = :truncation, {:except => %w[categories share_types community_categories category_translations share_type_translations]}
  # end
  #   Before('~@sphinx', '~@selenium', '~@culerity', '~@celerity', '~@javascript') do
  #   DatabaseCleaner.strategy = :transaction
  # end

  #Cucumber::Rails::Database.javascript_strategy = :truncation, {:except => %w[categories share_types community_categories category_translations share_type_translations]}
  
  Rails.cache.clear
}

# This call is made here so that it's read by every one (Zeus, Spork or running without them)
# # Possible values are :truncation and :transaction
# # The :transaction strategy is faster, but might give you threading problems.
# # See https://github.com/cucumber/cucumber-rails/blob/master/features/choose_javascript_database_strategy.feature
Cucumber::Rails::Database.javascript_strategy = :truncation, {:except => %w[categories transaction_types category_transaction_types category_translations transaction_type_translations]}

# Disable delta indexing as it is not needed and generates unnecessary delay and output
ThinkingSphinx::Deltas.suspend!


# The each call functionality below doesn't seem to work with zeus (but it works with spork if that's needed anymore)
# Better to but stuff that's needed on every run straight to here. Like the javascript_strategy above

if defined?(Zeus)
  # prefork.call # This is commented out as the prefork stuff is already added to custom_plan.rb so that it's run only once
  $each_run = each_run
  class << Zeus.plan
    def after_fork_with_test
      after_fork_without_test
      $each_run.call
    end
    alias_method_chain :after_fork, :test
  end
elsif ENV['spork'] || $0 =~ /\bspork$/
  require 'spork'
  #puts "RUNNING WITH SPORK"
  Spork.prefork(&prefork)
  Spork.each_run(&each_run)
else
  #puts "RUNNING WITHOUT ZEUS OR SPORK"
  prefork.call
  each_run.call  
end

