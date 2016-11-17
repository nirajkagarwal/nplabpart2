set ns [new Simulator]
set tf [open lab.tr w]
$ns trace-all $tf
set nf [open lab.nam w]
$ns namtrace-all $nf
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
$n0 label "Source/FTP"
$n1 label "Source/Telnet"
$n3 label "Destination/FTP"
$n5 label "Desination/Telnet"
$ns color 1 "red"
$ns color 2 "orange"
$ns duplex-link $n0 $n2 100Mb 1ms DropTail
$ns duplex-link $n1 $n2 100Mb 1ms DropTail
$ns duplex-link $n2 $n3 100Mb 1ms DropTail
$ns duplex-link $n2 $n4 100Mb 1ms DropTail
$ns duplex-link $n4 $n5 100Mb 1ms DropTail
set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
set sink3 [new Agent/TCPSink]
$ns attach-agent $n3 $sink3
set tcp1 [new Agent/TCP]
$ns attach-agent $n1 $tcp1


set telnet1 [new Application/Telnet]
$telnet1 attach-agent $tcp1
set sink5 [new Agent/TCPSink]
$ns attach-agent $n5 $sink5
$telnet1 set packetSize_ 1000Mb
$telnet1 set interval_ 0.00001
#The below code is used to connect the tcp agents & sink.
$ns connect $tcp0 $sink3
$ns connect $tcp1 $sink5
#The below code is used to give a color to tcp and telnet
#packets.
$tcp0 set class_ 1
$tcp1 set class_ 2
proc finish { } {
global ns nf tf
 exec nam lab.nam &
close $nf
close $tf

set ctr1 0
set ctr2 0

set thr1 0
set thr2 0

set fid [open lab.tr r]

# 0   1      2 3  4 
# r 0.101003 0 2 tcp 40 ------- 1 0.0 3.0 0 0


while {[gets $fid line] != -1} { 

       if { [string match "*r*" $line] } {
          #   puts $line
            set fields [regexp -all -inline {\S+} $line]
            
            set c2  [lindex $fields 2]
            set c3  [lindex $fields 3]
          #  puts $c2
          #  puts $c3   
   #   if($1=="r"&&$3=="2"&&$4=="3")
            if {    [expr $c2 == 2] &&  [expr $c3 == 3] }  {
                 set ctr1 [expr $ctr1 + 1 ]
             }
  #  if($1=="r"&&$3=="4"&&$4=="5")
            if {    [expr $c2 == 4] &&  [expr $c3 == 5] }  {
                 set ctr2 [expr $ctr2 + 1 ]
             }
    }
 }

   set thr1 [expr $ctr1 / 5 ] 
   set thr2 [expr $ctr2 / 5 ] 
  puts "No of tcp packets  =   $ctr1" 
  puts "tcp throuput  =   $thr1 packets/sec " 
  puts "No of telnet packets  =   $ctr2"  
  puts "telnet throuput  =   $thr2 packets/sec " 

          
exit 0
}
$ns at 0.1 "$ftp0 start"
$ns at 0.1 "$telnet1 start"
$ns at 5 "finish"
$ns run
