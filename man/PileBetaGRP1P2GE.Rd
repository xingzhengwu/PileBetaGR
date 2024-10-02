\name{P1P2GERegPars}
\alias{P1P2GERegPars}
\title{
	Regression parameters for the load versus settlement curves by Park et al. (2012), Park et al. (2012), and Zhou et al. (2019)
}
\description{
	Data sets covers the regression parameters via power law
}
\usage{
	P1P2GERegPars(p1, p2)
}
\arguments{
  \item{p1}{
	a power law regression parameter
}
  \item{p2}{
	a power law regression parameter
}
}
\details{
	The data set contains twelve columns : Investigator, location, site, type, no, length, diameter, slenderness, p1, p2, Qmax, ID.
}
\value{
	Returns a matrix that contains above values for each sites included in the data set.
}
\references{
	
	[1] Wu XZ. 2017. Implementing multivariate fitting and reliability analyses for geotechnical engineering problems in R. Georisk, 11(2):173-188.

	[2] Park S, Roberts LA and Misra A (2012) Design methodology for axially loaded auger cast-in-place and drilled displacement piles. Journal of Geotechnical and Geoenvironmental Engineering ASCE 
		138(12): 1431-1441.

	[3] Prakoso WA (2016) Case studies on variability in soils and driven pile performance. In Proceedings of the 5th International Conference on Geotechnical and Geophysical Site Characterisation 
		(Lehane BM, Acosta-Martinez HE and Kelly R (eds)). Australian Geomechanics Society, St Ives, NSW, Australia, pp. 1259-1264.

        [4] Zhou J, Zhang L, Zhang X, Jiang H and Oh E (2019) Behavior of displacement concrete pile under compressive loads. International Journal of Geomate 16(54): 200-208.
}
\note{

	Please read the following references for the original data (adopted from):

	[1] Wu XZ, Liu H, Wang RK. 2023. Determination of geometric reliabilityindex of piles at site-specific scale: case studies. Proceedings of the Institution of Civil Engineers: Geotechnical Engineering. 
		176(2):118-131.
  
}
\seealso{

	[1] Wu XZ, Xin JX. 2021. Geometric reliability analysis ofcomposite foundations comprising cement-fly ash-gravel piles atsite-specific scale. Journal of Testing and Evaluation, 49(4):2779-2799.
	
	[2] Wu XZ, Xin JX. 2019. Probabilistic analysis of site-specific load-displacement behaviour of cement-fly ash-gravel piles. Soils and Foundations, 59(5):1613-1630.
}
\author{
Xingzheng Wu \email{xingzhengwu@gmail.com}

}
\examples{
	##---- Should be DIRECTLY executable !! ----
	##--	listing data.
	data(P1P2GERegPars)
	P1P2GERegPars[["name"]]  ##column named "name"

	which(P1P2GERegPars[["location"]]=="Kansas" & P1P2GERegPars[["site"]]=="Northern")  
		##returns a vector of the indices of x 
	which(P1P2GERegPars[["location"]]=="Shandong" & P1P2GERegPars[["type"]]=="ZoneC")  
		##returns a vector of the indices of x at a site 
	P1P2GERegPars[which(P1P2GERegPars[["type"]]=="pp"),]   
		##listing a matrix where the site is 'pp'
	P1P2GERegPars[which(P1P2GERegPars[["type"]]=="pp"),9:10]   
		##listing a matrix where the p1 p2 parameters at site is 'pp'
}
\keyword{Pile}
\keyword{Regression}
\keyword{p1p2}
