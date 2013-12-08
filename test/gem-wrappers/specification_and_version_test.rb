require 'test_helper'
require 'gem-wrappers/specification'
require 'gem-wrappers/version'

describe GemWrappers::Specification do

  it "finds specification" do
    GemWrappers::Specification.find.name.must_equal("gem-wrappers")
  end

  it "gets specification version" do
    GemWrappers::Specification.version.must_equal(GemWrappers::VERSION)
  end

end
