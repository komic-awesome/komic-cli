require 'spec_helper'
require 'komic/builder'

describe Komic::Builder do
  subject { Komic::Builder::Factory }
  context "detect file" do
    before { allow(File).to receive(:exists?).and_return(true) }
    it "detect pdf type" do
      expect( subject.detect_type('test.pdf') ).to be_eql('pdf')
    end
    it "detect zip type" do
      expect( subject.detect_type('test.zip') ).to be_eql('zip')
    end
    it "detect throw error" do
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
