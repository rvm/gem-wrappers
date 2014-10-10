require 'rubygems/command_manager'
require 'rubygems/installer'
require 'rubygems/version'
require 'gem-wrappers'
require 'gem-wrappers/specification'

class WrappersCommand < Gem::Command
  def initialize
    super 'regenerate_binstubs', 'Re run generation of environment wrappers for gems.'
  end

  def arguments # :nodoc:
    "regenerate        regenerate environment wrappers for current Gem.home"
  end

  def usage # :nodoc:
    "#{program_name} [regenerate]"
  end

  def defaults_str # :nodoc:
    ""
  end

  def description # :nodoc:
    <<-DOC
Show (default) or regenerate environment wrappers for current 'GEM_HOME'.
DOC
  end

  def execute
    args = options[:args] || []
    subcommand = args.shift || ''
    case subcommand
    when '', 'show'
      execute_show(args)
    when 'regenerate'
      execute_regenerate(args)
    when FileExist
      execute_regenerate([File.expand_path(subcommand)])
    else
      execute_unknown subcommand
    end
  end

  def execute_show(list = [])
    list = executables if list.empty?
    $stdout.puts description
    $stdout.puts "   Wrappers path: #{gem_wrappers.wrappers_path}"
    $stdout.puts "Environment file: #{gem_wrappers.environment_file}"
    $stdout.puts "     Executables: #{list.join(", ")}"
  end

  def execute_unknown(subcommand)
    $stderr.puts "Unknown wrapper subcommand: #{subcommand}"
    $stdout.puts description
    false
  end

  def execute_regenerate(list = [])
    list = executables if list.empty?
    execute_show(list) if ENV['GEM_WRAPPERS_DEBUG']
    gem_wrappers.install(list)
  end

private

  def gem_wrappers
    @gem_wrappers ||= GemWrappers
  end

  def executables
    # do not use map(&:...) - for ruby 1.8.6 compatibility
    @executables ||= GemWrappers::Specification.installed_gems.map{|gem| gem.executables }.inject{|sum, n| sum + n } || []
  end
end

require 'gem-wrappers/command/file_exist'
