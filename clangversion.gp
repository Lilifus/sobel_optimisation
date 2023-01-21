set term png
set output sprintf("./images/clangVersions%s.png",ARG1)

red = "#FF0000"; green = "#00FF00"; blue = "#0000FF"; skyblue = "#87CEEB";
set style data histogram
set style histogram cluster gap 1
set style fill solid
set boxwidth 0.9
set datafile separator ";"
set xlabel "Versions"
set ylabel "Bandwidth in MiB/s"
set grid ytics

set title sprintf("Optimisation comparaison with clang, flags = %s",ARG1)
plot sprintf("./datas/clangBASELINE%s_stderr.dat",ARG1) using 5 title "BASELINE" linecolor rgb red,   \
     sprintf("./datas/clangUNROLLED%s_stderr.dat",ARG1)  using 5 title "UNROLLED" linecolor rgb blue,   \
     sprintf("./datas/clangSQRTLESS%s_stderr.dat",ARG1) using 5 title "SQRTLESS" , \
     sprintf("./datas/clangSSE%s_stderr.dat",ARG1) using 5 title "SSE" linecolor rgb skyblue, \
     sprintf("./datas/clangTHREADS%s_stderr.dat",ARG1) using 5 title "THREADS", \
     sprintf("./datas/clangALL%s_stderr.dat",ARG1) using 5 title "ALL" 
