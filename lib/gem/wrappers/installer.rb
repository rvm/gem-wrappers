require 'erb'

module Gem
  module Wrappers
    class Installer

      def self.wrappers_path
        @wrappers_path ||= Gem.configuration && Gem.configuration[:wrappers_path] ||
          File.join(Gem.dir, 'wrappers')
      end

      def self.environment_file
        @environment_file ||= Gem.configuration && Gem.configuration[:environment_file] ||
          File.join(Gem.dir, 'environment')
      end

      def initialize(installer)
        @installer = installer
      end

      def wrappers_path
        self.class.wrappers_path
      end

      def environment_file
        self.class.environment_file
      end

      def install
        ensure_environment_file
        install_wrapper
      end

      def ensure_environment_file
        return if File.exist?(environment_file)
        binding = Binding.new(:path => )
        ERB.new(environment_file_template).run(binding)
      end

      def environment_file_template
        <<-TEMPLATE
export PATH="<% path %>:$PATH"
export GEM_PATH="<% gem_path %>"
export GEM_HOME="<% gem_home %>"
TEMPLATE
      end

      def install_wrapper
        FileUtils.mkdir_p(wrappers_path) unless File.exist?(wrappers_path)
        # exception based on Gem::Installer.generate_bin
        raise Gem::FilePermissionError.new(wrappers_path) unless File.writable?(wrappers_path)
        # TODO: generate wrapper
      end

    end
  end
end
