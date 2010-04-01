module AutoComplete      
  
  def self.included(base)
    base.extend(ClassMethods)
  end

  #
  # Example:
  #
  #   # Controller
  #   class BlogController < ApplicationController
  #     auto_complete_for :post, :title
  #   end
  #
  #   # View
  #   <%= text_field_with_auto_complete :post, title %>
  #
  # By default, auto_complete_for limits the results to 10 entries,
  # and sorts by the given field.
  # 
  # auto_complete_for takes a third parameter, an options hash to
  # the find method used to search for the records:
  #
  #   auto_complete_for :post, :title, :limit => 15, :order => 'created_at DESC'
  #
  # For help on defining text input fields with autocompletion, 
  # see ActionView::Helpers::JavaScriptHelper.
  #
  # For more documentation, see the script.aculo.us wiki at github:
  # * http://wiki.github.com/madrobby/scriptaculous/ajax-autocompleter
  # * http://wiki.github.com/madrobby/scriptaculous/autocompleter-local
  module ClassMethods
    def auto_complete_for(object, method, options = {})
      define_method("auto_complete_for_#{object}_#{method}") do
        find_options = { 
          :conditions => [ "LOWER(#{method}) LIKE ?", '%' + params[object][method].downcase + '%' ], 
          :order => "#{method} ASC",
          :limit => 10 }.merge!(options)
        
        @items = object.to_s.camelize.constantize.find(:all, find_options)

        render :inline => "<%= auto_complete_result @items, '#{method}' %>"
      end
    end
  end
  
end