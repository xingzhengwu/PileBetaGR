\name{P1P2MihalikRegPars}
\alias{P1P2MihalikRegPars}
\title{
	Regression parameters for the load versus settlement curves by Mihalik et al. (2023)
}
\description{
	Data sets covers the regression parameters via power law
}
\usage{
	P1P2MihalikRegPars(p1, p2)
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
	
	[1] Mihalik J, Gago F,  Vlcek J,  Drusa M. Evaluation of methods based on CPTu testing for prediction of the bearing capacity of CFA piles. Applied Sciences, 2023, 13, 2931.

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
	data(P1P2MihalikRegPars)
	P1P2MihalikRegPars[["name"]]  ##column named "name"

which(P1P2MihalikRegPars[["location"]]=="Slovakia" & P1P2MihalikRegPars[["site"]]=="Bridge15")  
		##returns a vector of the indices of x 
	P1P2MihalikRegPars[which(P1P2MihalikRegPars[["type"]]=="CFA"),]   
		##listing a matrix where the site is 'pp'
}
\keyword{Pile}
\keyword{Regression}
\keyword{p1p2}
