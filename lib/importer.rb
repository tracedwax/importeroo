module ImportThing
  class Importer < Struct.new(:klass)
    def import!
      ActiveRecord::Base.connection.execute("TRUNCATE #{underscore(klass.name)}")
    end

    def underscore(string)
      string.gsub(/(.)([A-Z])/,'\1_\2').downcase + "s"
    end
  end
end
