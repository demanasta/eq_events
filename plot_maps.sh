#!/bin/bash
#plot network maps
# //////////////////////////////////////////////////////////////////////////////
# GMT parameters 5
gmtset MAP_FRAME_TYPE fancy
gmtset PS_PAGE_ORIENTATION portrait
gmtset FONT_ANNOT_PRIMARY 9 FONT_LABEL 9 MAP_FRAME_WIDTH 0.10c FONT_TITLE 12p
gmtset PS_MEDIA 17.5cx22c

#########GMT4
# gmtset BASEMAP_TYPE fancy
# gmtset PAGE_ORIENTATION portrait
# gmtset ANNOT_FONT_SIZE_PRIMARY 8 LABEL_FONT_SIZE 8 FRAME_WIDTH 0.10c HEADER_FONT_SIZE 12p
# gmtset PAPER_MEDIA Custom_17.5cx22c

# //////////////////////////////////////////////////////////////////////////////
# Set PATHS parameters
pth2dems=${HOME}/Map_project/dems
pth2logo=${HOME}/Map_project/logos

# //////////////////////////////////////////////////////////////////////////////
# Pre-defined parameters for GMT
outfile=lefkada-disp.eps
out_jpg=lefkada-disp.jpg
inputTopoL=${pth2dems}/ionio.grd
inputTopoB=${pth2dems}/greeceSRTM.grd #/ETOPO1_Bed_g_gmt4.grd
landcpt=land_man.cpt
bathcpt=bath_man.cpt

# //////////////////////////////////////////////////////////////////////////////
# Set region parameters

# this is for lemnos plots
# 	frame=0.2
# 	scale=-Lf20.3/37.94/36:24/10+l+jr
# 	range=-R24.5/26.5/39.4/41
# 	proj=-Jm25/40/1:500000
	
	
# 	frame=0.2
# 	scale=-Lf20.3/37.94/36:24/10+l+jr
# 	range=-R20.2/21/37.9/38.59
# 	proj=-Jm20.4/38/1:500000
	
# //////////////////////////////////////////////////////////////////////////////
#  EXTENDED for all the sites
# 	gmtset PS_MEDIA 17.5cx22c
# 	frame=0.2
# 	scale=-Lf20.8/38.03/36:24/10+l+jr
# 	range=-R20.17/20.92/37.98/38.90
# 	proj=-Jm20.4/38/1:600000
# 	
	
	gmtset PS_MEDIA 19.5cx22c
	frame=0.2
	scale=-Lf20.8/38.42/36:24/10+l+jr
	range=-R20.28/20.92/38.38/38.96
	proj=-Jm20.4/38/1:400000
	

# //////////////////////////////////////////////////////////////////////////////
#  JCephallonia region... plot velocities
#  	gmtset PS_MEDIA 17.5cx22c
# 	frame=0.2
# 	scale=-Lf20.3/37.94/36:24/10+l+jr
# 	range=-R20.2/23/37.6/38.68
# 	proj=-Jm20.4/38/1:900000


# 	pscoast $range $proj -B$frame:."network $network": -Df -W0.5/0/0/0 -G195  -U"DSO-HGL/NTUA" -K > $outfile
# 	psbasemap -R -J -O -K --ANNOT_FONT_SIZE_PRIMARY=10p $scale --LABEL_FONT_SIZE=10p >> $outfile

	makecpt -Cgebco.cpt -T-7000/0/150 -Z > $bathcpt
	grdimage $inputTopoB $range $proj -C$bathcpt -K > $outfile
	pscoast $proj -P $range -Df -Gc -K -O >> $outfile
	# land
	makecpt -Cgray.cpt -T-6000/1500/50 -Z > $landcpt
	grdimage $inputTopoL $range $proj -C$landcpt  -K -O >> $outfile
	pscoast -R -J -O -K -Q >> $outfile
	#------- coastline -------------------------------------------
	psbasemap -R -J -O -K  $scale >> $outfile
	pscoast -Jm -R -B$frame -Df -W0.5,black -K -O -U/2.8c/-1.5c/"DSO-HGL/NTUA" >> $outfile
# //////////////////////////////////////////////////////////////////////////////
# PLOT FOCAL MECHANISMS
psmeca <<EOF $range -Jm -Sc0.9/10 -CP0.025 -K -O -P >> $outfile
#lon lat depth str dip slip st dip slip magnt exp plon plat
20.5957 38.6662 10 203 88 159 293 69 2 6.4 0 20.45 38.66 t071007 Mw=6.4
20.557 38.6515 8 119 57 27 14 68 144 5 0 20.46 38.60 t083340 Mw=5.0
20.4857 38.4862 2 119 86 27 27 63 176 4 0 20.4 38.49 t114945
20.6145 38.7025 4 312 83 23 219 67 172 4.5 0 20.45 38.79 t115725
20.6538 38.7022 4 211 69 165 306 76 22 4.7 0 20.76 38.74 t123756
20.6017 38.704 4 224 30 176 317 88 60 4.2 0 20.42 38.74 t193934
20.5177 38.4967 8 345 67 157 84 69 25 4.4 0 20.4 38.53 18t051813
20.5915 38.8443 10 196 81 -165 103 75 -10 5 0 20.49 38.9 18t121538
## Kefalonia
# 20.39 38.22 6 18 67 164 114 75 24 6.0 0 20.31 38.09 Jan26, Mw=6.0
# 20.39 38.22 6 18 67 164 114 75 24 6.0 0 20.31 38.28 Jan26, Mw=6.0
# 20.4417 38.236 6 149 64 65 16 35 131 5.3 0 20.54 38.35 Jan 26, Mw=5.3
# 20.3737 38.2535 10.5 294 78 35 196 56 166 5.9 0 20.32 38.37 Feb 3, Mw=5.9
EOF

psxy <<EOF -Jm -O -R -Sa0.4c -Gred -K >> $outfile
20.5957 38.6662
20.557 38.6515
20.4857 38.4862
20.6145 38.7025
20.6538 38.7022
20.6017 38.704
20.5177 38.4967
20.5915 38.8443
## Kefalonia
# 20.39 38.22
# 20.4417 38.236
# 20.3737 38.2535
EOF

# //////////////////////////////////////////////////////////////////////////////
# PLOT CAMPAIGN SITES!!
# pstext <<EOF -Jm -R -Dj0.1c/0.1c -G0/0/0 -O -V -K>> $outfile
# 20.5478 38.2230 8 0 1 RB EQ140126
# EOF

# awk '{print $5,$4}' camp-ionio.sites | psxy -H1 -Jm -O -R -Sc0.2c -Gblack -K >> $outfile
# awk '{print $5,$4,9, 0, 1,"LB",$3}' camp-ionio.sites | pstext  -H1 -Jm -R -Dj0.1c/0.1c -G0/0/0 -O -V -K >> $outfile


# awk '{print $5,$4}' camp-sing.sites | psxy -Jm -O -R -Sc0.2c -Gblack -K >> $outfile
# awk '{print $5,$4,9, 0, 1, "RB",$3}' camp-sing.sites | pstext  -H1 -Jm -R -Dj0.1c/0.1c -G0/0/0 -O -V -K >> $outfile


psxy <<EOF -Jm -O -R -St0.32c -Gblack -K >> $outfile
20.5886441 38.1768271
20.5851789 38.6189990
20.43816 38.19571
20.6736383 38.7813002
20.3483515 +38.2031859
20.7084 38.8299
#21.40783 38.62345
#21.46474 38.055834
#21.35537 37.79594
EOF
# 
pstext <<EOF -Jm -R -Dj0.2c/0.2c -Gwhite -O -V -K >> $outfile
20.5886441 38.1768271 9 0 1 LT VLSM
20.5851789 38.6189990 9 0 1 LB PONT
20.43816 38.19571 9 0 1 LT KEFA
20.6736383 38.7813002 9 0 1 RB SPAN
20.3483515 +38.2031859 9 0 1 RT KIPO
20.7084 38.8299 9 0 1 LB LEUK
#21.40783 38.62345 9 0 1 RB AGRI
#21.46474 38.055834 9 0 1 RB RLSO
#21.35537 37.79594 9 0 1 RB AMAL
EOF

# ######---------plot labels--------#############
# psxy <<END -Jm $range -Sr -W0.15p,black -Gwhite -K -V -O>>$outfile
# 20.34 37.945 4.1 1.8
# END
# 
# psxy <<EOF -Jm -O -R -St0.3c -Gblue -K >> $outfile
# 20.25 37.96
# EOF
# 
# psxy <<EOF -Jm -O -R -Sc0.2c -Gblack -K >> $outfile
# 20.25 37.93
# EOF
# 
# pstext <<EOF -Jm -R -Dj0.1c/0.1c -G0/0/0 -O -V >> $outfile
# 20.26 37.96 9 0 1 LM cGPS stations 
# 20.26 37.93 9 0 1 LM campaign sites
# EOF


# psvelo <<EOF -Jm $range -Se50/0.95/0 -W0.15p,black -G205/133/63  -A0.07/0.20/0.12 -V -O -K>> $outfile  # 205/133/63
# 20.5886441 38.1768271 -0.018 -0.008 0 0 0 vlsm
# 20.43816 38.19571 0.029 -0.056 0 0 0 kefa
# 20.28 37.96 0.02 0 0 0 0 
# EOF

# psvelo <<EOF -Jm $range -Se50/0.95/0 -W0.15p,black -Gred  -A0.07/0.20/0.12 -V -O -K -X1.45c -Y-2.8c>> $outfile  # 205/133/63
# #20.5886441 38.1768271 -0.010 -0.009 0 0 0 vlsm
# 20.43816 38.19571 0.031 -0.091 0 0 0 kefa
# #20.28 37.96 0.02 0 0 0 0 
# EOF
# 


#### plot total displacement
# awk '{print $2,$3,$5/1000,$7/1000,$6,$8,0,$1}' kefallonia.vel | psvelo -Jm $range -Se0.0000005/0.95/0 -W0.15p,black -Gred -L -A0.07/0.20/0.12 -V -O -K>> $outfile  # 205/133/63
# psvelo <<EOF -Jm $range -Se40/0.95/0 -W0.15p,black -Gred -A0.07/0.20/0.12 -V -O -K>> $outfile  # 205/133/63
# 20.5886441 38.1768271 -0.028 -0.017 0 0 0 vlsm
# 20.43816 38.19571 0.060 -0.147 0 0 0 kefa
# 20.34835 38.20318 -0.010 0.07 0 0 0 kipo
# 20.28 37.96 0.02 0 0 0 0  askm
# EOF
# 
# pstext <<EOF -Jm -R -Dj0.1c/0.1c -G0/0/0 -O -V -K >> $outfile   #-X-1.45c -Y2.8c
# 20.28 37.96 9 0 1 RM 2 cm
# EOF
# # 
# psvelo <<EOF -Jm $range -Se50/0.95/0 -W0.15p,black -Gred  -A0.07/0.20/0.12 -V -O -K -X-0.9c -Y-0.4c>> $outfile  # 205/133/63
# 20.5886441 38.1768271 -0.010 -0.009 0 0 0 vlsm
# #20.43816 38.19571 0.031 -0.091 0 0 0 kefa
# #20.28 37.96 0.02 0 0 0 0 
# EOF



#PLOT STRAIN

# psvelo <<END -Jm $range -Sx1 -L -A0.07/0.20/0.12 -W0.8p,blue -V  -K -O>> $outfile
# 20.53726 38.33053 0 -4.595 115.479
# #20.85996 38.47371 0 -0.137 127.506
# #21.15337 38.28605 0 -0.004 260.304
# #21.13678 38.01021 0 -0.025 91.780
# 20.3 38.03 0 -1 0
# END
# 
# psvelo <<END -Jm $range -Sx1 -L -A0.07/0.20/0.12 -W0.8p,red -V  -K -O>> $outfile
# 20.53726 38.33053 1.034 0 115.479
# #20.85996 38.47371 0.259 0 127.506
# #21.15337 38.28605 0.254 0 260.304
# #21.13678 38.01021 0.227 0 91.780
# 20.3 38.03 1 0 0
# END
# 
# pstext <<EOF -Jm -R -Dj0.1c/0.1c -G0/0/0 -O -V -K >> $outfile
# 20.3 38.085 9 0 1 CB 1000 nstrains 
# EOF

### PLOT ROTATION
# psvelo <<END -Jm $range -Sw2/1.e3 -Gred -E0/0/0/10 -L -A0.05/0/0  -V -K -O>> $outfile
# 20.53726 38.33053 -0.001697 0.000
# END
#################--- Plot DSO logo ----##########################################
psimage $pth2logo/DSOlogo1.eps -O -C0.15c/-16c -W2.9c -F2 >>$outfile

#################--- Convert to jpg format ----##########################################
gs -sDEVICE=jpeg -dJPEGQ=100 -dNOPAUSE -dBATCH -dSAFER -r300 -sOutputFile=$out_jpg $outfile

	
################--- Convert to gif format ----##########################################
# ps2raster -E$dpi -Tt $map.ps
# convert -delay 180 -loop 0 *.tif IonMap$date.gif

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
