require 'test_helper'
require 'tempfile'
require 'gem-wrappers'
require 'gem-wrappers/fakes'

describe GemWrappers do
  subject do
    GemWrappers
  end

  before do
    @fake_installer    = GemWrappers::FakeInstaller.new
    @fake_envvironment = GemWrappers::FakeEnvironment.new
    subject.instance_variable_set(:@installer,   @fake_installer)
    subject.instance_variable_set(:@environment, @fake_envvironment)
  end

  it "reads configured file" do
    subject.environment_file.must_equal("/path/to/environment")
  end

  it "reads configured file" do
    subject.wrappers_path.must_equal("/path/to/wrappers")
  end

  it "does create environment and wrapper" do
    subject.install(%w{rake test})
    @fake_envvironment.ensure?.must_equal(true)
    @fake_installer.ensure?.must_equal(true)
    @fake_installer.executables.must_equal(%w{rake test ruby gem erb irb ri rdoc testrb})
  end

  it "does remove wrapper" do
    subject.install(%w{rake})
    @fake_installer.executables.must_equal(%w{rake ruby gem erb irb ri rdoc testrb})
    subject.uninstall(%w{rake})
    @fake_installer.executables.must_equal(%w{ruby gem erb irb ri rdoc testrb})
  end

end
