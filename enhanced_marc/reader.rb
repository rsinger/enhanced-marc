module MARC
  class Reader
    # A static method for turning raw MARC data in transission
    # format into a MARC::Record object.
    def self.decode(marc, params={})
      leader = Leader.new(marc[0..LEADER_LENGTH-1])
      record = case leader.get_type
        when 'BKS' then MARC::BookRecord.new
        when 'SER' then MARC::SerialRecord.new
        when 'VIS' then MARC::VisualRecord.new
        when 'MIX' then MARC::MixedRecord.new
        when 'MAP' then MARC::MapRecord.new
        when 'SCO' then MARC::ScoreRecord.new
        when 'REC' then MARC::SoundRecord.new
        when 'COM' then MARC::ComputerRecord.new
        else MARC::Record.new
      end
      record.leader = leader

      # where the field data starts
      base_address = record.leader[12..16].to_i

      # get the byte offsets from the record directory
      directory = marc[LEADER_LENGTH..base_address-1]

      throw "invalid directory in record" if directory == nil

      # the number of fields in the record corresponds to 
      # how many directory entries there are
      num_fields = directory.length / DIRECTORY_ENTRY_LENGTH

      # when operating in forgiving mode we just split on end of
      # field instead of using calculated byte offsets from the 
      # directory
      all_fields = marc[base_address..-1].split(END_OF_FIELD)

      0.upto(num_fields-1) do |field_num|

        # pull the directory entry for a field out
        entry_start = field_num * DIRECTORY_ENTRY_LENGTH
        entry_end = entry_start + DIRECTORY_ENTRY_LENGTH
        entry = directory[entry_start..entry_end]

        # extract the tag
        tag = entry[0..2]

        # get the actual field data
        # if we were told to be forgiving we just use the
        # next available chuck of field data that we 
        # split apart based on the END_OF_FIELD
        field_data = ''
        if params[:forgiving]
          field_data = all_fields.shift()

        # otherwise we actually use the byte offsets in 
        # directory to figure out what field data to extract
        else
          length = entry[3..6].to_i
          offset = entry[7..11].to_i
          field_start = base_address + offset
          field_end = field_start + length - 1
          field_data = marc[field_start..field_end]
        end

        # remove end of field
        field_data.delete!(END_OF_FIELD)

        # add a control field or data field
        if tag < '010'
          record.append(MARC::ControlField.new(tag,field_data))
        else
          field = MARC::DataField.new(tag)

          # get all subfields
          subfields = field_data.split(SUBFIELD_INDICATOR)

          # must have at least 2 elements (indicators, and 1 subfield)
          # TODO some sort of logging?
          next if subfields.length() < 2

          # get indicators
          indicators = subfields.shift()
          field.indicator1 = indicators[0,1]
          field.indicator2 = indicators[1,1]

          # add each subfield to the field
          subfields.each() do |data|
            subfield = MARC::Subfield.new(data[0,1],data[1..-1])
            field.append(subfield)
          end

          # add the field to the record
          record.append(field)
        end
      end

      return record
    end

  end
end
