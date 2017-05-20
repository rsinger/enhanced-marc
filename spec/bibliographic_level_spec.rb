require 'enhanced_marc'

RSpec.describe MARC::Record, '#bibliographic_level' do
  context 'when loading from MARC files' do
    it "parses LDR position 7 'a' as 'Monographic component part" do
      reader = load_marc('ebook_part.mrc')
      reader.each do |rec|
        expect(rec.bibliographic_level).to eq 'Monographic component part'
      end
    end
    it "parses LDR position 7 'c' as 'Collection" do
      reader = load_marc('ebook_coll.mrc')
      reader.each do |rec|
        expect(rec.bibliographic_level).to eq 'Collection'
      end
    end
    it "parses LDR position 7 'd' as 'Subunit" do
      reader = load_marc('sound_recording_subunit.mrc')
      reader.each do |rec|
        expect(rec.bibliographic_level).to eq 'Subunit'
      end
    end
    it "parses LDR position 7 'i' as 'Integrating resource" do
      reader = load_marc('text_web_resource.mrc')
      reader.each do |rec|
        expect(rec.bibliographic_level).to eq 'Integrating resource'
      end
    end
    it "parses LDR position 7 'm' as 'Monograph/Item" do
      reader = load_marc('atlas.mrc')
      reader.each do |rec|
        expect(rec.bibliographic_level).to eq 'Monograph/Item'
      end
    end
    it "parses LDR position 7 's' as 'Serial" do
      reader = load_marc('ejournal.mrc')
      reader.each do |rec|
        expect(rec.bibliographic_level).to eq 'Serial'
      end
    end
  end

  def load_marc(file_name)
    MARC::Reader.new(File.dirname(__FILE__) + '/fixtures/' + file_name)
  end
end
