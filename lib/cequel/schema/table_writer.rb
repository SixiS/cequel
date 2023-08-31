# -*- encoding : utf-8 -*-
module Cequel
  module Schema
    #
    # Creates a new table schema in the database
    #
    class TableWriter
      #
      # Creates a new table schema in the database given an object
      # representation of the schema to create
      #
      # @param (see #initialize)
      # @return (see #apply)
      #
      def self.apply(keyspace, table)
        new(table).apply(keyspace)
      end

      #
      # @param keyspace [Keyspace] keyspace in which to create the table
      # @param table [Table] object representation of table schema
      #
      def initialize(table)
        @table = table
      end

      #
      # Create the table in the keyspace
      #
      # @return [void]
      #
      # @api private
      #
      def apply(keyspace)
        statements.each { |statement| keyspace.execute(statement) }
      end

      def statements
        [create_statement] + index_statements
      end

      protected

      attr_reader :table

      private

      def create_statement
        "CREATE TABLE #{table.name} (#{columns_cql}, #{keys_cql})".tap do |cql|
          properties = properties_cql
          cql << " WITH #{properties}" if properties
        end
      end

      def index_statements
        [].tap do |statements|
          table.data_columns.each do |column|
            if column.indexed?
              statements << index_statement_for(column)
            end
          end
        end
      end

      def index_statement_for(column)
        if column.respond_to?(:index_settings) && column.index_settings
          index_settings = column.index_settings
          index_name = index_settings[:index_name] || column.index_name
          cql = %Q|CREATE CUSTOM INDEX "#{index_name}" ON "#{table.name}" ("#{column.name}")|
          if index_settings&.fetch(:using, nil)
            cql += %Q| USING '#{index_settings[:using]}'|
          end
          if index_settings&.fetch(:options, nil)
            cql += %Q| WITH OPTIONS = #{index_settings[:options].to_json.gsub("\"", "\'")}|
          end
          cql
        else
          %Q|CREATE INDEX "#{column.index_name}" ON "#{table.name}" ("#{column.name}")|
        end
      end

      def columns_cql
        table.columns.map(&:to_cql).join(', ')
      end

      def key_columns_cql
        table.keys.map(&:to_cql).join(', ')
      end

      def keys_cql
        partition_cql = table.partition_key_columns
          .map { |key| key.name }.join(', ')
        if table.clustering_columns.any?
          nonpartition_cql =
            table.clustering_columns.map { |key| key.name }.join(', ')
          "PRIMARY KEY ((#{partition_cql}), #{nonpartition_cql})"
        else
          "PRIMARY KEY ((#{partition_cql}))"
        end
      end

      def properties_cql
        properties_fragments = table.properties
          .map { |_, property| property.to_cql }
        properties_fragments << 'COMPACT STORAGE' if table.compact_storage?
        if table.clustering_columns.any?
          clustering_fragment =
            table.clustering_columns.map(&:clustering_order_cql).join(',')
          properties_fragments <<
            "CLUSTERING ORDER BY (#{clustering_fragment})"
        end
        properties_fragments.join(' AND ') if properties_fragments.any?
      end
    end
  end
end
