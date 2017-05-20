Enhanced MARC is a set of classes, modules and methods that sit on top of ruby-marc (http://rubyforge.org/projects/marc) to help parse the contents of MARC records more easily and conveniently.

[![Build Status](https://travis-ci.org/rsinger/enhanced-marc.svg?branch=master)](https://travis-ci.org/rsinger/enhanced-marc)

Installation:
  sudo gem install enhanced_marc

Usage:
```
  require 'enhanced_marc'

  reader = MARC::Reader.new('marc.dat')

  records = []

  reader.each do | record |
    records << record
  end
```
Note: enhanced-marc only works directly with `MARC::Reader`.  If you want to use it with MARCXML or MARC-JSON, etc.
you'll need to do something like:
```
  reader.each do | record |
    records << record.to_typed_record
  end
```
here
```
  >> records[0].class
  => MARC::BookRecord

  >> records[0].is_conference?
  => false

  >> records[0].is_manuscript?
  => false

  # Send a boolean true if you want human readable forms, rather than MARC codes.
  >> records[0].literary_form(true)
  => "Non-fiction"

  >> records[0].nature_of_contents(true)
  => ["Bibliography", "Catalog"]

  >> records[1].class
  => MARC::SoundRecord

  >> records[1].composition_form(true)
  => "Jazz"

  >> records[2].class
  => MARC::MapRecord

  >> records[2].projection(true)
  => ["Cylindrical", "Mercator"]

  >> records[2].relief(true)
  => ["Color"]
```
