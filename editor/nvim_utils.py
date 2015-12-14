#!/usr/bin/env python2
# -*- coding: utf-8 -*-

import argparse
import os
import re

from neovim import attach

def is_valid_socket(parser, arg):
    """
    Check whether the socket is valid.
    """
    if not os.path.exists(arg):
        parser.error("neovim socket %s does not exist!" % arg)
    else:
        return arg

def close_buffer(nvim, params):
    print(params)
    res = re.match('\[(\d+)\]', params[0])
    buffer_idx=int(res.group(1))
    nvim.command('silent! bp|bd %i' % buffer_idx)

def main():
    parser = argparse.ArgumentParser(description='Process Neovim queries.')
    parser.add_argument("-s", dest="socket", required=True,
                        help="Neovim socket", metavar="FILE",
                        type=lambda x: is_valid_socket(parser, x))
    parser.add_argument("-q", dest="query", required=True, type=str)
    parser.add_argument("params", nargs=argparse.REMAINDER)

    args = parser.parse_args()

    # Create a python API session attached to unix domain socket
    nvim = attach('socket', path=args.socket)
    params = args.params

    if args.query == "close_buffer":
        close_buffer(nvim, params)

if __name__ == "__main__":
    main()
