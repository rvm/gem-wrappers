require 'test_helper'
require 'tempfile'
require 'gem-wrappers'
require 'gem-wrappers/fakes'

describe GemWrappers do
  subject do
    GemWrappers
  end

  describe "fake" do
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

  describe "real" do
    before do
      file = Tempfile.new('wrappers')
      @test_path = file.path
      file.close
      file.unlink
      Dir.mkdir(@test_path)

      subject.instance_variable_set(:@installer,   nil)
      subject.instance_variable_set(:@environment, nil)

      @wrappers_path    = File.join(@test_path, "wrappers")
      @environment_path = File.join(@test_path, "environment")
      @rake_wrapper     = File.join(@wrappers_path, "rake")

      ENV['GEMRC'] = File.join(@test_path, ".gemrc")
      File.open(ENV['GEMRC'], "w") do |file|
        file.write <<-GEMRC
wrappers_path: #{@wrappers_path}
wrappers_environment_file: #{@environment_path}
GEMRC
      end
      Gem.instance_variable_set(:@configuration, Gem::ConfigFile.new([]))
    end

    after do
      ENV['GEMRC'] = nil
      Gem.instance_variable_set(:@configuration, Gem::ConfigFile.new([]))
      FileUtils.rm_rf(@test_path)
    end

    it "installas wrappers" do
      File.exist?(@rake_wrapper).must_equal(false)
      subject.install(%w{rake})
      File.exist?(@rake_wrapper ).must_equal(true)
    end

    it "removes wrappers" do
      File.exist?(@rake_wrapper ).must_equal(false)
      Dir.mkdir(@wrappers_path)
      File.open(@rake_wrapper, "w") do |file|
        file.puts "small wrapper"
      end
      subject.uninstall(%w{rake})
      File.exist?(@rake_wrapper ).must_equal(false)
    end
  end

end
