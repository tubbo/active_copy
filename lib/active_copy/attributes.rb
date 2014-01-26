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
        return DEFAULT_ATTRS if self._accessible_attributes.nil?
        self._accessible_attributes += DEFAULT_ATTRS
      end

      def deployment_path
        self._deployment_path || "#{DEFAULT_PATH}/#{self.id}.html"
      end
    end

    # Take YAML front matter given by id.
    def attributes
      @attributes ||= yaml_front_matter.with_indifferent_access
    end

    protected
    def attribute? key
      self.class.accessible_attrs.include? key.to_sym
    end

    private
    def yaml_front_matter
      HashWithIndifferentAccess.new \
        YAML::load(raw_source.split("---\n")[1])
    end
  end
end
