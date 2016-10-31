

import os
import trace_analyzer
import sys



def execute_script(script_name, arg1):
	k = os.system('ns '+script_name+' '+arg1+' >/dev/null 2>&1')
	return k



if __name__ == "__main__":
	tcl_script = sys.argv[1]
	cbr_rate, cbr_unit = 10, 'mb'
	trace = trace_analyzer.TraceFile.from_file('out.tr')
	starting_cbr = cbr_rate/2
	for x in range(starting_cbr, cbr_rate*2):
		execute_script(tcl_script, str(x)+cbr_unit)
		print str(x)+cbr_unit+', '+trace_analyzer.TraceFile.from_file('out.tr').stat_str()
	
