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

### In db/seeds.rb:

    require 'importeroo/importer'

    Importeroo::Importer.new(MyActiveRecordClass, "FileType", "path/to/file").import!

### For Google Docs:

    Importeroo::Importer.new(MyActiveRecordClass, "Google", "KEYcodeFROMgdocsURL")

The code for the google doc is the long alphanumeric key listed in the URL.  For example:

	https://docs.google.com/spreadsheet/ccc?key=0AmX1I4h6m35OdFhlbDdLdnZfTUFnSVRzd0hqMjM1bUE#gid=0, the key is 0AmX1I4h6m35OdFhlbDdLdnZfTUFnSVRzd0hqMjM1bUE.

If your doc is not visible to anyone with the URL, you will also need to set the google username and password in config/importeroo.rb, or anywhere:

    Importeroo.google_username = ENV["GOOGLE_USERNAME"]
    Importeroo.google_password = ENV["GOOGLE_PASSWORD"]

### For CSV, Excel, or OpenOffice:

    Importeroo::Importer.new(MyActiveRecordClass, "CSV", "path/to/file.csv")
    Importeroo::Importer.new(MyActiveRecordClass, "Excelx", "path/to/file.xlsx") # current Excel
    Importeroo::Importer.new(MyActiveRecordClass, "Excel", "path/to/file.xls")   # old Excel
    Importeroo::Importer.new(MyActiveRecordClass, "OpenOffice", "path/to/file.ods")

Recommended path to file:

    data/import/my_active_record_class_pluralized.csv

