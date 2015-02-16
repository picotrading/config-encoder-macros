#!/usr/bin/env python2

from jinja2 import Template
from yaml import load
import argparse
import sys


def parse_arguments():
    description = 'YAML to TOML converter'

    parser = argparse.ArgumentParser(description=description)
    parser.add_argument(
        '--format', '-f',
        metavar='FORMAT',
        choices=['erlang', 'ini', 'json', 'toml', 'xml', 'yaml'],
        required=True,
        help='Output format')
    parser.add_argument(
        '--path', '-p',
        metavar='PATH',
        default='.',
        help='Path to the macros directory (default: .)')
    parser.add_argument(
        '--var', '-v',
        metavar='NAME',
        help='Read data from certain YAML variable')
    parser.add_argument(
        '--yaml', '-y',
        metavar='FILE',
        dest='yaml_fh',
        type=argparse.FileType('r'),
        default='-',
        help='YAML file to convert (default: -)')

    return (parser.parse_args(), parser)


def main():
    # Parse command line arguments
    (args, parser) = parse_arguments()

    # Load the YAML data to Python data structure
    yaml_data = load(args.yaml_fh)
    args.yaml_fh.close()

    if args.var:
        yaml_data = yaml_data[args.var]

    # Read Jinja2 template as text
    template_fh = open(
        '%s/macros/%s_encode_macro.j2' % (args.path, args.format))
    template_text = template_fh.read()
    template_fh.close()

    # Create Jinja2 template object
    t = Template(template_text)
    # Convert the YAML data to INI format
    encode_method = getattr(t.module, '%s_encode' % args.format)
    output = encode_method(yaml_data)

    # Print the result
    sys.stdout.write(output.encode('utf8'))


if __name__ == '__main__':
    main()
