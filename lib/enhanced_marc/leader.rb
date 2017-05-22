module MARC

  # A class for accessing the MARC Leader
  class Leader < String
    attr_reader :leader, :fixed_fields
    def initialize(leader)
      super
      # leader defaults:
      # http://www.loc.gov/marc/bibliographic/ecbdldrd.html
      self[10..11] = '22'
      self[20..23] = '4500'
    end

    def type_code
      self[6, 1]
    end

    alias get_type_code type_code

    def blvl_code
      self[7, 1]
    end

    alias get_blvl_code blvl_code

    def record_type
      type_translator(get_type_code, get_blvl_code)
    end

    alias get_type record_type

    def archival?
      return true if self[8, 1] == 'a'
      false
    end

    alias is_archival? archival?

    def blvl
      blvls = {
        'a' => 'Monographic component part',
        'b' => 'Serial component part',
        'c' => 'Collection',
        'd' => 'Subunit',
        'i' => 'Integrating resource',
        'm' => 'Monograph/Item',
        's' => 'Serial'
      }
      blvls[get_blvl_code]
    end

    alias bibliographic_level blvl
    alias get_blvl blvl

    def record_type=(type)
      if type.length == 1
        translated_type = types(type)
        raise ArgumentError, 'Invalid Type' if translated_type.nil?
      elsif type.length > 1
        type = types(type)
        raise ArgumentError, 'Invalid Type' if type.nil?
      else
        raise ArgumentError, 'Invalid Type'
      end
      self[6] = type
    end

    alias set_type record_type=

    def type_translator(type_code, blvl_code)
      valid_types = %w[a t g k r o p e f c d i j m]
      raise ArgumentError, 'Invalid Type!' unless valid_types.index(type_code)

      rec_types = {
        'BKS' => { type: /[at]{1}/,	blvl: /[acdm]{1}/ },
        'SER' => { type: /[a]{1}/,	blvl: /[bis]{1}/ },
        'VIS' => { type: /[gkro]{1}/,	blvl: /[abcdims]{1}/ },
        'MIX' => { type: /[p]{1}/,	blvl: /[cd]{1}/ },
        'MAP' => { type: /[ef]{1}/,	blvl: /[abcdims]{1}/ },
        'SCO' => { type: /[cd]{1}/,	blvl: /[abcdims]{1}/ },
        'REC' => { type: /[ij]{1}/,	blvl: /[abcdims]{1}/ },
        'COM' => { type: /[m]{1}/,	blvl: /[abcdims]{1}/ }
      }

      rec_types.each_key do |type|
        if type_code.match(rec_types[type][:type]) && blvl_code.match(rec_types[type][:blvl])
          return type
        end
      end
      raise ArgumentError, 'Invalid BLvl!'
    end

    def elvl_code
      self[17, 1]
    end
    alias get_elvl_code elvl_code

    def elvl
      elvls = { ' ' => 'Full', '1' => 'Full, not examined',
                '2' => 'Less-than-full', '3' => 'Abbreviated',
                '4' => 'Core', '5' => 'Partial', '7' => 'Minimal',
                '8' => 'Prepublication', 'J' => 'Deleted record',
                'I' => 'Full-level input by OCLC participants',
                'K' => 'Less-than-full input by OCLC participants',
                'L' => 'Full-level input added from a batch process',
                'M' => 'Less-than-full added from a batch process',
                'E' => 'System-identified MARC error in batchloaded record' }
      elvls[get_elvl_code]
    end
    alias encoding_level elvl
    alias ELvl elvl
    alias get_elvl elvl

    def desc_code
      self[18, 1]
    end

    alias get_desc_code desc_code

    def desc
      codes = {
        ' ' => 'Non-ISBD', 'a' => 'AACR2', 'i' => 'ISBD', 'u' => 'Unknown'
      }
      codes[get_desc_code]
    end
    alias descriptive_cataloging_form desc
    alias Desc desc
    alias get_desc desc
  end
end
