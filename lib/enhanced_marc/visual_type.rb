module VisualType
  include RecordType
  public :form, :audience_level, :is_govdoc?
  
  def running_time
    if @record_type == 'VIS'
      unless self['008'].value[18,3] == 'nnn'
        return "Unknown" if self['008'].value[18,3] == "---"
        return self['008'].value[18,3].sub(/^0*/, '')
      end
    end
    @fields.find_all {|f| ('006') === f.tag}.each { | fxd_fld |
      next unless fxd_fld.value[0,1].match(/[gkor]{1}/)
      unless fxd_fld.value[1,3] == 'nnn'
        return "Unknown" if fxd_fld.value[1,3] == "---"
        return fxd_fld.value[1,3].sub(/^0*/, '')
      end
    }       
    return false    
  end
  
  def material_type(human_readable=false)
    tmat_map = {'a'=>'Art original', 'b'=>'Kit','c'=>'Art reproduction','d'=>'Diorama',
      'f'=>'Filmstrip','g'=>'Game','i'=>'Picture','k'=>'Graphic','l'=>'Technical drawing',
      'm'=>'Motion picture','n'=>'Chart','o'=>'Flash card','p'=>'Microscope slide',
      'q'=>'Model','r'=>'Realia','s'=>'Slide','t'=>'Transparency','v'=>'Videorecording',
      'w'=>'Toy','z'=>'Other'}
    human_readable = tmat_map if human_readable
    return self.field_parser({:match=>'VIS', :start=>33,:end=>1}, {:match=>/[gkor]{1}/, :start=>16,:end=>1}, human_readable)   
  end
  
  def technique(human_readable=false)
    tech_map = {'a'=>'Animation','c'=>'Animation and live action','l'=>'Live action',
      'n'=>'N/A','u'=>'Unknown','z'=>'Other'}
    human_readable = tmat_map if human_readable
    return self.field_parser({:match=>'VIS', :start=>34,:end=>1}, {:match=>/[gkor]{1}/, :start=>17,:end=>1}, human_readable)       
  end
end