require 'gem-wrappers/environment'
require 'gem-wrappers/installer'

module GemWrappers
  def self.install(specs)
    environment = Gem::Wrappes::Environment.new
    environment.ensure
    wrappers = Gem::Wrappes::Installer.new(environment.file)
    wrappers.ensure
    specs.each do |spec|
      spec.executables.each do |executable|
        wrappers.install(executable)
      end
    end
  end
end
