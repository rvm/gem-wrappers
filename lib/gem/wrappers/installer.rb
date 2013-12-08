require 'erb'

module Gem
  module Wrappers
    class Installer

      def self.wrappers_path
        @wrappers_path ||= Gem.configuration && Gem.configuration[:wrappers_path] ||
          File.join(Gem.dir, 'wrappers')
      end

      def initialize(executables)
        @executables = executables
      end

      def wrappers_path
        self.class.wrappers_path
      end

      def install
        FileUtils.mkdir_p(wrappers_path) unless File.exist?(wrappers_path)
        # exception based on Gem::Installer.generate_bin
        raise Gem::FilePermissionError.new(wrappers_path) unless File.writable?(wrappers_path)
        # TODO: generate wrapper
      end

    end
  end
end
