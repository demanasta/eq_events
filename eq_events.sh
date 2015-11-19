#!/bin/bash
#plot network forseismo platform
# //////////////////////////////////////////////////////////////////////////////
# HELP FUNCTION
function help {
echo "
/******************************************************************************/
Program Name : cGNSSnets.sh
Version : v-1.0
Purpose : Plot cGNSS network stations
Usage   : cGNSSnets.sh -r region |  | -o [output] | -jpg
Switches:
	-r [:= region] regparam file
	-mt [:= map title] title map default none use quotes
	-fm [:=focal mechanism parameters] fmparam file
	-gsites [:=] plot gps sites
	-gdisp [:=] plot gps displacements
	-gvel [:=] plot gps velocities

/*** NETWORKS  PLOTS **********************************************************/

/*** OTHER OPRTIONS ************************************************************/
	-topo [:=topography] use dem for background
	-o [:= output] name of output files
	-l [:=labels] plot labels
	-leg [:=legend] insert legends
	-jpg : convert eps file to jpg
	-h [:= help] help menu
	Exit Status:    1 -> help message or error
	Exit Status:    0 -> sucesseful exit
run:./eq_events.sh -r regparam -fm fmparam -topo -jpg -gsites gps.sites -gdisp gps.disp
/******************************************************************************/"
exit 1
}

# //////////////////////////////////////////////////////////////////////////////
# GMT parameters
gmtset MAP_FRAME_TYPE fancy
gmtset PS_PAGE_ORIENTATION portrait
gmtset FONT_ANNOT_PRIMARY 10 FONT_LABEL 10 MAP_FRAME_WIDTH 0.12c FONT_TITLE 18p
# gmtset PS_MEDIA 29cx21c

# //////////////////////////////////////////////////////////////////////////////
# Pre-defined parameters for bash script
TOPOGRAPHY=0
LABELS=0
OUTJPG=0
LEGEND=0
FMPLOT=0
GSITES=0
GDISP=0
GVEL=0

FGNSS=0
DBGNSS=0

if [ ! -f "gmtparam" ]
then
	echo "gmtparam file does not exist"
	exit 1
else
	source gmtparam
fi



# //////////////////////////////////////////////////////////////////////////////
# GET COMMAND LINE ARGUMENTS
if [ "$#" == "0" ]
then
	help
fi

while [ $# -gt 0 ]
do
	case "$1" in
		-r)
			if [ ! -f $2 ]
			then
				echo "regparam file does not exist"
				exit 1
			else
				source $2
			fi
			shift
			shift
			;;
		-mt)
			maptitle=$2
			shift
			shift
			;;
		-fm)
			if [ ! -f $2 ]
			then
				echo "fmparam file does not exist"
				exit 1
			else
				FMPLOT=1
				fmplot=$2
			fi
			shift
			shift
			;;
		-gsites)
			if [ ! -f $2 ]
			then
				echo "gps sites file does not exist"
				exit 1
			else
				GSITES=1
				gsites=$2
			fi
			shift
			shift
			;;
		-gdisp)
			if [ ! -f $2 ]
			then
				echo "gps displacement file does not exist"
				exit 1
			else
				GDISP=1
				gdisp=$2
			fi
			shift
			shift
			;;
		-gvel)
			if [ ! -f $2 ]
			then
				echo "gps velocity file does not exist"
				exit 1
			else
				GVEL=1
				gvel=$2
			fi
			shift
			shift
			;;
		-fgnss)
			FGNSS=1
			shift
			;;
		-dbgnss)
			DBGNSS=1
			shift
			;;

		-topo)
#                       switch topo not used in server!
			TOPOGRAPHY=1
			shift
			;;
		-o)
			outfile=${2}.eps
			out_jpg=${2}.jpg
			shift
			shift
			;;
		-l)
			LABELS=1
			shift
			;;
		-leg)
			LEGEND=1
			shift
			;;
		-jpg)
			OUTJPG=1
			shift
			;;
		-h)
			help
			;;
	esac
done


# ####################### TOPOGRAPHY ###########################
if [ "$TOPOGRAPHY" -eq 0 ]
then
	################## Plot coastlines only ######################
	pscoast $range $proj -B$frame:."$maptitle": -Df -W0.5/0/0/0 -G195  -U$logo_pos -K -X1.8c -Y1.4c> $outfile
	psbasemap -R -J -O -K --FONT_ANNOT_PRIMARY=10p $scale --FONT_LABEL=10p >> $outfile
fi
if [ "$TOPOGRAPHY" -eq 1 ]
then
	# ####################### TOPOGRAPHY ###########################
	# bathymetry
	makecpt -Cgebco.cpt -T-5000/100/150 -Z > $bathcpt
	grdimage $inputTopoB $range $proj -C$bathcpt -K -X1.8c -Y1.4c > $outfile
	pscoast $proj -P $range -Df -Gc -K -O >> $outfile
	# land
	makecpt -Cgray.cpt -T-5000/1800/50 -Z > $landcpt
	grdimage $inputTopoL $range $proj -C$landcpt  -K -O >> $outfile
	pscoast -R -J -O -K -Q >> $outfile
	#------- coastline -------------------------------------------
	psbasemap -R -J -O -K --FONT_ANNOT_PRIMARY=10p $scale --FONT_LABEL=10p >> $outfile
	pscoast -Jm -R -B$frame:."$maptitle": -Df -W.2,black -K  -O -U$logo_pos >> $outfile
fi

# start create legend file .legend
echo "G 0.2c" > .legend
echo "H 9 Times-Roman $maptitle" >> .legend
echo "D 0.3c 1p" >> .legend
echo "N 1" >> .legend

# ///////////////// PLOT FOCAL MECHANISMS //////////////////////////////////
if [ "$FMPLOT" -eq 1 ]
then
	grep -v "#" $fmplot | psmeca $range -Jm -Sc0.9/0 -CP0.025 -K -O -P >> $outfile
	grep -v "#" $fmplot | awk '{print $1, $2}' | psxy -Jm -O -R -Sa0.4c -Gred -K >> $outfile
fi

# ///////////////// PLOT GPS STATIONS //////////////////////////////////
if [ "$GSITES" -eq 1 ]
then

	grep -v "#" $gsites | awk '{print $1, $2}' | psxy -Jm -O -R -St0.32c -Gblack -K >> $outfile
	grep -v "#" $gsites | pstext -Jm -R -Dj0.2c/0.2c -Gwhite -O -V -K >> $outfile
fi

# ///////////////// PLOT GPS DISPLACEMENTS //////////////////////////////////
if [ "$GDISP" -eq 1 ]
then

	grep -v "#" $gdisp | psvelo -R -Jm -Se20/0.95/0 -W2p,red -A10p+e -Gred -O -K -L -V >> $outfile
 	grep  "#scale" $gdisp | awk '{print $2,$3,$4,$5,$6,$7,$8,$9,$10}'|psvelo -R -Jm -Se20/0.95/12 -W2p,red -A10p+e -Gred -O -K -L -V >> $outfile
fi

# ///////////////// PLOT GPS VELOCITIES //////////////////////////////////
if [ "$GVEL" -eq 1 ]
then

	grep -v "#" $gvel | psvelo -R -Jm -Se100/0.95/0 -W2p,blue -A10p+e -Gred -O -K -L -V >> $outfile
# 	grep -v "#" $ | pstext -Jm -R -Dj0.2c/0.2c -Gwhite -O -V -K >> $outfile
fi

echo "G 0.2c" >> .legend
echo "D 0.3c 1p" >> .legend

# ///////////////// PLOT LEGEND //////////////////////////////////
if [ "$LEGEND" -eq 1 ]
then
        pslegend .legend ${legendc} -C0.1c/0.1c -L1.1 -O -K >> $outfile
fi

#/////////////////FINESH SCRIPT
psimage $pth2logos/DSOlogo2.eps -O $logo_pos2 -W1.1c -F0.4 >>$outfile

#################--- Convert to jpg format ----##########################################
if [ "$OUTJPG" -eq 1 ]
then
	gs -sDEVICE=jpeg -dJPEGQ=100 -dNOPAUSE -dBATCH -dSAFER -r300 -sOutputFile=$out_jpg $outfile
fi

#rm tmp-*
rm .legend
rm *cpt

echo $?
