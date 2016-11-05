
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
$ns duplex-link $n2 $n3 1.5Mb 10ms RED
$ns duplex-link $n3 $n4 10Mb 10ms DropTail
$ns duplex-link $n3 $n6 10Mb 10ms DropTail
$ns duplex-link $n3 $n8 10Mb 10ms DropTail
$ns duplex-link $n7 $n2 10Mb 10ms DropTail


#setup an udp connection from n1 to n4
set udp1 [new Agent/UDP]
$ns attach-agent $n1 $udp1
set null [new Agent/Null]
$ns attach-agent $n4 $null
$ns connect $udp1 $null
$udp1 set fid_ 1

#setup a CBR connection over UDP connection
set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1
$cbr1 set type_ CBR
$cbr1 set packet_size_ 1000
$cbr1 set rate_ 1Mb
$cbr1 set random_ false

set udp2 [new Agent/UDP]
$ns attach-agent $n7 $udp2
set null2 [new Agent/Null]
$ns attach-agent $n8 $null2
$ns connect $udp2 $null2
$udp2 set fid_ 2

set cbr2 [new Application/Traffic/CBR]
$cbr2 attach-agent $udp2
$cbr2 set type_ CBR
$cbr2 set packet_size_ 1000
$cbr2 set rate_ 1Mb
$cbr2 set random_ false

set udp3 [new Agent/UDP]
$ns attach-agent $n5 $udp3
set null3 [new Agent/Null]
$ns attach-agent $n6 $null3
$ns connect $udp3 $null3
$udp3 set fid_ 3
set cbr3 [new Application/Traffic/CBR]
$cbr3 attach-agent $udp3
$cbr3 set type_ CBR
$cbr3 set packet_size_ 500
$cbr3 set rate_ 0.6Mb
$cbr3 set random_ false

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

