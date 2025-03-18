# Create a simulator instance
set ns [new Simulator]

# Create nodes
set n1 [$ns node]
set n2 [$ns node]

# Create a link between nodes
$ns duplex-link $n1 $n2 1Mb 10ms DropTail

# Define a TCP connection
set tcp [new Agent/TCP]
$ns attach-agent $n1 $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $n2 $sink
$ns connect $tcp $sink

# Start simulation
$ns run
