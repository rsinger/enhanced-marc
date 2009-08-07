module ComputerType
  include RecordType
  public :form, :audience_level, :is_govdoc?
  def file_type(human_readable=false)
    return false unless self.contains_type?("COM")
    file_map = {'a'=>'Numeric data', 'b'=>'Computer program', 'c'=>'Representational',
      'd'=>'Document', 'e'=>'Bibliographic data', 'f'=>'Font', 'g'=>'Game',
      'h'=>'Sounds', 'i'=>'Interactive multimedia', 'j'=>'Online', 'm'=>'Combination',
      'u'=>'Unknown', 'z'=>'Other'}
    human_readable = file_map if human_readable
    return self.field_parser({:match=>'COM', :start=>26,:end=>1}, {:match=>'m', :start=>9,:end=>1}, human_readable)        
  end    

end