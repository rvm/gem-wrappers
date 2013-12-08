require 'erb'

module GemWrappers
  class Environment

    def self.file
      Gem.configuration && Gem.configuration[:wrappers_environment_file] ||
      File.join(Gem.dir, 'environment')
    end

    def file
      @file ||= self.class.file
    end

    def path_take
      return @path_take if @path_take
      @path_take = Gem.configuration && Gem.configuration[:wrappers_path_take] || 1
      @path_take += gem_path.size
    end

    def ensure
      return if File.exist?(file)
      content = ERB.new(template).result(binding)
      File.open(file, 'w') do |file|
        file.write(content)
      end
      File.chmod(0644, file)
    end

    def template
      @template ||= <<-TEMPLATE
export PATH="<%= path.join(":") %>:$PATH"
export GEM_PATH="<%= gem_path.join(":") %>"
export GEM_HOME="<%= gem_home %>"
TEMPLATE
    end

    def gem_path
      @gem_path ||= Gem.path
    end

    def gem_home
      @gem_home ||= Gem.dir
    end

    def path
      @path ||= ENV['PATH'].split(":").take(path_take)
    end

  end
end
