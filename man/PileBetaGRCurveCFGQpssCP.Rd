\name{CurveCFGQpssCP}
\alias{CurveCFGQpssCP}
\title{
	Load displacement data for each test at the site CP by Wu and Xin 2019
}
\description{
	Data sets covers the load displacement data of each curve
}
\usage{
	CurveCFGQpssCP(Q1, s1)
}
\arguments{
  \item{Q1}{
	a load parameter
}
  \item{s1}{
	a displacement parameter
}
}
\details{
	The data set contains several columns : Q1[1], s1[1], Q2[2], s2[2], Q3[3], s3[3], Q4[4], s4[4],...
}
\value{
	Returns a matrix that contains above values for each sites under different load levels included in the data set.
}
\references{
	
	[1] Wu XZ, Xin JX. 2019. Probabilistic analysis of site-specific load-displacement behaviour of cement-fly ash-gravel piles. Soils and Foundations, 59(5):1613-1630.

}
\note{

	Please read the following references for the original data (adopted from):

	[1] Wu XZ, Xin JX. 2021. Geometric reliability analysis ofcomposite foundations comprising cement-fly ash-gravel piles at site-specific scale. Journal of Testing and Evaluation, 49(4):2779-2799.
}
\seealso{

	[1] Wu X.Z., Liu H. 2023. Development of environmental contours from site-specific regression parameters of load-settlement curves for piles: the global database. International Journal of Geomechanics, 23(9):04023148.

	[2] Wu XZ, Liu H, Wang RK. 2023. Determination of geometric reliability index of piles at site-specific scale: case studies. Proceedings of the Institution of Civil Engineers: Geotechnical Engineering, 176(2):118-131.
	
}
\author{
Xingzheng Wu \email{xingzhengwu@gmail.com}

}
\examples{
	##---- Should be DIRECTLY executable !! ----
	##--	listing data.
	data(CurveCFGQpssCP)
	CurveCFGQpssCP[,1:2]   ##listing a matrix for the first curve where the Q1, s1
	CurveCFGQpssCP[3,] 	  ##listing a matrix for curves where the 3th load level
}
\keyword{CFG}
\keyword{Load}
\keyword{Settlement}
