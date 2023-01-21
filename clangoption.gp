set term png
set output sprintf("./images/clangOptions%s.png",ARG1)

red = "#FF0000"; green = "#00FF00"; blue = "#0000FF"; skyblue = "#87CEEB";
set style data histogram
set style histogram cluster gap 1
set style fill solid
set boxwidth 0.9
set datafile separator ";"
set xlabel "Flags"
set ylabel "Bandwidth in MiB/s"
set grid ytics

set title sprintf("Comparaison de flags, Version %s",ARG1)
plot sprintf("./datas/clang%s-march=native-O1_stderr.dat",ARG1) using 5 title "O1" linecolor rgb red,   \
     sprintf("./datas/clang%s-march=native-Ofast_stderr.dat",ARG1) using 5 title "Ofast"
