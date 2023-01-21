set term png
set output sprintf("./images/Versions%s.png",ARG1)

red = "#FF0000"; green = "#00FF00"; blue = "#0000FF"; skyblue = "#87CEEB";
set style data histogram
set style histogram cluster gap 1
set style fill solid
set boxwidth 0.9
set datafile separator ";"
set xlabel "Versions"
set ylabel "Bandwidth in MiB/s"
set grid ytics

set title sprintf("Optimisation comparaison, flags = %s",ARG1)
plot sprintf("./datas/BASELINE%s_stderr.dat",ARG1) using 5 title "BASELINE" linecolor rgb red,   \
     sprintf("./datas/UNROLLED%s_stderr.dat",ARG1)  using 5 title "UNROLLED" linecolor rgb blue,   \
     sprintf("./datas/SQRTLESS%s_stderr.dat",ARG1) using 5 title "SQRTLESS" , \
     sprintf("./datas/SSE%s_stderr.dat",ARG1) using 5 title "SSE" linecolor rgb skyblue, \
     sprintf("./datas/THREADS%s_stderr.dat",ARG1) using 5 title "THREADS", \
     sprintf("./datas/ALL%s_stderr.dat",ARG1) using 5 title "ALL" 
