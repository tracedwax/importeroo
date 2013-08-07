require 'spec_helper'
require 'importeroo/importer'

describe Importeroo::Importer do
  with_model :BicycleType do
    table do |t|
      t.string :bicycle_type
    end
  end

  shared_examples_for "a table importer from an external source" do
    it "deletes old data and imports the new data" do
      BicycleType.count.should == 4
      BicycleType.find(1).bicycle_type.should == "road bike"
      BicycleType.find(2).bicycle_type.should == "mountain bike"
      BicycleType.find(3).bicycle_type.should == "touring bike"
      BicycleType.find(4).bicycle_type.should == "beach cruiser"

      BicycleType.all.map(&:bicycle_type).should_not include("velocipede")
    end
  end

  describe "#import!" do
    context "when a CSV" do
      before do
        BicycleType.create(id: 5, bicycle_type: "velocipede")

        described_class.new(BicycleType, "CSV", "spec/fixtures/bicycles.csv").import!
      end

      it_should_behave_like "a table importer from an external source"
    end

    context "when an Excel file" do
      before do
        BicycleType.create(id: 5, bicycle_type: "velocipede")

        described_class.new(BicycleType, "Excelx", "spec/fixtures/bicycles.xlsx").import!
      end

      it_should_behave_like "a table importer from an external source"
    end

    context "when a Google Spreadsheet" do
      context "when explicitly set" do
        before do
          Importeroo.google_username = "port.of.call.test@gmail.com"
          Importeroo.google_password = "importexport123"

          BicycleType.create(id: 5, bicycle_type: "velocipede")

          described_class
            .new(BicycleType, "Google", "0AmX1I4h6m35OdFhlbDdLdnZfTUFnSVRzd0hqMjM1bUE").import!
        end

        it_should_behave_like "a table importer from an external source"

        after do
          Importeroo.google_username = nil
          Importeroo.google_password = nil
        end
      end

      context "when not explicitly set", focus: true do
        before do
          BicycleType.create(id: 5, bicycle_type: "velocipede")

          described_class
            .new(BicycleType, "Google", "0AmX1I4h6m35OdFhlbDdLdnZfTUFnSVRzd0hqMjM1bUE").import!
        end

        it_should_behave_like "a table importer from an external source"
      end
    end
  end
end
