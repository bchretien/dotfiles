#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import subprocess
import re
import csv
import operator
import argparse

def run_vim(exe, log_filename):
    print("Running %s to generate startup logs..." % exe, end="")
    if os.path.isfile(log_filename):
        os.remove(log_filename)
    cmd = [exe, "--startuptime", log_filename, "-c", "q"]
    subprocess.call(cmd, shell=False)
    print(" done.")

def load_data(log_filename):
    print("Loading and processing logs...", end="")
    data = {}
    # Load log file and process it
    with open(log_filename, 'r') as log:
        for line in log:
            if re.search("plugged", line):
                res = re.match('\d+.\d+\s+\d+.\d+\s+(\d+.\d+): sourcing [\w\/\s.-]+/plugged/([^/]+)', line)
                time = res.group(1)
                plugin = res.group(2)
                if plugin in data:
                    data[plugin] += float(time)
                else:
                    data[plugin] = float(time)
    print(" done.")

    return data

def plot_data(data):
    import matplotlib
    matplotlib.use('Qt5Agg')
    import pylab

    print("Plotting result...", end="")
    pylab.barh(range(len(data)), data.values(), align='center')
    pylab.yticks(range(len(data)), list(k for k in data.keys()))
    pylab.xlabel("Startup time (ms)")
    pylab.ylabel("Plugins")
    pylab.show()
    print(" done.")

def export_result(data, output_filename="result.csv"):
    # Write sorted result to file
    print("Writing result to %s..." % output_filename, end="")
    with open(output_filename, 'w') as fp:
        writer = csv.writer(fp, delimiter='\t')
        # Sort by time
        for name, time in sorted(data.items(), key=operator.itemgetter(1), reverse=True):
            writer.writerow(["%.3f" % time, name])
    print(" done.")

def print_summary(data, exe):
    n = 10
    title = "Top %i plugins slowing %s's startup" % (n, exe)
    length = len(title)
    print(''.center(length, '='))
    print(title)
    print(''.center(length, '='))

    # Sort by time
    rank = 0
    for name, time in sorted(data.items(), key=operator.itemgetter(1), reverse=True)[:n]:
        rank += 1
        print("%i\t%.3f\t%s" % (rank, time, name))

    print(''.center(length, '='))

def main():
    parser = argparse.ArgumentParser(description='Analyze startup times of plugins.')
    parser.add_argument("-o", dest="csv", type=str)
    parser.add_argument("-p", dest="plot", action='store_true')
    parser.add_argument(dest="exe", nargs='?', const=1, type=str, default="vim")

    args = parser.parse_args()
    exe = args.exe
    log_filename = "vim.log"
    output_filename = args.csv

    run_vim(exe, log_filename)
    data = load_data(log_filename)
    print_summary(data, exe)
    if output_filename is not None:
        export_result(data, output_filename)
    if args.plot:
        plot_data(data)

if __name__ == "__main__":
    main()
