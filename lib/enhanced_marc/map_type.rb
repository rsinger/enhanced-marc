module MapType
  include RecordType
  public :is_govdoc?, :form, :has_index?
  def cartographic_type(human_readable=false)
    crtp_map = {'a'=>'Map', 'b'=>'Map series', 'c'=>'Map serial', 'd'=>'Globe', 'e'=>'Atlas',
      'f'=>'Supplement', 'g'=>'Bound as part of another work', 'u'=>'Unknown', 'z'=>'Other'}
    human_readable = crtp_map if human_readable
    return self.field_parser({:match=>'MAP', :start=>25,:end=>1}, {:match=>/[ef]{1}/, :start=>8,:end=>1}, human_readable)               
  end    
  
  def relief(human_readable=false)
    relief_map = {'a'=>'Contours', 'b'=>'Shading', 'c'=>'Grading and bathymetric tints',
      'd'=>'Hachures', 'e'=>'Bathymetry, soundings', 'f'=>'Form lines', 'g'=>'Spot heights',
      'h'=>'Color', 'i'=>'Pictorially', 'j'=>'Land forms', 'k'=>'Bathymetry, isolines', 
      'm'=>'Rock drawings', 'z'=>'Other'
      }
    contents = []
    if self.record_type == 'MAP'
      self['008'].value[18,4].split(//).each { | char | 
        next if char == " "
        if human_readable
          contents << relief_map[char]
        else
          contents << char
        end
      }
    end
    @fields.find_all {|f| ('006') === f.tag}.each { | fxd_fld |
      next unless fxd_fld.value[0,1].match(/[ef]{1}/)     
      fxd_fld.value[1,4].split(//).each { | char | 
        next if char == " "
        if human_readable
          contents << relief_map[char]
        else
          contents << char
        end
      }
    }       
    return false if contents.empty?
    return contents        
  end
  
  def projection(human_readable=false)
    proj_map = {'Azimuthal'=>{'aa'=>'Aitoff','ab'=>'Gnomic','ac'=>"Lambert's equal area",
                              'ad'=>'Orthographic','ae'=>'Azithumal equidistant', 'af'=>'Stereographic',
                              'ag'=>'General vertical near-sided','am'=>'Modified stereographic for Alaska',
                              'an'=>'Chamberlin trimetric','ap'=>'Polar stereographic','au'=>'Unknown','az'=>'Other'},
                'Cylindrical'=>{'ba'=>'Gall','bb'=>"Goode's homolographic",'bc'=>"Lambert's equal area",
                                'bd'=>'Mercator','be'=>'Miller','bf'=>'Mollweide','bg'=>'Sinusoidal',
                                'bh'=>'Transverse Mercator','bi'=>'Gauss-Kruger','bj'=>'Equirectangular',
                                'bo'=>'Oblique Mercator','br'=>'Robinson','bs'=>'Space oblique Mercator',
                                'bu'=>'Unknown','bz'=>'Other'
                                },
                'Conic'=>{'ca'=>"Alber's equal area",'cb'=>'Bonne','cc'=>"Lambert's",'ce'=>'Equidistant conic',
                          'cp'=>'Polyconic','cu'=>'Unknown','cz'=>'Other'
                          },
                'Other'=>{'da'=>'Armadillo','db'=>'Butterfly','dc'=>'Eckert','dd'=>"Goode's homolosine",
                          'de'=>"Miller's bipolar oblique conformal conic",'df'=>'Van Der Grinten',
                          'dg'=>'Dymaxion','dh'=>'Cordiform','dl'=>'Lambert conformal','zz'=>'Other'                          
                }
    }
    if @record_type == "MAP"
      unless self['008'].value[22,2] == '  '
        if human_readable
          proj_map.each_key { | general |
            next unless proj_map[general].keys.index(self['008'].value[22,2])
            return [general,proj_map[general][self['008'].value[22,2]]]
          }
        else
          return self['008'].value[22,2]
        end
      end
    end  
    @fields.find_all {|f| ('006') === f.tag}.each { | fxd_fld |
      next unless fxd_fld.value[0,1].match(/[ef]{1}/)
      unless fxd_fld.value[5,2] == '  '
        if human_readable
          proj_map.each_key { | general |
            next unless proj_map[general].keys.index(fxd_fld.value[5,2])
            return [general,proj_map[general][fxd_fld.value[5,2]]]
          }        
        else
          return fxd_fld.value[5,2]
        end
      end
    }       
    return false            
  end
  
  def special_format(human_readable=false)
    spfm_map = {'a'=>'Blueprint photocopy','b'=>'Other photocopy','c'=>'Negative photocopy',
                'd'=>'Film negative','f'=>'Facsimile','g'=>'Relief model','h'=>'Rare (pre-1800)',
                'e'=>'Manuscript','j'=>'Picture/post card','k'=>'Calendar','l'=>'Puzzle',
                'm'=>'Braille, tactile','n'=>'Game','o'=>'Wall map','p'=>'Playing cards',
                'q'=>'Loose-leaf','z'=>'Other'}
    human_readable = spfm_map if human_readable
    return self.field_parser({:match=>'MAP', :start=>33,:end=>2}, {:match=>/[ef]{1}/, :start=>16,:end=>2}, human_readable)                             
  end
end