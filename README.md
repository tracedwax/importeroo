# importeroo

A simple gem to load ActiveRecord seeds files from a Excel Spreadsheet, OpenOffice Spreadsheet, or CSV.
Coming soon: Google Drive Spreadsheets.
Note: this will deletes any existing data in the seed tables before importing.

## Requirements
  * Ruby 1.9

## Installation

Add to gemfile:

    gem 'importeroo', :git => "git@github.com:tracedwax/importeroo.git"

## Usage

In db/seeds.rb:

    require 'importeroo/importer'

    Importeroo::Importer.new(MyActiveRecordClass, "FileType", "path/to/file")

Options are:

    Importeroo::Importer.new(MyActiveRecordClass, "Excel", "path/to/file.xlsx")
    Importeroo::Importer.new(MyActiveRecordClass, "OpenOffice", "path/to/file.ods")
    Importeroo::Importer.new(MyActiveRecordClass, "CSV", "path/to/file.csv")

Recommended file path:
    data/import/my_active_record_class_pluralized.csv, etc

