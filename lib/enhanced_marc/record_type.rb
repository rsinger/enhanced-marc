# Methods for all/most record type
module RecordType

  private

  def govdoc?(human_readable = false)
    govdoc_map = {
      'a' => 'Autonomous or semiautonomous components', 'c' => 'Multilocal',
      'f' => 'Federal', 'i' => 'International', 'l' => 'Local',
      'm' => 'Multistate', 'o' => 'Undetermined', 's' => 'State',
      'u' => 'Unknown', 'z' => 'Other'
    }
    human_readable = govdoc_map if human_readable
    field_parser(
      { match: /^BKS$|^COM$|^MAP$|^SER$|^VIS$/, start: 28, end: 1 },
      { match: /[atmefsgkor]{1}/, start: 11, end: 1 }, human_readable)
  end

  alias is_govdoc? govdoc?

  def nature_of_contents(human_readable=false)
    cont_map = {'a'=>'Abstracts','b'=>'Bibliography','c'=>'Catalog','d'=>'Dictionary',
      'e'=>'Encyclopedia', 'f'=>'Handbook', 'g'=>'Legal article', 'h'=>'Biography', 'i'=>'Index',
      'j'=>'Patent document', 'k'=>'Discography', 'l'=>'Legislation', 'm'=>'Thesis', 'n'=>'Literature survey',
      'o'=>'Review', 'p'=>'Programmed text', 'q'=>'Filmography', 'r'=>'Directory', 's'=>'Statistics',
      't'=>'Technical report', 'u'=>'Standard/specification', 'v'=>'Legal case', 'w'=>'Law report', 'x'=>'Other report',
      'y'=>'Yearbook', 'z'=>'Treaty', '2'=>'Offprint', '5'=>'Calendar', '6'=>'Comic/Graphic Novel'}

    contents = []
    idx = nil
    if self.record_type == 'BKS'
      idx = 24
      len = 4
    elsif self.record_type == 'SER'
      idx = 25
      len = 3
    end
    if idx
      self['008'].value[idx,len].split(//).each { | char |
        next if char == " "
        if human_readable
          contents << cont_map[char] if cont_map[char]
        else
          contents << char
        end
      }
    end
    @fields.find_all {|f| ('006') === f.tag}.each { | fxd_fld |
      idx = nil
      if fxd_fld.value[0,1].match(/[at]{1}/)
        idx = 7
        len = 4
      elsif fxd_fld.value[0,1].match('s')
        idx = 8
        len = 3
      end
      if idx
        fxd_fld.value[idx,len].split(//).each { | char |
          next if char == " "
          if human_readable
            contents << cont_map[char] if cont_map[char]
          else
            contents << char
          end
        }
      end
    }
    return false if contents.empty?
    return contents
  end


  def conference?
    return true if self['008'].value[29, 1] == '1' && @record_type =~ /^BKS$|^SER$/
    return true if self['008'].value[30, 2] =~ /c/ && @record_type =~ /^SCO$|^REC$/
    @fields.each_by_tag('006') do |fxd_fld|
      return true if fxd_fld.value[12, 1] == '1' && fxd_fld.value[0, 1] =~ /[ats]{1}/
      return true if fxd_fld.value[13, 2] =~ /c/ && fxd_fld.value[0, 1] =~ /[cdij]{1}/
    end
    false
  end

  alias is_conference? conference?

  def set_conference(value=false, field=nil)
    if field
      return Exception.new("Field is not an 006") unless field.tag == '006'
      return Exception.new("Field is not a BKS or SER") unless field.value[0,1].match(/[ats]{1}/)
      if value
        field.value[12] = '1'
      else
        field.value[12] = '0'
      end
    else
      field = @fields['008']
      field = MARC::Controlfield.new('008') unless field
      if value
        field[29] = '1'
      else
        field[29] = '0'
      end
    end

  end

  def accompanying_matter(human_readable=false)
    accm_map = {'a'=>'Discography','b'=>'Bibliography','c'=>'Thematic index','d'=>'Libretto',
      'e'=>'Composer biography', 'f'=>'Performer biography', 'g'=>'Technical/historical information on instruments',
      'h'=>'Technical information on music', 'i'=>'Historical information', 'j'=>'Historical information other than music',
      'k'=>'Ethnological information', 'n'=>'Not applicable', 'r'=>'Instructional materials', 's'=>'Music',
      'z'=>'Other accompanying matter'}
      matter = []

      if ['SCO', 'REC'].index(@record_type)
      self['008'].value[24,6].split(//).each { | char |
        next if char == " "
        if human_readable
          matter << accm_map[char] if accm_map[char]
        else
          matter << char
        end
      }
    end
    @fields.find_all {|f| ('006') === f.tag}.each { | fxd_fld |

      if fxd_fld.value[0,1].match(/[cdij]{1}/)
        fxd_fld.value[7,6].split(//).each { | char |
          next if char == " "
          if human_readable
            matter << accm_map[char]
          else
            matter << char
          end
        }
      end
    }
    return false if matter.empty?
    return matter
  end

  def audience_level(human_readable=false)
    audn_map = {'a'=>'Preschool', 'b'=>'Children age 6-8', 'c'=>'Children age 9-13',
      'd'=>'Adolescent', 'e'=>'Adult', 'f'=>'Specialized', 'g'=>'General', 'j'=>'Juvenile'
      }
    human_readable = audn_map if human_readable
    return self.field_parser({:match=>/^BKS$|^VIS$|^MIX$|^MAP$|^SCO$|^REC$|^COM$/, :start=>22,:end=>1}, {:match=>/[atmefpcdijgkor]{1}/, :start=>5,:end=>1}, human_readable)
  end

  def form(human_readable=false)
    form_map = {'a'=>'Microfilm', 'b'=>'Microfiche', 'c'=>'Microopaque',
      'd'=>'Large print', 'f'=>'Braille', 'o'=>'Online', 'q'=>'Direct Electronic',
      'r'=>'Reproduction', 's'=>'Electronic'
    }
    idx = nil
    if self.record_type.match(/^MAP$|^VIS$/)
      idx = 29
    else
      idx = 23
    end
    unless self['008'].value[idx,1] == ' '
      if human_readable
        return form_map[self['008'].value[idx,1]]
      else
        return self['008'].value[idx,1]
      end
    end
    @fields.find_all {|f| ('006') === f.tag}.each { | fxd_fld |
      idx = nil
      if fxd_fld.value[0,1].match(/[efgkor]{1}/)
        idx = 6
      else
        idx = 12
      end
      next if fxd_fld.value[idx,1] == ' '
      if human_readable
        return form_map[fxd_fld.value[idx,1]]
      else
        return fxd_fld.value[idx,1]
      end
    }
    return false
  end

  def has_index?
    return true if self['008'].value[31,1] == '1'
    @fields.find_all {|f| ('006') === f.tag}.each { | fxd_fld |
      return true if fxd_fld.value[14,1] == '1'
    }
    return false
  end

  def composition_form(human_readable=false)
    comp_map = {'an'=>'Anthem','bd'=>'Ballad','bt'=>'Ballet','bg'=>'Bluegrass music',
      'bl'=>'Blues','cn'=>'Canon or round','ct'=>'Catata','cz'=>'Canzona','cr'=>'Carol',
      'ca'=>'Chaconne','cs'=>'Chance composition','cp'=>'Polyphonic chanson','cc'=>'Christian chant',
      'cb'=>'Chant','cl'=>'Chorale prelude','ch'=>'Chorale','cg'=>'Concerti grossi','co'=>'Concerto',
      'cy'=>'Country music','df'=>'Dance form','dv'=>'Divertimento/serenade/cassation/divertissement/notturni',
      'ft'=>'Fantasia','fm'=>'Folk music','fg'=>'Fugue','gm'=>'Gospel music','hy'=>"Hymn",'jz'=>'Jazz',
      'md'=>'Madrigal','mr'=>'March','ms'=>'Mass','mz'=>'Mazurka','mi'=>'Minuet','mo'=>'Motet',
      'mp'=>'Motion picture music','mu'=>'Multiple forms','mc'=>'Musical revue/comedy',
      'nc'=>'Nocturne','nn'=>'Not a musical recording','op'=>'Opera','or'=>'Oratorio',
      'ov'=>'Overture','pt'=>'Part-song','ps'=>'Passacaglia','pm'=>'Passion music',
      'pv'=>'Pavanes','po'=>'Polonaises','pp'=>'Popular music','pr'=>'Prelude','pg'=>'Program music',
      'rg'=>'Ragtime music','rq'=>'Requiem','rp'=>'Rhapsody','ri'=>'Ricercars','rc'=>'Rock music',
      'rd'=>'Rondo','sn'=>'Sonata','sg'=>'Song','sd'=>'Square dance music','st'=>'Study/exercise',
      'su'=>'Suite','sp'=>'Symphonic poem','sy'=>'Symphony','tc'=>'Toccata','ts'=>'Trio-sonata',
      'uu'=>'Unknown','vr'=>'Variation','wz'=>'Waltz','zz'=>'Other'
      }
    if @record_type.match(/^SCO$|^REC$/)
      unless self['008'].value[18,2] == '  '
        if human_readable
          return comp_map[self['008'].value[18,2]]
        else
          return self['008'].value[18,2]
        end
      end
    end
    @fields.find_all {|f| ('006') === f.tag}.each { | fxd_fld |
      next unless fxd_fld.value[0,1].match(/[cdij]{1}/)
      unless fxd_fld.value[1,2] == '  '
        if human_readable
          return comp_map[fxd_fld.value[1,2]]
        else
          return fxd_fld.value[1,2]
        end
      end
    }
    return false
  end

  def music_format(human_readable=false)
    fmus_map = {'a'=>'Full score','b'=>'Full score, miniature/study size','c'=>'Accompaniment reduced for keyboard',
      'd'=>'Voice score','e'=>'Condensed score','g'=>'Close score','m'=>'Multiple formats','n'=>'N/A',
      'u'=>'Unknown','z'=>'Other'}
    human_readable = fmus_map if human_readable
    return self.field_parser({:match=>/^SCO$|^REC$/, :start=>20,:end=>1}, {:match=>/[cdij]{1}/, :start=>3,:end=>1}, human_readable)
  end

  def has_index?
    return true if self['008'].value[31,1] == '1'
    @fields.find_all {|f| ('006') === f.tag}.each { | fxd_fld |
      return true if fxd_fld.value[14,1] == '1'
    }
    return false
  end

  def literary_text(human_readable=true)
    ltxt_map = {'a'=>'Autobiography', 'b'=>'Biography','c'=>'Conference proceeding','d'=>'Drama',
      'e'=>'Essay','f'=>'Fiction','g'=>'Reporting','h'=>'History','i'=>'Instruction','j'=>'Language instruction',
      'k'=>'Comedy','l'=>'Lecture/speech','m'=>'Memoir','n'=>'N/A','o'=>'Folktale','p'=>'Poetry','r'=>'Rehearsal',
      's'=>'Sounds','t'=>'Interview','z'=>'Other'}
      txts = []

      if ['SCO', 'REC'].index(@record_type)
      self['008'].value[30,2].split(//).each { | char |
        next if char == " "
        if human_readable
          txts << ltxt_map[char]
        else
          txts << char
        end
      }
    end
    @fields.find_all {|f| ('006') === f.tag}.each { | fxd_fld |

      if fxd_fld.value[0,1].match(/[cdij]{1}/)
        fxd_fld.value[13,2].split(//).each { | char |
          next if char == " "
          if human_readable
            txts << ltxt_map[char]
          else
            txts << char
          end
        }
      end
    }
    return false if txts.empty?
    return txts
  end
  protected
  def field_parser(eight, six, human_readable_map = nil)
    if self.record_type.match(eight[:match])
      if self['008'].value[eight[:start], eight[:end]] !~ /[\s\\|]{#{eight[:end]}}/
        if human_readable_map
          return human_readable_map[self['008'].value[eight[:start], eight[:end]]]
        else
          return self['008'].value[eight[:start], eight[:end]]
        end
      end
    end
    @fields.find_all {|f| ('006') === f.tag}.each { | fxd_fld |
      next unless fxd_fld.value[0,1].match(six[:match])
      next if fxd_fld.value[six[:start], six[:end]] =~ /[\s\\|]{#{six[:end]}}/
      if human_readable_map
        return human_readable_map[fxd_fld.value[six[:start],six[:end]]]
      else
        return fxd_fld.value[six[:start], six[:end]]
      end
    }
    return false
  end
end
