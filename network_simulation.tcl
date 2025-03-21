# Create a Simulator
set ns [new Simulator]

# Open Trace file and NAM file
set ntrace [open out1.tr w]
$ns trace-all $ntrace
set namfile [open out1.nam w]
$ns namtrace-all $namfile

# Define Finish Procedure
proc Finish {} {
    global ns namfile ntrace
    $ns flush-trace
    close $ntrace
    close $namfile
    exec echo "The number of packet drops is:"
    exec grep -c "^d" out1.tr
    exec nam out1.nam &
    exit 0
}

# Create 4 nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

# Label the nodes
$n0 label "TCPSource"
$n1 label "Node 2"
$n2 label "Node 3"
$n3 label "Sink"

# Set link colors
$ns color 1 blue

# Create Duplex Links between nodes with different bandwidths
$ns duplex-link $n0 $n1 0.2Mb 5ms DropTail
$ns duplex-link $n1 $n2 0.3Mb 10ms DropTail
$ns duplex-link $n2 $n3 0.4Mb 15ms DropTail


# Make the link orientation
$ns duplex-link-op $n0 $n1 orient right
$ns duplex-link-op $n1 $n2 orient right
$ns duplex-link-op $n2 $n3 orient right

# Set Queue Size (Limited to force packet drops)
$ns queue-limit $n0 $n1 3
$ns queue-limit $n1 $n2 3
$ns queue-limit $n2 $n3 3

# Set up a TCP connection
set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0
set sink0 [new Agent/TCPSink]
$ns attach-agent $n3 $sink0
$ns connect $tcp0 $sink0

set cbr0 [new Application/Traffic/CBR]
$cbr0 set type_ CBR
$cbr0 set packetSize_ 500
$cbr0 set rate_ 1Mb
$cbr0 set random_ false
$cbr0 attach-agent $tcp0


# Schedule Events
$ns at 0.1 "$cbr0 start"
$ns at 20.0 "Finish"


# Run the Simulation
$ns run
