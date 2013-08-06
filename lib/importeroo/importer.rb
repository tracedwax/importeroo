require 'roo'

module Importeroo
  class Importer < Struct.new(:klass, :data_source_type, :data_source)
    FIELDS_TO_EXCLUDE = ["created_at", "updated_at"]

    def import!
      ActiveRecord::Base.transaction do
        ActiveRecord::Base.connection.execute("DELETE FROM #{klass.table_name}")

        (2..data.last_row).each do |row_num|
          import_row! data.row(row_num)
        end
      end
    end

    private

    def data
      @data ||= roo_class.new(data_source, nil, :ignore)
    end

    def roo_class
      "Roo::#{data_source_type.titleize}".constantize
    end

    def import_row!(row)
      record = klass.new

      fields.each do |field|
        record.public_send(field.assignment_method_name, row[field.column_num])
      end
      raise ActiveRecord::Rollback unless record.save
    end

    def fields
      @fields ||= set_fields
    end

    def set_fields
      field_list.map do |field_pair|
        field_name = field_pair[0].downcase.gsub(" ", "_")
        column_num = field_pair[1]

        Field.new(column_num, field_name) unless FIELDS_TO_EXCLUDE.include?(field_name)
      end.compact
    end

    def all_fields
      data.row 1
    end

    def field_list
      all_fields.to_enum.with_index(0).to_a
    end

    class Field < Struct.new(:column_num, :name)
      def assignment_method_name
        "#{name}="
      end
    end

    def underscore(string)
      string.gsub(/(.)([A-Z])/,'\1_\2').downcase + "s"
    end
  end
end
