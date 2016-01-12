#!/usr/bin/env python2
# -*- coding: utf-8 -*-
import os
import argparse
from neovim import socket_session, Nvim

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="NeoVim TeX client")
    parser.add_argument('--addr', default='/tmp/nvim_tex.sock',
                        help="NeoVim listen address")
    parser.add_argument('file', help="file")
    parser.add_argument('line', type=int, help="line")
    args = parser.parse_args()

    session = socket_session(args.addr)
    nvim = Nvim.from_session(session)

    if not os.path.samefile(nvim.current.buffer.name, args.file):
        nvim.command("e {}".format(os.path.normpath(args.file)))

    nvim.current.window.cursor = (args.line, 0)
    nvim.feedkeys("zz")

# vim: ts=4 sts=4 sw=4 expandtab
