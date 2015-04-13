#!/usr/bin/env ruby

require 'erb'
require 'optparse'
require 'ostruct'
require 'yaml'

def parse_arguments
  args = OpenStruct.new

  # Default values
  args.format = nil
  args.help = false
  args.path = '.'
  args.var = nil
  args.yaml_file = nil

  options = OptionParser.new do |opts|
    opts.program_name = $PROGRAM_NAME
    opts.banner = "usage: #{opts.program_name} " \
      '[-h] -f FORMAT [-p PATH] [-v NAME] [-y FILE]'

    opts.separator('')
    opts.separator('YAML converter')
    opts.separator('')
    opts.separator('optional arguments:')

    opts.on(
      '-f', '--format FORMAT',
      'output format') do |f|
      args.format = f
    end

    opts.on(
      '-h', '--help',
      'show this help message and exit') do |h|
      args.help = h
    end

    opts.on(
      '-p', '--path PATH',
      'path to the macros directory (default: .)') do |p|
      args.path = p
    end

    opts.on(
      '-v', '--var NAME',
      'read data from certain YAML variable') do |v|
      args.var = v
    end

    opts.on(
      '-y', '--yaml FILE',
      'YAML file to convert (default: -)') do |y|
      args.yaml_file = y
    end

    opts.separator('')
    opts.separator('Examples:')
    opts.separator(" $ #{opts.program_name} -f apache -v apache_data -y " \
      './vars/apache_test.yaml')
    opts.separator(" $ #{opts.program_name} -f json -v json_data -y " \
      './vars/json_test.yaml')
  end

  options.parse!

  return args, options
end

def main
  # Parse command line arguments
  args, options = parse_arguments

  # Check if help should be displayed
  if args.help
    print options.help
    exit
  end

  # Check if format was specified
  if args.format.nil?
    print options.help
    abort("\nERROR: Format not specified.")
  end

  # Check if specified format is supported
  formats = %w(apache erlang ini json toml xml yaml)
  unless formats.include?(args.format)
    abort('ERROR: Unsuported format. Suported formats are: ' +
      formats.join(', '))
  end

  if args.yaml_file.nil?
    # Read data from pipeline
    yaml_input = ARGF.read
    yaml_load_fnc = YAML.method(:load)
  else
    # Check if the YAML file exists
    abort('ERROR: YAML file not found.') unless File.exist?(args.yaml_file)
    yaml_input = args.yaml_file
    yaml_load_fnc = YAML.method(:load_file)
  end

  # Convert the YAML data to the Ruby data structure
  if args.var.nil?
    item = yaml_load_fnc.call(yaml_input)
  else
    item = yaml_load_fnc.call(yaml_input)[args.var]
  end

  # Check if the macro file exists
  macro_path = "#{args.path}/macros/#{args.format}_encode_macro.erb"
  abort('ERROR: Macro file not found.') unless File.exist?(macro_path)

  # Convert the YAML data to the final format
  binding = OpenStruct.new.send(:binding)
  print ERB.new(IO.read(macro_path), nil, '-', '_erbout0').result(binding)
end

main if __FILE__ == $PROGRAM_NAME
