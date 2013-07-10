# coding: utf-8

require "passwd/configuration/abstract_config"

module Passwd
  class TmpConfig < AbstractConfig
    def initialize(config, options)
      config.instance_variables.each do |v|
        key = v.to_s.sub(/^@/, "").to_sym
        if options.has_key? key
          instance_variable_set v, options[key]
        else
          instance_variable_set v, config.instance_variable_get(v)
        end
      end
    end
  end
end
