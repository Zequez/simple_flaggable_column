require 'active_support'
require 'simple_flaggable_column/version'

module SimpleFlaggableColumn
  extend ActiveSupport::Concern

  def self.symbols_to_flags(symbols, symbols_flags)
    symbols.map{|s| symbols_flags[s]}.compact.reduce(:|) || 0
  end

  def self.flags_to_symbols(flags, symbols_flags)
    symbols_flags.each_pair.inject([]){|all, v| (flags & v[1] != 0) ? (all << v[0]) : all}
  end

  module ClassMethods
    def flag_column(name, symbols_flags)
      flags_symbols = symbols_flags.invert

      define_singleton_method :"#{name}_flags" do |*symbols|
        if symbols.empty?
          symbols_flags
        else
          SimpleFlaggableColumn.symbols_to_flags(symbols, symbols_flags)
        end
      end

      define_singleton_method :"flags_#{name}" do
        flags_symbols
      end

      define_method "#{name}=" do |symbols|
        if symbols.nil?
          write_attribute name, 0
        elsif symbols.kind_of? Array
          write_attribute name, SimpleFlaggableColumn.symbols_to_flags(symbols, symbols_flags)
        else # numeric, or anything else
          write_attribute name, symbols
        end
      end

      define_method name do
        SimpleFlaggableColumn.flags_to_symbols(read_attribute(name), symbols_flags)
      end
    end
  end
end
