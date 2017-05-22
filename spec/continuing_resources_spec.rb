require 'enhanced_marc'

RSpec.describe MARC::SerialRecord do
  context 'resource identification from MARC records' do
    it "should recognize type 'a' and blvl 'i' as an integrating resource" do
      reader = load_marc('text_web_resource.mrc')
      rec = reader.first
      expect(rec).to be_instance_of(MARC::SerialRecord)
      expect(rec).to be_kind_of(MARC::Record)
      expect(rec.record_type).to eq('SER')
      expect(rec.bibliographic_level).to eq('Integrating resource')
    end
    it "should recognize type 'a' and blvl 's' as a serial" do
      reader = load_marc('ejournal.mrc')
      rec = reader.first
      expect(rec).to be_instance_of(MARC::SerialRecord)
      expect(rec).to be_kind_of(MARC::Record)
      expect(rec.record_type).to eq('SER')
      expect(rec.bibliographic_level).to eq('Serial')
    end
    # TODO: add serial component part if example can be found
  end
  def load_marc(file_name)
    MARC::Reader.new(File.dirname(__FILE__) + '/fixtures/' + file_name)
  end
end
