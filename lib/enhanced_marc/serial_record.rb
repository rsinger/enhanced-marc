module MARC

  # TODO: rename to ContinuingResource
  # A class that represents an individual MARC record. Every record
  # is made up of a collection of MARC::Field objects.
  class SerialRecord < Record

    def initialize
      super
      @leader[6] = 'a' if @leader[6,1] == ' '
      @leader[7] = 's' if @leader[7,1] == ' '
      @record_type = 'SER'
      @bibliographic_level = @leader.get_blvl
      extend SerialType
      inspect_fixed_fields
    end

    def valid_type?
      return false unless @leader[6, 1] == 'a'
      true
    end
    alias is_valid_type? valid_type?
    def valid_blvl?
      return false unless @leader[7, 1] =~ /[bis]{1}/
      true
    end
    alias is_valid_blvl? valid_blvl?

    def self.new_from_record(record)
      rec = SerialRecord.new
      record.instance_variables.each { | var |
        rec.instance_variable_set(var, record.instance_variable_get(var))
      }
      error = rec.valid_type? ? nil : 'Incorrect type declaration in leader'
      if !error && !rec.valid_blvl?
        error = 'Incorrect bibliographic declaration in leader'
      end
      return Exception.new(error) if error
      rec
    end

  end
end
