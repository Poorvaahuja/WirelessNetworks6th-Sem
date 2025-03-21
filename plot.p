set terminal png
set output "packet_drop.png"
set title "Packet Drop vs Bandwidth"
set xlabel "Bandwidth (Mb)"
set ylabel "Packets Dropped"
plot "packet_drop.txt" using 1 with lines title "Dropped Packets"
