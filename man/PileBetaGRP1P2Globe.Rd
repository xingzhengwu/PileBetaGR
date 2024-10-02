\name{P1P2GlobeRegPars}
\alias{P1P2GlobeRegPars}
\title{
	Regression parameters for the load versus settlement curves all site across the globe
}
\description{
	Data sets covers the regression parameters via power law
}
\usage{
	P1P2GlobeRegPars(p1, p2)
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

	[2] Brandl H. 2005. Cyclic preloading of piles to minimize differential settlements of high-rise buildings. Slovak Journal of Civil Engineering (eingeladen), XIII(3):1-12.

	[3] Bueno Aguado M, Escolano F, Sanz E. 2021. Model uncertainty for settlement prediction on axially loaded piles in hydraulic fill built in marine environment. Journal of Marine Science and Engineering, 9, 63:1-17.

	[4] Evangelista A, Pellegrino A, Viggiani C. 1977. Variability among piles of the same foundation. IX Int. Conf. Soil Mech. Found. Eng, 493-500.

	[5] Hebei Huayu Engineering Testing Co., Ltd. (HHET) 2018. Testing for prestressed high-strength concrete pipe piles in Hebei Hongyu Tianxi garden. 

	[6] Hebei Huayu Engineering Testing Co., Ltd. (HHET) 2019. Testing for prestressed concrete pipe piles in Hebei Hongyu Jiuxitai residential community.

	[7] Hebei Huayu Engineering Testing Co., Ltd. (HHET) 2020. Testing for cement fly-ash gravel (CFG) piles in Hebei Hongyu Ziyuntai residential community.

	[8] Hebei Jicang Construction Technology Co., Ltd. (HJCT) 2018. Testing for piles in Hebei Hongyu Longxiyuan residential community.

	[9] Hebei Jicang Construction Technology Co., Ltd. (HJCT) 2019. Testing for foundation piles in the workshop of Hebei high-end equipment manufacturing hub.

	[10] Karlsrud (2013): Summary and evaluation of pile test results. NGI Report: Time effects on pile capacity. Doi: 20061251-00-279-R
	
	[11] Lu S, Zhang J, Xu H, Zhang Y. 2019. Test and research for key technology of cast-in-place pile construction in the area of silt-rock fill layer. International Journal of Mechatronics, 1(6):203-212. 
	
	[12] Mahakhotchasenichai K, Phien-wej N, Chao KC, Boonyarak T. 2018. Evaluation of a pile design method using the results of static load tests for a double track railway project. 
		The 23rd National Convention on Civil Engineering, 1-12.
	
	[13] Sun HW, Chang WH, Gong ZC, Wang Y. 2014. Calculation and analysis of piled raft foundation interaction of China ZUN Tower. Building Structure, 44(20):109-114. (in Chinese)
	
	[14] Tawfik MM, Loschner J, El-Mossallamy YM. Characteristic estimate of pile bearing capacity from pile load tests on socketed drilled shafts in weathered rock. International Journal of 
		Geotechnical Engineering, 2015, 9(2):201-208. 
}
\note{

	Please read the following references for the original data (adopted from):

	[1] Wu XZ, Liu H, Wang RK. 2023. Determination of geometric reliability index of piles at site-specific scale: case studies. Proceedings of the Institution of Civil Engineers: 
		Geotechnical Engineering. 176(2):118-131.
  
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
	data(P1P2GlobeRegPars)
	P1P2GlobeRegPars[["name"]]  ##column named "name"

	which(P1P2GlobeRegPars[["location"]]=="Vienna" & P1P2GlobeRegPars[["site"]]=="P01")  
		##returns a vector of the indices of x 
	which(P1P2GlobeRegPars[["location"]]=="Hejian" & P1P2GlobeRegPars[["type"]]=="PHC")  
		##returns a vector of the indices of x at a site 
	P1P2GlobeRegPars[which(P1P2GlobeRegPars[["type"]]=="DShaft"),]   
		##listing a matrix where the site is 'DShaft'
	P1P2GlobeRegPars[which(P1P2GlobeRegPars[["type"]]=="DShaft"),9:10]   
		##listing a matrix where the p1 p2 parameters at site is 'DShaft'
}
\keyword{Pile}
\keyword{Regression}
\keyword{p1p2}
