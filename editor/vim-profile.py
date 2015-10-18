#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import subprocess
import re
import csv
import operator

def run_vim(log_filename):
    print("Running Vim to generate startup logs...", end="")
    if os.path.isfile(log_filename):
        os.remove(log_filename)
    cmd = ["nvim", "--startuptime", log_filename, "-c", "q"]
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

def print_summary(data):
    n = 10
    print("====================================")
    print("Top %i Plugins Slowing Vim's Startup" % n)
    print("====================================")

    # Sort by time
    for name, time in sorted(data.items(), key=operator.itemgetter(1), reverse=True)[:n]:
        print("%.3f\t%s" % (time, name))

    print("====================================")

def main():
    log_filename = "vim.log"
    output_filename = "result.csv"

    run_vim(log_filename)
    data = load_data(log_filename)
    export_result(data, output_filename)
    print_summary(data)
    # plot_data(data)

if __name__ == "__main__":
    main()
