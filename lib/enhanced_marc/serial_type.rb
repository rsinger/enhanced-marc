module SerialType
  include RecordType
  public :is_govdoc?, :nature_of_contents, :is_conference?, :form
  def alphabet(human_readable=false)
    alph_map = {'a'=>'Roman', 'b'=>'Extended Roman', 'c'=>'Cyrillic',
      'd'=>'Japanese', 'e'=>'Chinese', 'f'=>'Arabic', 'g'=>'Greek',
      'h'=>'Hebrew', 'i'=>'Thai', 'j'=>'Devanagari', 'k'=>'Korean', 'l'=>'Tamil',
      'u'=>'Unknown', 'z'=>'Other'
      }
    human_readable = alph_map if human_readable
    return self.field_parser({:match=>'SER', :start=>33,:end=>1}, {:match=>'s', :start=>16,:end=>1}, human_readable)
  end
  
  def frequency(human_readable=false) 
    freq_map = {'a'=>'Annual','b'=>'Bimonthly','c'=>'Semiweekly','d'=>'Daily',
      'e'=>'Biweekly','f'=>'Semiannual','g'=>'Biennial','h'=>'Triennial','i'=>'3 times/week',
      'j'=>'3 times/month', 'k'=>'Continuously updated','m'=>'Monthly','q'=>'Quarterly',
      's'=>'Semimonthly','t'=>'3 times/year','u'=>'Unknown','w'=>'Weekly','z'=>'Other'
      }
    human_readable = freq_map if human_readable
    resp = self.field_parser({:match=>'SER', :start=>18,:end=>1}, {:match=>'s', :start=>1,:end=>1}, human_readable)
    return resp if resp      
    if human_readable
      return 'No determinable frequency'
    else
      return false
    end
  end
  
  def regularity(human_readable=false)
    regl_map = {'n'=>'Normalized irregular','r'=>'Regular','u'=>'Unknown','x'=>'Completely irregular'}
    human_readable = regl_map if human_readable
    return self.field_parser({:match=>'SER', :start=>19,:end=>1}, {:match=>'s', :start=>2,:end=>1}, human_readable)
  end
  
  def serial_type(human_readable=false)
    srtp_map = {'d'=>'Database','l'=>'Loose-leaf','m'=>'Monographic series','n'=>'Newspaper','p'=>'Periodical','w'=>'Website'}
    human_readable = srtp_map if human_readable
    resp = self.field_parser({:match=>'SER', :start=>21,:end=>1}, {:match=>'s', :start=>4,:end=>1}, human_readable)
    return resp if resp    
    if human_readable
      return 'Other'
    else
      return false
    end    
  end
  
  def original_form(human_readable=false)
    orig_map = {'a'=>'Microfilm','b'=>'Microfiche','c'=>'Microopaque','d'=>'Large print',
      'e'=>'Newspaper format','f'=>'Braille','s'=>'Electronic'}
    human_readable = orig_map if human_readable
    resp = self.field_parser({:match=>'SER', :start=>22,:end=>1}, {:match=>'s', :start=>5,:end=>1}, human_readable)
    return resp if resp      

    if human_readable
      return 'Other'
    else
      return false
    end         
  
  end
  
  def nature_of_work(human_readable=false)
    entw_map = {'a'=>'Abstracts','b'=>'Bibliography','c'=>'Catalog','d'=>'Dictionary',
      'e'=>'Encyclopedia', 'f'=>'Handbook', 'g'=>'Legal article', 'h'=>'Biography', 'i'=>'Index',
      'j'=>'Patent document', 'k'=>'Discography', 'l'=>'Legislation', 'm'=>'Thesis', 'n'=>'Literature survey',
      'o'=>'Review', 'p'=>'Programmed text', 'q'=>'Filmography', 'r'=>'Directory', 's'=>'Statistics', 
      't'=>'Technical report', 'u'=>'Standard/specification', 'v'=>'Legal case', 'w'=>'Law report', 'x'=>'Other report',
      'z'=>'Treaty'}

    human_readable = entw_map if human_readable
    resp = self.field_parser({:match=>'SER', :start=>24,:end=>1}, {:match=>'s', :start=>7,:end=>1}, human_readable)
    return resp if resp
    if human_readable
      return 'Not specified'
    else
      return false
    end         
  
  end
  
  def entry(human_readable=false)
    entry_map = {'0'=>'Successive','1'=>'Latest','2'=>'Integrated'}
    human_readable = entry_map if human_readable
    return self.field_parser({:match=>'SER', :start=>34,:end=>1}, {:match=>'s', :start=>17,:end=>1}, human_readable)    
  end
end