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
set n6 [$ns node]


#$n0 label "Ping0"
#$n4 label "Ping4"
#$n5 label "Ping5"
#$n6 label "Ping6"
##$n2 label "Router"
#$ns color 1 "red"
#$ns color 2 "green"


$ns duplex-link $n0 $n2 100Mb 300ms DropTail
$ns duplex-link $n2 $n6 1Mb 300ms DropTail
$ns duplex-link $n5 $n2 100Mb 300ms DropTail
$ns duplex-link $n2 $n4 1Mb 300ms DropTail
$ns duplex-link $n3 $n2 1Mb 300ms DropTail
$ns duplex-link $n1 $n2 1Mb 300ms DropTail


$ns queue-limit $n0 $n2 5
$ns queue-limit $n2 $n6 2
$ns queue-limit $n2 $n4 3
$ns queue-limit $n5 $n2 5

#The below code is used to connect between the ping agents
#to the node n0, n4 , n5 and n6.

set ping0 [new Agent/Ping]
$ns attach-agent $n0 $ping0

set ping4 [new Agent/Ping]
$ns attach-agent $n4 $ping4

set ping5 [new Agent/Ping]
$ns attach-agent $n5 $ping5

set ping6 [new Agent/Ping]
$ns attach-agent $n6 $ping6

#$ping0 set packetSize_ 50000
#$ping0 set interval_ 0.0001
#$ping5 set packetSize_ 60000
#$ping5 set interval_ 0.00001
#$ping0 set class_ 1
#$ping5 set class_ 2

$ns connect $ping0 $ping4
$ns connect $ping5 $ping6

#The below function is executed when the ping agent receives
#a reply from the destination

Agent/Ping instproc recv {from rtt} {
$self instvar node_
puts " The node [$node_ id] received an reply from $from with round trip time of $rtt"
}

proc finish {} {
global ns nf tf
exec nam lab.nam &
$ns flush-trace
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

      if { [string match "*d*" $line] } {
          #   puts $line
           # set fields [regexp -all -inline {\S+} $line]
            
           # set c0  [lindex $fields 0]
         #   set c3  [lindex $fields 3]
          #  puts $c2
          #  puts $c3   
   #   if($1=="r"&&$3=="2"&&$4=="3")
           # if   [ string match "*c*" "$c0"]     {
                 set ctr1 [expr $ctr1 + 1 ]
           #  }
 
    }
 # }

#   set thr1 [expr $ctr1 / 5 ] 
  
  puts "No of  packets droped =   $ctr1" 
#  puts " throuput  =   $thr1 packets/sec " 
 
          



exit 0
}
$ns rtmodel-at 0.9 down $n2 $n6
$ns rtmodel-at 1.5 up $n2 $n6
$ns at 0.1 "$ping0 send"
$ns at 0.2 "$ping0 send"
$ns at 0.3 "$ping0 send"
$ns at 0.4 "$ping0 send"
$ns at 0.5 "$ping0 send"
$ns at 0.6 "$ping0 send"
$ns at 0.7 "$ping0 send"
$ns at 0.8 "$ping0 send"
$ns at 0.9 "$ping0 send"
$ns at 1.0 "$ping0 send"
$ns at 1.1 "$ping0 send"
$ns at 1.2 "$ping0 send"
$ns at 1.3 "$ping0 send"
$ns at 1.4 "$ping0 send"
$ns at 1.5 "$ping0 send"
$ns at 1.6 "$ping0 send"
$ns at 1.7 "$ping0 send"
$ns at 1.8 "$ping0 send"
$ns at 0.1 "$ping5 send"
$ns at 0.2 "$ping5 send"
$ns at 0.3 "$ping5 send"
$ns at 0.4 "$ping5 send"
$ns at 0.5 "$ping5 send"
$ns at 0.6 "$ping5 send"
$ns at 0.7 "$ping5 send"
$ns at 0.8 "$ping5 send"
$ns at 0.9 "$ping5 send"
$ns at 1.0 "$ping5 send"
$ns at 1.1 "$ping5 send"
$ns at 1.2 "$ping5 send"
$ns at 1.3 "$ping5 send"
$ns at 1.4 "$ping5 send"
$ns at 1.5 "$ping5 send"
$ns at 1.6 "$ping5 send"
$ns at 1.7 "$ping5 send"
$ns at 1.8 "$ping5 send"
$ns at 5.0 "finish"
$ns run
