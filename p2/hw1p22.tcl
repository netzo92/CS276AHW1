set ns [new Simulator]

#open trace file
set tracefile [open out.tr w]
$ns trace-all $tracefile

#open the name trace file
set nf [open out.nam w]
$ns namtrace-all $nf


#define the 6 nodes of our network
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]
set n8 [$ns node]

#create links between the nodes
$ns duplex-link $n1 $n2 10Mb 10ms DropTail
$ns duplex-link $n2 $n5 10Mb 10ms DropTail
$ns duplex-link $n2 $n3 10Mb 10ms DropTail
$ns duplex-link $n3 $n4 1.5Mb 10ms DropTail
$ns duplex-link $n3 $n6 10Mb 10ms DropTail
$ns duplex_link $n7 $n2 10Mb 10ms DropTail
$ns duplex_link $n3 $n8 10Mb 10ms DropTail


#setup an udp connection from n1 to n4
set udp [new Agent/UDP]
$ns attach-agent $n1 $udp
set null [new Agent/Null]
$ns attach-agent $n4 $null
$ns connect $udp $null
$udp set fid_ 1

#setup a CBR connection over UDP connection
set cbr1 [new Application/Traffic/CBR]
$cbr attach-agent $udp1
$cbr set type_ CBR
$cbr set packet_size_ 1000
$cbr set rate_ 1Mb
$cbr set random_ false


#define a 'finish' procedure
proc finish {} {
	global ns tracefile nf
	$ns flush-trace
	close $nf
	close $tracefile
	#exec nam out.name &
	exit 0
}


$ns at 0.0 "$cbr1 start"
$ns at 0.1 "$cbr2 start"
$ns at 0.2 "$cbr3 start"
#stop everything
$ns at 5.0 "$cbr1 stop"
$ns at 5.0 "$cbr2 stop"
$ns at 5.0 "$cbr3 stop"

#finish procedure is forced to be called at the end with line
$ns at 5.0 "finish"
$ns run

