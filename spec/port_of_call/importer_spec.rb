require 'port_of_call/importer'
require 'active_record'

class MyActiveRecord
end

describe PortOfCall::Importer do
  describe "#import!" do
    it "truncates the table for the given class" do
      connection = double("Connection")
      ActiveRecord::Base.stub(:connection).and_return(connection)
      connection.should_receive(:execute).with("TRUNCATE my_active_records")

      PortOfCall::Importer.new(MyActiveRecord).import!
    end
  end
end
