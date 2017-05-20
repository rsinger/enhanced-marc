module MARC

  # A class that represents an individual MARC record. Every record
  # is made up of a collection of MARC::Field objects.
  class MapRecord < Record

    def initialize
      super
      @leader[6] = 'e' if @leader[6, 1] == ' '
      @leader[7] = 'm' if @leader[7, 1] == ' '
      @record_type = 'MAP'
      @bibliographic_level = @leader.get_blvl
      extend MapType
      inspect_fixed_fields
    end

    def valid_type?
      return false unless @leader[6, 1] =~ /[ef]{1}/
      true
    end
    alias is_valid_type? valid_type?
    def valid_blvl?
      if @leader[7, 1] =~ /[acdim]{1}/ && @leader[6, 1] == 'f'
        true
      elsif @leader[7, 1] =~ /[abcdims]{1}/ && @leader[6, 1] == 'e'
        true
      else
        false
      end
    end
    alias is_valid_blvl? valid_blvl?
    def self.new_from_record(record)
      rec = MapRecord.new
      record.instance_variables.each do |var|
        rec.instance_variable_set(var, record.instance_variable_get(var))
      end
      error = rec.valid_type? ? nil : 'Incorrect type declaration in leader'
      if !error && !rec.valid_blvl?
        error = 'Incorrect bibliographic declaration in leader'
      end
      return Exception.new(error) if error
      rec
    end

  end
end
