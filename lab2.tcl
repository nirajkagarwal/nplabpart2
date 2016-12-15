set ns [new Simulator]
set nf [open lab.tr w]
$ns trace-all $nf
set tf [open lab.nam w]
$ns namtrace-all $tf

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

$ns duplex-link $n0 $n2 100Mb 1ms DropTail
$ns duplex-link $n1 $n2 100Mb 1ms DropTail
$ns duplex-link $n2 $n3 100Mb 1ms DropTail

set tcp0 [new Agent/TCP]
set udp1 [new Agent/UDP]
set TCPS3 [new Agent/TCPSink]
set null3 [new Agent/Null]
$ns attach-agent $n0 $tcp0
$ns attach-agent $n1 $udp1
$ns attach-agent $n3 $TCPS3
$ns attach-agent $n3 $null3
set ftp0 [new Application/FTP]
set cbr1 [new Application/Traffic/CBR]
$ftp0 attach-agent $tcp0
$cbr1 attach-agent $udp1

$ns connect $udp1 $null3
$ns connect $tcp0 $TCPS3

proc finish { } {
global ns nf tf
$ns flush-trace
exec nam lab.nam &
close $tf
close $nf
set ctr0 0
set ctr1 0
set fid [open lab.tr r]
while {[gets $fid line] != -1} {
	if { [string match "*tcp*" $line] } {
		set ctr0 [expr $ctr0 + 1]
	}
	if { [string match "*cbr*" $line] } {
		set ctr1 [expr $ctr1 + 1]
	}
}
puts "No of tcp packets: $ctr0"
puts "No of udp packets: $ctr1"
exit 0
}
$ns at 0.01 "$ftp0 start"
$ns at 0.01 "$cbr1 start"
$ns at 5.0 "finish"
$ns run
