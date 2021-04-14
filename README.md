# Gradient Inelastic Beam-Column Element

This is a repository for the source codes associated with the implementation of the force/flexibility-based (FB) gradient inelastic (GI) element formulation in [OpenSees](https://github.com/OpenSees/OpenSees).

The GI element formulation is based on the GI beam theory, which eliminates the strain localization and response objectivity problems by utilizing a set of gradient-based nonlocality relations that ensure the continuity of section strains (e.g., curvature) over the element length, upon the occurrence of softening at any section. The GI element does not necessitate any certain form of constitutive relations and permits users to use the same constitutive relations used in conventional FB element formulations. Moreover, the number of integration points in the GI element is not fixed and it could produce section strain (e.g., curvature) distributions with high resolutions.

From the user’s perspective, the gradientInelasticBeamColumn element has similar input to other force-based fiber elements’ and the only additional parameter that this element requires is a characteristic length, lc, which controls the spread of plasticity/damage in the vicinity of a softening location. In the simulation of RC beams/columns, this parameter can be taken equal to the plastic hinge length. If lc equals zero, the GI beam element formulation turns into a conventional FB element formulation (i.e., as if the classical beam theory is used).

For more information about the GI element formulation and its command description, please refer to [here](https://github.com/msalehi2004/GradientInelasticBeamColumnElement/blob/f9927f9117ace074629a7ff1409f4265e5551cc0/GI%20Element%20in%20OpenSees.pdf) and the references at the end of this page.

## Authors

Codes written and maintained by [Mohammad Salehi](https://resilient-structures.com/) (Rice University) and [Petros Sideris](https://sites.google.com/view/petros-sideris-sem-group/) (Texas A&M University).

## References

*Sideris, P., Salehi, M. (2016). "A Gradient-Inelastic Flexibility-based Frame Element Formulation." Journal of Engineering Mechanics, 142(7): 04016039.

*Salehi, M., Sideris, P. (2017). "Refined Gradient Inelastic Flexibility-Based Formulation for Members Subjected to Arbitrary Loading." Journal of Engineering Mechanics, 143(9): 04017090.

*Salehi, M., Sideris, P., Liel, A.B. (2017). "Seismic Collapse Analysis of RC Framed Structures using the Gradient Inelastic Force-Based Element Formulation." 16th World Conference on Earthquake Engineering (16WCEE), Santiago Chile, January 9-13.

*Salehi, M., Sideris, P., Liel, A.B. (2020). "Assessing Damage and Collapse Capacity of Reinforced Concrete Structures Using the Gradient Inelastic Beam Element Formulation." Engineering Structures, 225: 111290.
