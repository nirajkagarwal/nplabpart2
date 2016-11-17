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


$ns make-lan -trace on "$n0 $n1 $n2 $n3 $n4" 100mb 10ms LL Queue/DropTail Mac/802_3


set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
set sink2 [new Agent/TCPSink]
$ns attach-agent $n2 $sink2
$ns connect $tcp0 $sink2

set udp2 [new Agent/UDP]
$ns attach-agent $n2 $udp2
set cbr2 [new Application/Traffic/CBR]
$cbr2 attach-agent $udp2
set null [new Agent/Null]
$ns attach-agent $n1 $null
$ns connect $udp2 $null

set tcp1 [new Agent/TCP]
$ns attach-agent $n1 $tcp1
set ftp1 [new Application/FTP]

$ftp1 attach-agent $tcp1
set sink3 [new Agent/Null]
$ns attach-agent $n3 $sink3
$ns connect $tcp1 $sink3


$ftp0 set interval_ 0.001
$cbr2 set interval_ 0.001
$ftp1 set interval_ 0.01

proc finish {} {
global ns nf tf
$ns flush-trace
 exec nam lab.nam &
close $tf
close $nf

set ctr1 0
set ctr2 0

set thr1 0
set thr2 0

set fid [open lab.tr r]

# 0   1      2 3  4 
# r 0.101003 0 2 tcp 40 ------- 1 0.0 3.0 0 0
# c 1.592044 2 5 tcp 1054 ------- 0 0.0 2.0 87 1642

while {[gets $fid line] != -1} { 

      if { [string match "*c*" $line] } {
          #   puts $line
            set fields [regexp -all -inline {\S+} $line]
            
            set c0  [lindex $fields 0]
         #   set c3  [lindex $fields 3]
          #  puts $c2
          #  puts $c3   
   #   if($1=="r"&&$3=="2"&&$4=="3")
            if   [ string match "c" $c0]     {
                 set ctr1 [expr $ctr1 + 1 ]
             }
 
    }
 # }

#   set thr1 [expr $ctr1 / 5 ] 
  
  puts "No of  packets collided =   $ctr1" 
#  puts " throuput  =   $thr1 packets/sec " 
 
          



exit 0
}

$ns at 0.1 "$cbr2 start"
$ns at 1.2 "$ftp1 start"
$ns at 1.3 "$ftp0 start"


$ns at 5.0 "finish"


$ns run

