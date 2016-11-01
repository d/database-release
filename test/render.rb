#!/usr/bin/env ruby

require 'erb'

# test/render.rb jobs/master/templates/common.bash

def main(filename)
  erb = ERB.new(File.read(filename))
  erb.run(TemplateRenderContext.new.b)
end

class TemplateRenderContext
  def link(job)
    Link.new
  end

  def b
    binding
  end
end

class Link
  def instances
    [InstanceSpec.new]
  end
end

class InstanceSpec
  def address
    '10.244.0.4'
  end

  def index
    0
  end
end

main(*ARGV)
