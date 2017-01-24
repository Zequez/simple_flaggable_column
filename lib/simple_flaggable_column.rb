require 'active_support'
require 'simple_flaggable_column/version'

module SimpleFlaggableColumn
  extend ActiveSupport::Concern

  def self.symbols_to_flags(symbols, symbols_flags, throw_on_missing = true)
    symbols.map do |s|
      if throw_on_missing && !symbols_flags[s]
        throw ArgumentError.new("Flag #{s} doesn't exists")
      end
      symbols_flags[s]
    end.compact.reduce(:|) || 0
  end

  def self.flags_to_symbols(flags, symbols_flags)
    symbols_flags.each_pair.inject([]){|all, v| (flags & v[1] != 0) ? (all << v[0]) : all}
  end

  module ClassMethods
    def flag_column(name, symbols_flags, options = {})
      options = {
        throw_on_missing: true
      }.merge(options)

      flags_symbols = symbols_flags.invert

      define_singleton_method :"#{name}_flags" do |*symbols|
        if symbols.empty?
          symbols_flags
        else
          SimpleFlaggableColumn.symbols_to_flags(
            symbols,
            symbols_flags,
            options[:throw_on_missing]
          )
        end
      end

      define_singleton_method :"flags_#{name}" do
        flags_symbols
      end

      define_method "#{name}=" do |symbols|
        if symbols.nil?
          write_attribute name, 0
        elsif symbols.kind_of? Array
          write_attribute name, SimpleFlaggableColumn.symbols_to_flags(
            symbols,
            symbols_flags,
            options[:throw_on_missing]
          )
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
