#####################################################################################################
# ------------------------------------------------------------------------------------------------- #
#                                         Model's Parameters                                        #
# ------------------------------------------------------------------------------------------------- #
#####################################################################################################

## Gradient Inelastic Element Application Example
## RC Column Specimen 7 Tested by Tanaka (1990)
## By: Mohammad Salehi (Rice University) and Petros Sideris (Texas A&M University)
## April 2021

## Units: kip, in, sec

#####################################################################################################
## Dimensions ####################################################################
###############################################################

    set eleL    96.		;# column height
	set plHL    15.		;# plastic hinge length
	set IPNo	10		;# number of integration points

## Cross Section:

    set secR    12.		;# section radius
    set cover   0.5		;# concrete cover
    set rbrNo   16		;# number of longitudinal rebars
    set rbrA    0.44	;# longitudinal rebar area
    set rbrD    0.75	;# longitudinal rebar diameter
    set sprD    0.375	;# spiral rebar diameter

#####################################################################################################
## Materials #####################################################################
###############################################################

## Concrete:
 
    set fpc   6.8
    set epsc0 0.002
    set fpcu  0.
    set epsu  0.005
	
	set	K		1.3
    set fpcc    [expr $K*$fpc]
    set epscc   [expr (1.+5.*($K-1.))*$epsc0]
    set fpccu   [expr 1.74+$fpc*($K-1.)]
    set epscu   [expr 5.0*$epscc]
    
    set Ec    4700.

## Steel:

    set Es  29000.
    set fy  72.
    set bs  0.015
	
#####################################################################################################
## Nodal Forces ##################################################################
###############################################################

    set topF -170.		;# vertical load

#####################################################################################################
## Analysis Parameters ###########################################################
###############################################################

set impsdDisp       ../cyclic.txt
set Scale           2.;
set timeStep        0.1
set duration        [expr 0.05*25025.]
set dt              0.1