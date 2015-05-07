#!/usr/bin/env python2

from argparse import RawTextHelpFormatter
from jinja2 import Template
from yaml import load
import argparse
import sys


def parse_arguments():
    description = 'YAML converter'
    epilog = (
      "Examples:\n"
      " $ %(prog)s -f apache -v apache_data -y ./vars/apache_test.yaml\n"
      " $ %(prog)s -f json -v json_data -y ./vars/json_test.yaml")

    parser = argparse.ArgumentParser(
        description=description,
        epilog=epilog,
        formatter_class=RawTextHelpFormatter)
    parser.add_argument(
        '-f', '--format',
        metavar='FORMAT',
        choices=['apache', 'erlang', 'ini', 'json', 'logstash', 'toml', 'xml', 'yaml'],
        required=True,
        help='output format')
    parser.add_argument(
        '-p', '--path',
        metavar='PATH',
        default='.',
        help='path to the macros directory (default: .)')
    parser.add_argument(
        '-v', '--var',
        metavar='NAME',
        help='read data from certain YAML variable')
    parser.add_argument(
        '-y', '--yaml',
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
    # Convert the YAML data to the final format
    encode_method = getattr(t.module, '%s_encode' % args.format)
    output = encode_method(yaml_data)

    # Print the result
    sys.stdout.write(output.encode('utf8'))


if __name__ == '__main__':
    main()
