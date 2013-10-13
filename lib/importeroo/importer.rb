require 'roo'

module Importeroo
  mattr_accessor :google_username, :google_password

  class Importer < Struct.new(:klass, :data_source_type, :data_source)
    FIELDS_TO_EXCLUDE = ["created_at", "updated_at"]

    def slurp!(options={})
      tables_seen = {}

      data.sheets.each { |sheet|
        self.klass=sheet.classify.safe_constantize
        STDERR.puts "Not loading #{sheet} because class cannot be found" && next unless self.klass
        @fields=nil
        import!( sheet: sheet, delete: !tables_seen.has_key?(klass.table_name))
        tables_seen[klass.table_name]=true
      }

    end

    def import!(options = {})

      options[:delete] = true unless options.has_key?(:delete)
      data.default_sheet = options[:sheet] if options[:sheet]

      ActiveRecord::Base.transaction do
        ActiveRecord::Base.connection.execute("DELETE FROM #{klass.table_name}") if options[:delete]

        (2..data.last_row).each do |row_num|
          import_row! data.row(row_num)
        end
      end
    end

    private

    def data
      @data ||= load_data
    end

    def load_data
      google_data || non_google_data
    end

    def google_data
      if data_source_type == "Google"
        roo_class.new(data_source, Importeroo.google_username, Importeroo.google_password)
      end
    end

    def non_google_data
      roo_class.new(data_source, nil, :ignore)
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
