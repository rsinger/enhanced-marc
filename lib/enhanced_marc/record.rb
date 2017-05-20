module MARC
  class Record
    
    attr_reader :record_type
    
    # Creates a new MARC::Record using MARC::Leader
    # to work with the leader, rather than a string
    def initialize
      @fields = FieldMap.new
      # leader is 24 bytes
      @leader = Leader.new(' ' * 24) 
    end
            
    def contains_type?(record_type)
      type_map = {"BKS"=>/[at]{1}/, "COM"=>"m", "MAP"=>/[ef]{1}/,"MIX"=>"p", "SCO"=>/[cd]{1}/, "REC"=>/[ij]{1}/, "SER"=>"s", "VIS"=>/[gkor]{1}/}
      matching_fields = []
      @fields.each_by_tag('006').each { | fxd_fld |
        matching_fields << fxd_fld if fxd_fld.value[0,1].match(type_map[record_type])
      
      }
      return nil if matching_fields.empty?
      return matching_fields
    end 
    
    def self.new_from_record(record)
      leader = Leader.new(record.leader)
      typed_record = case leader.get_type
        when 'BKS' then MARC::BookRecord.new_from_record(record)
        when 'SER' then MARC::SerialRecord.new_from_record(record)
        when 'VIS' then MARC::VisualRecord.new_from_record(record)
        when 'MIX' then MARC::MixedRecord.new_from_record(record)                
        when 'MAP' then MARC::MapRecord.new_from_record(record)                
        when 'SCO' then MARC::ScoreRecord.new_from_record(record)                
        when 'REC' then MARC::SoundRecord.new_from_record(record)                
        when 'COM' then MARC::ComputerRecord.new_from_record(record)                
      end
      typed_record.fields.reindex
      typed_record
    end    
    
    def to_typed_record
      return self.new_from_record(self)
    end  
    
    def is_archival?
      return @leader.is_archival?
    end
        
    
    def composition_form(human_readable=false)
    end
    
    def bibliographic_level
      @leader.get_blvl
    end
    
    def publication_country
      return self['008'].value[15,3].strip unless self['008'].value[15,3] == '  '
      return false
    end
    
    def get_dates
    
    end
    
    def created_on
      unless self['008'].value[0,6] == (' '*6)
        return Date.parse(self['008'].value[0,2]+'-'+self['008'].value[2,2]+'-'+self['008'].value[4,2], false)
      else
        return Date.today
      end
    end
    
    def inspect_fixed_fields
      type_map = {/[at]{1}/=>BookType,'m'=>ComputerType,/[ef]{1}/=>MapType,
        'p'=>MixedType,/[cd]{1}/=>ScoreType,/[ij]{1}/=>SoundType,'s'=>SerialType,
        /[gkor]{1}/=>VisualType}
      @fields.each_by_tag('006').each { | fxd_fld |    
        type_map.each_key { | key |
          if fxd_fld.value[0,1].match(key)
            self.extend type_map[key]
          end
        }
      }
    end
    
    def languages
      languages = []
      unless self['008'].value[35,3].empty?
        language = Locale::Info.get_language(self['008'].value[35,3])
        languages << language if language
      end
      @fields.each_by_tag("041") do | oh_four_one |
        langs = oh_four_one.find_all { |sub| sub.code == 'a'}
        langs.each do | lang |
          i = 0
          while (i + 3) <= lang.value.length
            language = Locale::Info.get_language(lang.value[i,3])
            languages << language if language
            i += 3
          end
        end
      end
      languages.uniq
    end        
  end
end