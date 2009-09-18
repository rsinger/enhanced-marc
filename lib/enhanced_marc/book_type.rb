module BookType
  include RecordType
  public :is_govdoc?, :nature_of_contents, :is_conference?, :audience_level, :form, :has_index?
  # Checks the leader and any 006 fields to 
  # determine if the record is a manuscript.
  # Returns a boolean.
  def is_manuscript?
    return true if @leader[6,1] == 't'
    @fields.find_all {|f| ('006') === f.tag}.each { | fxd_fld |
      return true if fxd_fld[0,1] == 't'
    }       
    return false
  end
  
  def set_manuscript(value=false, field=nil)
    if field
      return Exception.new("Field is not an 006") unless field.tag == '006'
      if value
        field.value[0] = 't'
      else
        field.value[0] = 'a'
      end
    else  
      if value
        @leader[6] = 't'
      else
        @leader[6] = 'a'
      end
    end
  end
  
  def literary_form(human_readable=false)
    lit_map={'0'=>'Non-fiction', '1'=>'Fiction', 'c'=>'Comic',
      'd'=>'Drama', 'e'=>'Essay', 'f'=>'Novel', 'h'=>'Humor/satire', 'i'=>'Letter', 'j'=>'Short story',
      'm'=>'Mixed', 'p'=>'Poetry', 's'=>'Speech', 'u'=>'Unknown'}
    human_readable = lit_map if human_readable
    return self.field_parser({:match=>'BKS', :start=>33,:end=>1}, {:match=>/[at]{1}/, :start=>16,:end=>1}, human_readable)          
  end    
        
  def is_biography?(human_readable=false)
    biog_map = {'a'=>'Autobiography', 'b'=>'Individual biography',
     'c'=>'Collective biography', 'd'=>'Contains biographical information'}
    human_readable = biog_map if human_readable
    return self.field_parser({:match=>'BKS', :start=>34,:end=>1}, {:match=>/[at]{1}/, :start=>17,:end=>1}, human_readable)               
  end    
  
  def is_festschrift?
    return true if self['008'].value[30,1] == "1" and @record_type == "BKS"
    @fields.find_all {|f| ('006') === f.tag}.each { | fxd_fld |
      next unless fxd_fld.value[0,1].match(/[at]{1}/) and fxd_fld.value[13,1] == "1"
      return true
    }        
    return false
  end    
        
  def is_illustrated?(human_readable=false)
    ills_map = {'a'=>'Illustrations','b'=>'Maps','c'=>'Portraits','d'=>'Charts',
      'e'=>'Plans', 'f'=>'Plates', 'g'=>'Music', 'h'=>'Facsimilies', 'i'=>'Coats of arms',
      'j'=>'Genealogical tables', 'k'=>'Forms', 'j'=>'Genealogical tables', 'k'=>'Forms', 'l'=>'Samples',
      'm'=>'Phonodisc', 'o'=>'Photographs', 'p'=>'Illuminations'}
    contents = []
    if self.record_type == 'BKS'
      self['008'].value[18,4].split(//).each { | char | 
        next if char == " "
        if human_readable
          contents << ills_map[char]
        else
          contents << char
        end
      }
    end
    @fields.find_all {|f| ('006') === f.tag}.each { | fxd_fld |
      next unless fxd_fld.value[0,1].match(/[at]{1}/)     
      fxd_fld.value[1,4].split(//).each { | char | 
        next if char == " "
        if human_readable
          contents << ills_map[char]
        else
          contents << char
        end
      }
    }       
    return false if contents.empty?
    return contents      
  end        
end