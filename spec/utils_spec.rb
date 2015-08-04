require 'spec_helper'
require 'komic/utils'

describe Komic::Utils do
  it "get relative path" do
    relative_path = subject.get_relative_path("/user/x/abc", "/user/x")
    expect(relative_path).to be_eql("./abc")
  end

  before { allow(Random).to receive(:rand).and_return(700) }
  it "parse `komic mock`'s size opt" do
    expect(subject.parse_size("700-800x900")).to be_eql({ width: 700, height: 900 })
    expect(subject.parse_size("800x700-900")).to be_eql({ width: 800, height: 700 })
    expect(subject.parse_size("800x900")).to be_eql({ width: 800, height: 900 })
  end
end
