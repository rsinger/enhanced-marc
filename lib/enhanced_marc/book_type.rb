# Methods for Book records
module BookType
  include RecordType
  public :is_govdoc?, :nature_of_contents, :is_conference?, :audience_level,
         :form, :has_index?, :govdoc?, :conference?
  # Checks the leader and any 006 fields to
  # determine if the record is a manuscript.
  # Returns a boolean.
  def manuscript?
    return true if @leader[6,1] == 't'
    @fields.each_by_tag('006') do |fxd_fld|
      return true if fxd_fld.value[0, 1] == 't'
    end
    false
  end

  alias is_manuscript? manuscript?

  def set_manuscript(value = false, field = nil)
    if field
      return Exception.new('Field is not an 006') unless field.tag == '006'
      field.value[0] = value ? 't' : 'a'
    else
      @leader[6] = value ? 't' : 'a'
    end
  end

  def literary_form(human_readable = false)
    lit_map = { '0' => 'Non-fiction', '1' => 'Fiction', 'c' => 'Comic',
                'd' => 'Drama', 'e' => 'Essay', 'f' => 'Novel',
                'h' => 'Humor/satire', 'i' => 'Letter', 'j' => 'Short story',
                'm' => 'Mixed', 'p' => 'Poetry', 's' => 'Speech',
                'u' => 'Unknown' }
    human_readable = lit_map if human_readable
    field_parser({ match: 'BKS', start: 33, end: 1 },
                 { match: /[at]{1}/, start: 16, end: 1 },
                 human_readable)
  end

  def biography?(human_readable = false)
    biog_map = { 'a' => 'Autobiography', 'b' => 'Individual biography',
                 'c' => 'Collective biography',
                 'd' => 'Contains biographical information' }
    human_readable = biog_map if human_readable
    field_parser({ match: 'BKS', start: 34, end: 1},
                 { match: /[at]{1}/, start: 17, end: 1},
                 human_readable)
  end

  alias is_biography? biography?

  def festschrift?
    return true if self['008'].value[30, 1] == '1' && @record_type == 'BKS'
    @fields.each_by_tag('006') do |fxd_fld|
      if fxd_fld.value[0, 1].match(/[at]{1}/) && fxd_fld.value[13, 1] == '1'
        next
      end
      return true
    end
    false
  end

  alias is_festchrift? festschrift?

  # TODO: simplify this method
  def illustrated?(human_readable = false)
    ills_map = { 'a' => 'Illustrations', 'b' => 'Maps', 'c' => 'Portraits',
                 'd' => 'Charts', 'e' => 'Plans', 'f' => 'Plates',
                 'g' => 'Music', 'h' => 'Facsimilies', 'i' => 'Coats of arms',
                 'j' => 'Genealogical tables', 'k' => 'Forms', 'l' => 'Samples',
                 'm' => 'Phonodisc', 'o' => 'Photographs',
                 'p' => 'Illuminations' }

    contents = []
    if record_type == 'BKS'
      self['008'].value[18, 4].split(//).each do |char|
        next if char == ' '
        if human_readable
          contents << ills_map[char] if ills_map[char]
        else
          contents << char
        end
      end
    end
    @fields.each_by_tag('006') do |fxd_fld|
      next unless fxd_fld.value[0, 1] =~ /[at]{1}/
      fxd_fld.value[1, 4].split(//).each do |char|
        next if char == ' '
        if human_readable
          contents << ills_map[char] if ills_map[char]
        else
          contents << char
        end
      end
    end
    return false if contents.empty?
    contents
  end

  alias is_illustrated? illustrated?
end
