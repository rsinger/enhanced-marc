module MARC
  
  # A class for accessing the MARC Leader
  class Leader < String
    attr_reader :leader, :record_type, :bibliographic_level, :encoding_level, :fixed_fields
    def initialize(leader)
      super  
      # leader defaults:
      # http://www.loc.gov/marc/bibliographic/ecbdldrd.html
      self[10..11] = '22'
      self[20..23] = '4500'           
    end
    
    def parse_leader
      self.get_type
      self.get_blvl
      self.get_elvl
    end
    
    def get_type_code
      return self[6,1]    
    end
    
    def get_blvl_code
      return self[7,1]
    end
    
    def get_type
      return @record_type = self.type_translator(self.get_type_code, self.get_blvl_code)
    end
    
    def is_archival?
      return true if self[8,1] == 'a'
      return false
    end

    def get_blvl
      blvls = {
        'a'=>'Monographic component part',
        'b'=>'Serial component part',
        'c'=>'Collection',
        'd'=>'Subunit',
        'i'=>'Integrating resource',
        'm'=>'Monograph/Item',
        's'=>'Serial'
      }
      return @bibliographic_level = blvls[self.get_blvl_code]
    end

    def set_type(type)
      if type.length == 1
        translated_type = self.types(type)
        raise ArgumentError, "Invalid Type" if translated_type.nil?
      elsif type.length > 1
        translated_type = type
        type = self.types(type)
        raise ArgumentError, "Invalid Type" if type.nil?
      else
        raise ArgumentError, "Invalid Type"
      end      
      self[6] = type 
    end
    
    def type_translator(type_code, blvl_code)
      valid_types = ['a','t','g','k','r','o','p','e','f','c','d','i','j','m']
      unless valid_types.index(type_code)    
        raise ArgumentError, "Invalid Type!" 
        return
      end
      rec_types = {
        'BKS' => { :type => /[at]{1}/,	:blvl => /[acdm]{1}/ },
	      'SER' => { :type => /[a]{1}/,	:blvl => /[bs]{1}/ },
        'VIS' => { :type => /[gkro]{1}/,	:blvl => /[abcdms]{1}/ },
        'MIX' => { :type => /[p]{1}/,	:blvl => /[cd]{1}/ },
        'MAP' => { :type => /[ef]{1}/,	:blvl => /[abcdms]{1}/ },
        'SCO' => { :type => /[cd]{1}/,	:blvl => /[abcdms]{1}/ },
        'REC' => { :type => /[ij]{1}/,	:blvl => /[abcdms]{1}/ },
        'COM' => { :type => /[m]{1}/,	:blvl => /[abcdms]{1}/ }
      } 
      
      rec_types.each_key { | type |
        return type if type_code.match(rec_types[type][:type]) and blvl_code.match(rec_types[type][:blvl])
      } 
      raise ArgumentError, "Invalid BLvl!"
      return nil
    end
    
    def get_elvl_code
      return self[17,1]
    end
    
    def get_elvl
      elvls = {
        ' '=>'Full',
        '1'=>'Full, not examined',
        '2'=>'Less-than-full',
        '3'=>'Abbreviated',
        '4'=>'Core',
        '5'=>'Partial',
        '7'=>'Minimal',
        '8'=>'Prepublication',
        'I'=>'Full-level input by OCLC participants',
        'K'=>'Less-than-full input by OCLC participants',
        'L'=>'Full-level input added from a batch process',
        'M'=>'Less-than-full added from a batch process',
        'E'=>'System-identified MARC error in batchloaded record',
        'J'=>'Deleted record'
      }
      return @encoding_level = elvls[self.get_elvl_code]
    end
    
    def ELvl
      self.get_elvl unless @encoding_level
      return @encoding_level
    end
    
    def get_desc_code
      return self[18,1]
    end
    
    def get_desc
      codes = {' '=>'Non-ISBD', 'a'=>'AACR2', 'i'=>'ISBD', 'u'=>'Unknown'}
      return @descriptive_cataloging_form = codes[self.get_desc_code]      
    end
    
    def Desc
      self.get_desc unless @descriptive_cataloging_form
      return @descriptive_cataloging_form
    end
    
  end
end
