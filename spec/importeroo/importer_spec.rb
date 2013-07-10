require 'spec_helper'
require 'importeroo/importer'

describe Importeroo::Importer do
  with_model :BicycleType do
    table do |t|
      t.string :bicycle_type
    end
  end

  describe "#import!" do
    context "when a CSV" do
      it "deletes old data and imports the new data" do
        BicycleType.create(id: 5, bicycle_type: "velocipede")

        described_class.new(BicycleType, "CSV", "spec/fixtures/bicycles.csv").import!

        BicycleType.count.should == 4
        BicycleType.find(1).bicycle_type.should == "road bike"
        BicycleType.find(2).bicycle_type.should == "mountain bike"
        BicycleType.find(3).bicycle_type.should == "touring bike"
        BicycleType.find(4).bicycle_type.should == "beach cruiser"

        BicycleType.all.map(&:bicycle_type).should_not include("velocipede")
      end
    end

    context "when a Google Spreadsheet" do
      it "deletes old data and imports the new data" do
        BicycleType.create(id: 5, bicycle_type: "velocipede")

        described_class
          .new(BicycleType, "Google", "0AmX1I4h6m35OdFhlbDdLdnZfTUFnSVRzd0hqMjM1bUE").import!

        BicycleType.count.should == 4
        BicycleType.find(1).bicycle_type.should == "road bike"
        BicycleType.find(2).bicycle_type.should == "mountain bike"
        BicycleType.find(3).bicycle_type.should == "touring bike"
        BicycleType.find(4).bicycle_type.should == "beach cruiser"

        BicycleType.all.map(&:bicycle_type).should_not include("velocipede")
      end
    end
  end
end
