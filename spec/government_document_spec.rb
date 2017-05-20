require 'enhanced_marc'

RSpec.describe MARC::Record, '#govdoc?' do
  context 'when loading from MARC files' do
    it 'should return false for Book records if not government document' do
      reader = load_marc('book-cosmos.mrc')
      reader.each do |rec|
        expect(rec.govdoc?).to be false
      end
    end
    it 'should return govdoc for Book government documents' do
      reader = load_marc('book-govdoc.mrc')
      reader.each do |rec|
        expect(rec.govdoc?).to eq 'i'
        expect(rec.govdoc?(true)).to eq 'International'
      end
    end
    it 'should return false for Sound records if not government document' do
      reader = load_marc('sound-rec.mrc')
      reader.each do |rec|
        expect(rec.govdoc?).to be false
      end
    end
    it 'should return false for Score records if not government document' do
      reader = load_marc('score.mrc')
      reader.each do |rec|
        expect(rec.govdoc?).to be false
      end
    end
    it 'should return govdoc type for Map government documents' do
      reader = load_marc('map-govdoc.mrc')
      reader.each do |rec|
        expect(rec.govdoc?).to eq 's'
        expect(rec.govdoc?(true)).to eq 'State'
      end
    end
    it 'should return govdoc type for Serial government documents' do
      reader = load_marc('serial-govdoc.mrc')
      reader.each do |rec|
        expect(rec.govdoc?).to eq 'f'
        expect(rec.govdoc?(true)).to eq 'Federal'
      end
    end
    it 'should return govdoc type for Visual government documents' do
      reader = load_marc('film-govdoc.mrc')
      reader.each do |rec|
        expect(rec.govdoc?).to eq 'l'
        expect(rec.govdoc?(true)).to eq 'Local'
      end
    end
  end

  def load_marc(file_name)
    MARC::Reader.new(File.dirname(__FILE__) + '/fixtures/' + file_name)
  end
end
