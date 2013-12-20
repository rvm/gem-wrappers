module GemWrappers
  module Specification
    def self.installed_gems
      if Gem::VERSION > '1.8' then
        Gem::Specification.to_a
      else
        Gem.source_index.map{|name,spec| spec}
      end
    end

    def self.find
      @gem_wrappers_spec ||= installed_gems.find{|spec| spec.name == "gem-wrappers" }
    end

    def self.version
      find ? find.version.to_s : nil
    end
  end
end
