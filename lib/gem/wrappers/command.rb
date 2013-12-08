require 'rubygems/command_manager'
require 'rubygems/installer'
require 'rubygems/version'
require 'gem/wrappers/installer'

class WrappersCommand < Gem::Command
  def initialize
    super 'regenerate_binstubs', 'Re run generation of executable wrappers for gems.'
  end

  def arguments # :nodoc:
    "regenerate        regenerate wrappers for current Gem.home"
  end

  def usage # :nodoc:
    "#{program_name} [regenerate]"
  end

  def defaults_str # :nodoc:
    ""
  end

  def description # :nodoc:
    <<-DOC
Show (default) or regenerate environment wrappers for current 'Gem.home'.
DOC
  end

  def execute
    subcommand = get_one_optional_argument || ''
    case subcommand
    when ''
      execute_show
    when 'regenerate'
      execute_regenerate
    else
      execute_unknown subcommand
    end
  end

  def execute_show
    puts "Wrappers path: #{Gem::Wrappers::Installer.wrappers_path}"
  end

  def execute_unknown(subcommand)
    $stderr.puts "Unknown wrapper subcommand: #{subcommand}"
    puts description
    false
  end

  def execute_regenerate
    installed_gems.each do |spec|
      unless spec.executables.empty?
        org_gem_path = Gem.path.find{|path|
          File.exists? File.join path, 'gems', spec.full_name
        } || Gem.dir
        cache_gem = File.join(org_gem_path, 'cache', spec.file_name)
        if File.exist? cache_gem
          puts "#{spec.name} #{spec.version}" # TODO: if verbose || unless quiet
          installer = Gem::Installer.new Dir[cache_gem].first, :wrappers => true, :force => true, :install_dir => org_gem_path
          Gem::Wrappers::Installer.new(installer).install
        else
          $stderr.puts "##{spec.name} #{spec.version} not found in GEM_PATH"
        end
      end
    end
  end

  private
  def installed_gems
    if Gem::VERSION > '1.8' then
      Gem::Specification.to_a
    else
      Gem.source_index.map{|name,spec| spec}
    end
  end
end
