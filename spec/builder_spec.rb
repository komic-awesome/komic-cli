require 'spec_helper'
require 'komic/builder'

describe Komic::Builder do
  subject { Komic::Builder::Factory }
  context "detect file" do
    before { allow(File).to receive(:exists?).and_return(true) }

    context "detect type" do
      before { allow(File).to receive(:directory?).and_return(true) }
      it "detect type" do
        expect( subject.detect_type('test.pdf') ).to be_eql('pdf')
        expect( subject.detect_type('test.zip') ).to be_eql('zip')
        expect( subject.detect_type('test') ).to be_eql('directory')
      end
    end

    it "detect file throw error" do
      expect{ subject.detect_type('.pdf') }.to raise_error RuntimeError
      expect{ subject.detect_type('.zip') }.to raise_error RuntimeError
    end
  end

  it "detect douban_album type" do
    douban_album = "www.douban.com/photos/album/118525984/"

    expect( subject.detect_type("http://#{douban_album}")).to \
      be_eql('douban_album')
    expect( subject.detect_type("https://#{douban_album}")).to \
      be_eql('douban_album')

    expect{ subject.detect_type("#{douban_album}") }.to raise_error RuntimeError
    expect{ subject.detect_type('w.pdf') }.to raise_error RuntimeError
    expect{ subject.detect_type('http://www.douban.com') }.to raise_error RuntimeError
  end
end
