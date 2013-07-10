# port_of_call

A simple gem to load ActiveRecord seeds files from a Excel Spreadsheet, OpenOffice Spreadsheet, or CSV.
Coming soon: Google Drive Spreadsheets.
Note: this will deletes any existing data in the seed tables before importing.

## Requirements
  * Ruby 1.9

## Installation

Add to gemfile:

    gem 'port_of_call', :git => "git@github.com:tracedwax/port_of_call.git"

## Usage

In db/seeds.rb:

    require 'port_of_call/importer'

    PortOfCall::Importer.new(MyActiveRecordClass, "FileType", "path/to/file")

Options are:

    PortOfCall::Importer.new(MyActiveRecordClass, "Excel", "path/to/file.xlsx")
    PortOfCall::Importer.new(MyActiveRecordClass, "OpenOffice", "path/to/file.ods")
    PortOfCall::Importer.new(MyActiveRecordClass, "CSV", "path/to/file.csv")

Recommended file path:
    data/import/my_active_record_class_pluralized.csv, etc

