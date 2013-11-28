require 'active_support/core_ext/class/attribute'
require 'active_support/core_ext/string/inflections'

module ActiveCopy
  # Attribute storage and handling for +ActiveCopy+ models.
  module Attributes
    extend ActiveSupport::Concern

    DEFAULT_PATH = "public/#{self.class.name.parameterize.pluralize}"
    DEFAULT_ATTRS = [:layout]

    included do
      class_attribute :_accessible_attributes
      class_attribute :_deployment_path
    end

    module ClassMethods
      def attr_accessible(*args)
        if self._accessible_attributes.nil?
          self._accessible_attributes = [] 
        end

        args.each do |attribute|
          self._accessible_attributes << attribute
        end
      end

      def deploy_to file_path
        self._deployment_path = file_path
      end

      def accessible_attrs
        if self._accessible_attributes.nil?
          DEFAULT_ATTRS
        else
          self._accessible_attributes.merge DEFAULT_ATTRS
        end
      end

      def deployment_path
        self._deployment_path || "#{DEFAULT_PATH}/#{self.id}.html"
      end
    end
  end
end
