require 'spec_helper'
require 'komic/builder'

describe Komic::Utils do
  subject { Komic::Builder::Factory }
  before { allow(File).to receive(:exists?).and_return(true) }
  it "detect pdf type" do
    expect( subject.detect_type('test.pdf') ).to be_eql('pdf')
    expect{ subject.detect_type('.pdf') }.to raise_error
  end
end
