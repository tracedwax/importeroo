require 'port_of_call'
require 'active_record'
require 'importer'

class MyActiveRecord
end

describe ImportThing::Importer do
  describe "#import!" do
    it "truncates the table for the given class" do
      connection = double("Connection")
      ActiveRecord::Base.stub(:connection).and_return(connection)
      connection.should_receive(:execute).with("TRUNCATE my_active_records")

      ImportThing::Importer.new(MyActiveRecord).import!
    end
  end
end
