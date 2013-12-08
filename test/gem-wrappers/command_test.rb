require 'test_helper'
require 'tempfile'
require 'gem-wrappers/command'

describe WrappersCommand do
  subject do
    WrappersCommand.new
  end

  before do
    $stdout = StringIO.new
    $stderr = StringIO.new
  end

  after do
    $stdout = STDOUT
    $stderr = STDERR
  end

  it "has some strings" do
    subject.arguments.class.must_equal(String)
    subject.usage.class.must_equal(String)
    subject.defaults_str.class.must_equal(String)
    subject.description.class.must_equal(String)
    subject.program_name.class.must_equal(String)
  end

  it "shows help on unknown command" do
    subject.options[:args] = ['wrong']
    subject.execute
  end

end
