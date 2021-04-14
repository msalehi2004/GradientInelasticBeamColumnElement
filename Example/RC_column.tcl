#####################################################################################################
# ------------------------------------------------------------------------------------------------- #
#                                       Cantilever Column Model                                     #
# ------------------------------------------------------------------------------------------------- #
#####################################################################################################

## Gradient Inelastic Element Application Example
## RC Column Specimen 7 Tested by Tanaka (1990)
## By: Mohammad Salehi (Rice University) and Petros Sideris (Texas A&M University)
## April 2021

#####################################################################################################
## Set Up & Sourcing #############################################################
###############################################################

wipe
model basic -ndm 2 -ndf 3

## Sourcing

source ../Parameters.tcl

## Definition of The Folders Containing Results

file mkdir ../Results/Nodes
file mkdir ../Results/Sections
file mkdir ../Results/Element

#####################################################################################################
## Nodes' Definition #############################################################
###############################################################

## Tags:
    
    set base    1
    set colTop  3
	set loadPnt 4

## Definition:

    # args: nodeTag  Xcoord Ycoord
    node    $base    0.     0.					-mass 0.001 0.001 0.25
    node    $colTop  0.     $eleL				-mass 0.001 0.001 0.25
	node	$loadPnt 0.     [expr $eleL+12.]	-mass 0.001 0.001 0.25
    
#####################################################################################################
## Restraints' Definition ########################################################
###############################################################

    # args: nodeTag xTrans yTrans zRotat
    fix     $base   1      1      1

#####################################################################################################
## Materials' Definition #########################################################
###############################################################

## Tags:
    
    set concC       1;      # confined
    set concUC      2;      # unconfined
    set steel       3
	set bondSlip	4
	set stiff		5

## Concrete
    
    # args:                     matTag  fpc    epsc0   fpcu    epsU
    uniaxialMaterial Concrete01 $concC  -$fpcc -$epscc -$fpccu -$epscu
    uniaxialMaterial Concrete01 $concUC -$fpc  -$epsc0 -$fpcu  -$epsu

## Steel
    
    # args:                  matTag Fy  E0  b
    uniaxialMaterial Steel02 $steel $fy $Es $bs 13. 0.85 0.2 0.0 1. 0. 1. 0.

#####################################################################################################
## Sections' Definition ##########################################################
###############################################################

## Tag:

    set sec     1

## Definition:

    section Fiber $sec {
        
        # args:    matTag  numSubdivCirc numSubdivRad yCenter zCenter intRad                       extRad                       startAng endAng
        patch circ $concC  36            6            0.      0.      [expr $secR/2.]              [expr $secR-$cover-$sprD/2.] 0.       360.      ;# core
        patch circ $concC  18            6            0.      0.      0.                           [expr $secR/2.]              0.       360.      ;# core
        patch circ $concUC 36            2            0.      0.      [expr $secR-$cover-$sprD/2.] $secR                        0.       360.
        
        # args:    matTag numFiber areaFiber yCenter zCenter radius
        layer circ $steel $rbrNo   $rbrA     0.      0.      [expr $secR-$cover-$sprD-$rbrD/2.]
    }

#####################################################################################################
## Definition of Geometric Transformations #######################################
###############################################################

## Tag:
    
    set corot   1
    
## Definition:

    # args:                 transfTag
    geomTransf Corotational $corot
	
#####################################################################################################
## Elements' Definition ##########################################################
###############################################################

# GI Element Command: gradientInelasticBeamColumn eleTag? iNode? jNode? numIntgrPts? endSecTag1? intSecTag? endSecTag2?
#                     secLR1? secLR2? lc? transfTag? <-constH> <-integration integrType?> <-iter maxIter? minTol? maxTol?>
#                     <-corControl auto/maxEpsInc? maxPhiInc?>

    set A   [expr 3.14*$secR*$secR]
    set Iz  [expr 0.25*3.14*pow($secR,4.)]
    
    # args:                             eleTag iNode jNode   numIntgrPts endSecTag1 intSecTag endSecTag2 secLR1 secLR2 lc    transfTag
    element gradientInelasticBeamColumn 1      $base $colTop $IPNo       $sec       $sec      $sec       0.01   0.01   $plHL $corot -integration NewtonCotes -iter 20 1.e-8 1.e-6 
	
	# args:                   eleTag iNode   jNode    A  E   Iz  transfTag
    element elasticBeamColumn 2      $colTop $loadPnt $A $Es $Iz $corot
    
#####################################################################################################
## Defining Recorders ############################################################
###############################################################

## Nodes:

    # args:             fileName                            nodeTag      x y r respType
    recorder Node -file ../Results/Nodes/topDisp.out  -node $colTop -dof 1 2 3 disp

## Elements:
    
    # args:                fileName                               eleTag respType
    recorder Element -file ../Results/Element/globForces.out -ele 1      globalForce
	recorder Element -file ../Results/Element/lStrains.out   -ele 1      localStrains
	recorder Element -file ../Results/Element/nlStrains.out  -ele 1      nonlocalStrains
    
    # args:                fileName                               eleTag        section respType
    recorder Element -file ../Results/Sections/secForce1.out -ele 1     section 1       force
    recorder Element -file ../Results/Sections/secDefrm1.out -ele 1     section 1       deformation
	recorder Element -file ../Results/Sections/secForce2.out -ele 1     section 2       force
    recorder Element -file ../Results/Sections/secDefrm2.out -ele 1     section 2       deformation

#####################################################################################################
## Modal Analysis ################################################################
###############################################################

    set lambdaN	[eigen 3];      # eigenvalues for first N modes
    
    puts "\nModal Analysis Results:"
    
    for {set mode 1} {$mode <= 3} {incr mode 1} {
        
        puts "$mode th mode's period is [expr 2.*3.14159/pow([lindex $lambdaN [expr $mode-1]],0.5)]"
    }
    
#####################################################################################################
## Assigning Rayleigh Damping ####################################################
###############################################################

## Coefficients:
    
    set lambdaI	[lindex $lambdaN 0];		# 1st mode's eigenvalue
    set lambdaJ	[lindex $lambdaN 1];		# 2nd mode's eigenvalue
    
    set wI	[expr pow($lambdaI,0.5)];		# Ith mode's frequency
    set wJ	[expr pow($lambdaJ,0.5)];		# Jth mode's frequency

    set a0	[expr 2.*0.05*$wI*$wJ/($wI+$wJ)]
    set a1	[expr 2.*0.05/($wI+$wJ)]

## Definition:
    
    # args:  alphaM betaK betaKinit betaKcomm
    rayleigh $a0    0.    0.        $a1
    
    puts "\nRayleigh Damping Assigned!"
    
#####################################################################################################
## Gravity Loads #################################################################
###############################################################

## Loads:

    pattern Plain 1 Linear {
        
        # args: nodeTag  Fx Fy    M
        load    $loadPnt 0. $topF 0.
    }

## Analysis:

    constraints Plain
    numberer Plain
    system BandGeneral
    test NormDispIncr 1.0e-8 100
    algorithm Newton
    integrator LoadControl 0.1
    analysis Static
    analyze 10
    loadConst -time 0.0
	
	puts "\nGravity Loads Applied!"
    
#####################################################################################################
## Dynamic Loads ################################################################
###############################################################

## Loads:
    
    timeSeries Path 1 -dt $timeStep -filePath $impsdDisp -factor $Scale
    
    pattern MultipleSupport 2 {
        
       groundMotion 1 Plain -disp 1
       imposedMotion $colTop 1 1
       
    }

## Analysis:
    
    puts "Dynamic Analysis Starts..."
    
    constraints Transformation
    numberer Plain
    system BandGeneral
    test EnergyIncr 1.0e-8 50
    algorithm Newton
    integrator  Newmark 0.5 0.25
    analysis Transient
    set OK [analyze [expr int(ceil($duration/$dt))] $dt]
    
    if {$OK != 0} {
        
        puts " "
        puts "Trying to achieve convergence ..."
        
        set controlTime [getTime]
        
        while {$controlTime < $duration} {
            
            if {$OK != 0} {
                puts " "
                puts "Trying reduction of time step dividing by 10 ..."
                
                set OK [analyze 100 [expr $dt/10.]]
            }
            
            if {$OK != 0} {
                puts " "
                puts "Trying reduction of time step dividing by 100 ..."
                
                set OK [analyze 100 [expr $dt/100.]]
            }
            
            if {$OK != 0} {
                puts " "
                puts "Trying reduction of time step dividing by 1000 ..."
                
                set OK [analyze 100 [expr $dt/1000.]]
            }
            
            if {$OK != 0} {
                puts " "
                puts "Trying Newton with Initial Tangent ..."
                
                algorithm 	Newton -initial
                set OK [analyze 100 [expr $dt/100.]]
            }
            
            if {$OK != 0} {
                puts " "
                puts "Trying Newton with Initial-then-Current Tangent ..."
                
                algorithm 	Newton -initialThenCurrent
                set OK [analyze 100 [expr $dt/100.]]
            }
            
            if {$OK != 0} {
                break
            } else {
                puts " "
                puts "Returning to Initial Features ..."
                
                test EnergyIncr 1.0e-8 50
                algorithm Newton
                set controlTime [getTime]
                set OK [analyze [expr int(ceil(($duration-$controlTime)/$dt))] $dt]
            }
            
            set controlTime [getTime]
        }
    }
    
    if {$OK == 0} {
        puts "Dynamic Analysis Done!"
        puts " "
    } else {
        puts "Oops...! No Convergence!!!"
        puts " "
    }
    
    wipe all
    puts "Dynamic Analysis Finished!"