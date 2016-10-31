set cbr_rate [lindex $argv 0]

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

#create links between the nodes
$ns duplex-link $n1 $n2 10Mb 10ms DropTail
$ns duplex-link $n2 $n5 10Mb 10ms DropTail
$ns duplex-link $n2 $n3 10Mb 10ms DropTail
$ns duplex-link $n3 $n4 10mb 10ms DropTail
$ns duplex-link $n3 $n6 10mb 10ms DropTail

#setup the tcp1 connection between n1 and n4
set tcp1 [new Agent/TCP/Reno]
$ns attach-agent $n1 $tcp1
set sink1 [new Agent/TCPSink]
$ns attach-agent $n4 $sink1
$ns connect $tcp1 $sink1
$tcp1 set fid_ 2

#setup ftp1 over tcp1
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ftp1 set type_ FTP

#setup the tcp2 connection between n1 and n4
set tcp2 [new Agent/TCP/Reno]
$ns attach-agent $n5 $tcp2
set sink2 [new Agent/TCPSink]
$ns attach-agent $n6 $sink2
$ns connect $tcp2 $sink2
$tcp2 set fid_ 1

#setup ftp2 over tcp2
set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2
$ftp2 set type_ FTP

#setup an udp connection from n2 to n3
set udp [new Agent/UDP]
$ns attach-agent $n2 $udp
set null [new Agent/Null]
$ns attach-agent $n3 $null
$ns connect $udp $null
$udp set fid_ 3

#setup a CBR connection over UDP connection
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set type_ CBR
$cbr set packet_size_ 1000
$cbr set rate_ $cbr_rate
$cbr set random_ false

$ns at 0.0 "$cbr start"
$ns at 0.0 "$ftp1 start"
$ns at 0.0 "$ftp2 start"

$ns at 5.0 "$cbr stop"
$ns at 5.0 "$ftp1 start"
$ns at 5.0 "$ftp2 start"

$ns at 5.0 "ns detach-agent $n1 $tcp1 ; $ns detach-agent $n5 $tcp2 "






#define a 'finish' procedure
proc finish {} {
	global ns tracefile nf
	$ns flush-trace
	close $nf
	close $tracefile
	#exec nam out.name &
	exit 0
}


$ns at 0.0 "$cbr start"
$ns at 0.0 "$ftp1 start"
$ns at 0.0 "$ftp2 start"
#stop everything
$ns at 5.0 "$cbr stop"
$ns at 5.0 "$ftp1 stop"
$ns at 5.0 "$ftp2 stop"
#$ns at 5.0 "ns detach-agent $n1 $tcp1 ; $ns detach-agent $n5 $tcp2 "

#finish procedure is forced to be called at the end with line
$ns at 5.0 "finish"
$ns run

