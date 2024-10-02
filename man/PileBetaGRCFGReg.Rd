\name{CFGRegPars}
\alias{CFGRegParsSF}
\title{
	Regression parameters for the load versus settlement curves of the CFG pile
}
\description{
	Data sets covers the regression parameters via hyperbolic and power law
}
\usage{
	CFGRegPars(h1, h2)
	CFGRegPars(p1, p2)
}
\arguments{
  \item{h1}{
	a hyperbolic regression parameter
}
  \item{h2}{
	a hyperbolic regression parameter
}
  \item{p1}{
	a power law regression parameter
}
  \item{p2}{
	a power law regression parameter
}
}
\details{
	The data set contains several columns : no, diameter, length, Qmax, Smax, Kur, p1, p2, h1, h2.
}
\value{
	Returns a matrix that contains above values for each sites included in the data set.
}
\references{
	
	[1] Wu XZ. 2017. Implementing multivariate fitting and reliability analyses for geotechnical engineering problems in R. Georisk, 11(2):173-188.

}
\note{

	Please read the following references for the original data (adopted from):

	[1] Wu XZ, Xin JX. 2019. Probabilistic analysis of site-specific load-displacement behaviour of cement-fly ash-gravel piles. Soils and Foundations, 59(5):1613-1630.
  
}
\seealso{

	Wu XZ, Xin JX. 2021. Geometric reliability analysis ofcomposite foundations comprising cement-fly ash-gravel piles at site-specific scale. Journal of Testing and Evaluation, 49(4):277-2799.
}
\author{
Xingzheng Wu \email{xingzhengwu@gmail.com}

}
\examples{
	##---- Should be DIRECTLY executable !! ----
	##--	listing data.
	data(CFGRegPars)
	CFGRegPars[["name"]]  ##column named "name"

	which(CFGRegPars[["name"]]=="TZCFG")  ##returns a vector of the indices of x 
	which(CFGRegPars[["type"]]=="CP")  ##returns a vector of the indices of x at a site 
	CFGRegPars[which(CFGRegPars[["type"]]=="CP"),]   ##listing a matrix where the site = 'CP'
	CFGRegPars[which(CFGRegPars[["type"]]=="CP"),7:8]  
		##listing a matrix where the p1-p2 parameters at site = 'CP'
	CFGRegPars[which(CFGRegPars[["type"]]=="CP"),9:10]   
		##listing a matrix where the h1-h2 parameters at site = 'CP'
}
\keyword{CFG}
\keyword{Regression}
\keyword{p1p2}
