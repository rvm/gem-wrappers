require 'gem-wrappers/environment'
require 'gem-wrappers/installer'

module GemWrappers

  def self.environment
    @environment ||= GemWrappers::Environment.new
  end

  def self.installer
    @installer ||= GemWrappers::Installer.new(environment_file)
  end

  def self.install(executables)
    environment.ensure
    installer.ensure

    # gem executables
    executables.each do |executable|
      installer.install(executable)
    end

    ruby_executables.each do |executable|
      installer.install(executable)
    end
  end

  def self.uninstall(executables)
    # gem executables
    executables.each do |executable|
      installer.uninstall(executable)
    end
  end

  def self.wrappers_path
    installer.wrappers_path
  end

  def self.environment_file
    environment.file_name
  end

  private

  def self.ruby_executables
    bindir = RbConfig::CONFIG["bindir"].sub(/\/+\z/, '')
    Dir.entries(bindir).select do |file|
      path = "#{bindir}/#{file}"
      !File.directory?(path) && File.executable?(path)
    end
  end

end
