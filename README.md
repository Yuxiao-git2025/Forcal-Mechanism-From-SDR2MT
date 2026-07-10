# Forcal-Mechanism-From-SDR2MT
Continued the calculation and ·decomposition of moment tensors` based on the previous repository <br>
-----
Vavryčuk (2015) discusses the decomposition of a general seismic moment tensor into three elementary components: the isotropic component (ISO), the double-couple component (DC), and the compensated linear vector dipole component (CLVD). This decomposition is mainly used to classify seismic source types and to provide a physical interpretation of non-double-couple mechanisms.

The moment tensor can be written schematically as


\[
\mathbf{M}
=
\mathbf{M}_{ISO}
+
\mathbf{M}_{DC}
+
\mathbf{M}_{CLVD}.
\]


In normalized form, the relative scale factors are usually denoted as


\[
C_{ISO}, \qquad C_{DC}, \qquad C_{CLVD},
\]


where


\[
|C_{ISO}|+|C_{CLVD}|+C_{DC}=1.
\]


Here, \(C_{DC}\) is non-negative and ranges from 0 to 1, while \(C_{ISO}\) and \(C_{CLVD}\) may be positive or negative.

\subsection{Isotropic Component: ISO}

The isotropic component represents a purely volumetric source. It corresponds to an equal expansion or contraction in all directions.

A positive isotropic component,


\[
C_{ISO}>0,
\]


is associated with an explosive or opening-type source. Physically, this means that the source volume increases. Typical examples include explosions or tensile crack opening.

A negative isotropic component,


\[
C_{ISO}<0,
\]


corresponds to an implosive or closing-type source. This means that the source volume decreases. Examples may include cavity collapse, compaction, or compressive crack closure.

A pure isotropic source is characterized by


\[
C_{ISO}=\pm 1, \qquad C_{DC}=0, \qquad C_{CLVD}=0.
\]


Therefore, in the source-type plot, pure explosions and implosions occupy the top and bottom vertices of the diamond plot, respectively 

* Refer to: <br>
|| Vavryčuk, V., 2015a. Moment tensor decompositions revisited, Journal of Seismology, 19(1), 231-252, doi: 10.1007/s10950-014-9463-y. <br>
<img width="1350" height="900" alt="Fig1" src="https://github.com/user-attachments/assets/26e0f821-7a7e-4ded-bf4b-476e1a74d0d4" />
<img width="1050" height="1020" alt="Fig2" src="https://github.com/user-attachments/assets/364f6980-dd9d-47dc-9b8b-69899351b8ce" />
