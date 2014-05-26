require 'erb'
require 'fileutils'

module GemWrappers
  class Installer
    attr_reader :environment_file

    def initialize(environment_file = nil, executable_format = Gem.default_exec_format)
      @environment_file = environment_file
      @executable_format = executable_format
    end

    def self.wrappers_path
      Gem.configuration && Gem.configuration[:wrappers_path] ||
      File.join(Gem.dir, 'wrappers')
    end

    def wrappers_path
      @wrappers_path ||= self.class.wrappers_path
    end

    def ensure
      FileUtils.mkdir_p(wrappers_path) unless File.exist?(wrappers_path)
      # exception based on Gem::Installer.generate_bin
      raise Gem::FilePermissionError.new(wrappers_path) unless File.writable?(wrappers_path)
    end

    def uninstall(executable)
      file_name = File.join(wrappers_path, executable)
      File.delete(file_name) if File.exist?(file_name)
    end

    def install(executable)
      raise "Missing environment file for initialize!" unless @environment_file
      @executable = executable
      content = ERB.new(template).result(binding)
      install_file(executable, content)
      install_ty_formatted(executable, content)
    end

    def install_ty_formatted(executable, content)
      formated_executble = @executable_format % executable
      if
        formated_executble != executable
      then
        install_file(formated_executble, content)
      end
    end

    def install_file(executable, content)
      file_name = File.join(wrappers_path, File.basename(executable))
      File.open(file_name, 'w') do |file|
        file.write(content)
      end
      file_set_executable(file_name)
    end

    def executable_expanded
      if File.extname(@executable) == ".rb"
      then "ruby #{@executable}"
      else @executable
      end
    end

    def template
      @template ||= <<-TEMPLATE
#!/usr/bin/env bash

if
  [[ -s "<%= environment_file %>" ]]
then
  source "<%= environment_file %>"
  exec <%= executable_expanded %> "$@"
else
  echo "ERROR: Missing RVM environment file: '<%= environment_file %>'" >&2
  exit 1
fi
TEMPLATE
    end

  private
    def file_set_executable(file_name)
      stat = File.stat(file_name)
      File.chmod(stat.mode|0111, file_name) unless stat.mode&0111 == 0111
    end

  end
end
