
class TraceEvent:
	def __init__(self, *args):
		self.event_type = args[0]
		self.time = float(args[1])
		self.source_node = int(args[2])
		self.dest_node = int(args[3])
		self.packet_type = args[4]
		self.packet_size = int(args[5])
		self.flags = args[6]
		self.flow_id = int(args[7])
		self.source_addr, self.dest_addr = int(args[8].split(".")[0]), int(args[9].split(".")[0])
		self.sequence_number = int(args[10])
		self.packed_uid = int(args[11])

class Flow:
	
	def __init__(self, flow):
		self.events = []
		self.trace_length = 0.0
		self.flow = flow
	

	def add(self, event):
		self.events.append(event)
		if event.time > self.trace_length:
			self.trace_length = event.time		
	
	def calculate_average_loss_rate(self):
		recieved_packets = 0
		dropped_packets = 0 
		for event in self.events:
			if event.event_type in('d', 'c'):
				dropped_packets += 1
			if event.event_type == 'r' and (event.dest_node == event.dest_addr):
				recieved_packets += 1
		drop_rate = float(dropped_packets)/float(recieved_packets+dropped_packets)
		return drop_rate

	def calculate_average_throughput(self):
		bytes_transferred = 0
		for event in self.events:
			if event.event_type == 'r' and (event.dest_node == event.dest_addr):
				bytes_transferred += event.packet_size
		return bytes_transferred/self.trace_length


	def print_stats(self):
		print "LR: %f AT: %f" % (self.calculate_average_loss_rate(), self.calculate_average_throughput())

	def return_stats(self):
		return {'lr': self.calculate_average_loss_rate(),'at': self.calculate_average_throughput()}
	

class TraceFile:
	
	@staticmethod
	def from_file(file_name):
		tfile = TraceFile()
		for line in open(file_name, 'r'):
			event = TraceEvent(*line.split(' '))
			tfile.into_stream(event.flow_id, event)
		return tfile

	def into_stream(self, stream_number, event):
		if stream_number not in self.streams:
			self.streams[stream_number] = Flow(stream_number)
		self.streams[stream_number].add(event)

	def __init__(self):
		self.streams = {}

	def return_stats(self):
		stat_dict = {}
		for x in range(1,4):
			stat_dict[x] = self.streams[x]
		return stat_dict

	def stat_str(self):
		string = ''
		stat_dict = self.return_stats()
		for x in range(1,4):
			string += str(x)+', '+str(stat_dict[x].return_stats()['lr']) +', '+ str(stat_dict[x].return_stats()['at']) +', '
		return string
			
#three streams

def main():
	tfile = TraceFile.from_file('out.tr')
	for i in range(1,4):
		print "Flow: %d" % i
		tfile.streams[i].print_stats()

if __name__ == "__main__":
	main()

			
