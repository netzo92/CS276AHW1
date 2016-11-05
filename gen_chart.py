

import os
import trace_analyzer
import sys



def execute_script(script_name, arg1=None):
	if arg1 is not None:
		k = os.system('ns '+script_name+' '+arg1+' >/dev/null 2>&1')
	else:
		k = os.system('ns '+script_name+' >/dev/null 2>&1')
	return k



if __name__ == "__main__":
	if sys.argv[1] == 'cbr':
		tcl_script = sys.argv[2]
		cbr_rate, cbr_unit = 10, 'mb'
		starting_cbr = cbr_rate/2
		for x in range(starting_cbr, cbr_rate*2):
			execute_script(tcl_script, str(x)+cbr_unit)
			print str(x)+cbr_unit+', '+trace_analyzer.TraceFile.from_file('out.tr').stat_str()
	elif sys.argv[1] == 'time':
		tcl_script = sys.argv[2]
		start_time = 0.0
		interval_jump = 0.25
		end_time = 5.0
		execute_script(tcl_script)
		tfile = trace_analyzer.TraceFile.from_file('out.tr')
		print tfile.streams
		for stream in tfile.streams:
			tfile.streams[stream].bandwidth_through_time(start_time,end_time, interval_jump)
			tfile.streams[stream].end_to_end_through_time(start_time, end_time, interval_jump)

