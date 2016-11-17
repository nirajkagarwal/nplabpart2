#         0  1       2 3  4 
set path "r 0.101003 0 2 tcp 40 ------- 1 0.0 3.0 0 0"
if {[string match "*r*" $path]} {
        puts "$path is part of the string"
    }

 set fields [regexp -all -inline {\S+} $path]
 set c0  [lindex $fields 0]
 if {[string match "r" $c0]} {
         puts "equals"
  }


  set c4  [lindex $fields 4]
 if {[string match "tcp" $c4]} {
         puts "equals"
  }


 

