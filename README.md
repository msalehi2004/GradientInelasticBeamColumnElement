# Gradient Inelastic Beam-Column Element

This is a repository for the source codes associated with the implementation of the force/flexibility-based (FB) gradient inelastic (GI) element formulation in OpenSees.

The GI element formulation is based on the GI beam theory, which eliminates the strain localization and response objectivity problems by utilizing a set of gradient-based nonlocality relations that ensure the continuity of section strains (e.g., curvature) over the element length, upon the occurrence of softening at any section. The GI element does not necessitate any certain form of constitutive relations and permits users to use the same constitutive relations used in conventional FB element formulations. Moreover, the number of integration points in the GI element is not fixed and it could produce section strain (e.g., curvature) distributions with high resolutions.

From the user’s perspective, the gradientInelasticBeamColumn element has similar input to other force-based fiber elements’ and the only additional parameter that this element requires is a characteristic length, lc, which controls the spread of plasticity/damage in the vicinity of a softening location. In the simulation of RC beams/columns, this parameter can be taken equal to the plastic hinge length. If lc equals zero, the GI beam element formulation turns into a conventional FB element formulation (i.e., as if the classical beam theory is used).

For more information about the GI element formulation and its command description, please refer to the PDF file available in the repository and the references at the end of this page.

## Authors

Codes written and maintained by Mohammad Salehi (mohammad.salehi@rice.edu) and Petros Sideris (petros.sideris@tamu.edu).

