use "$path/data/datasets/100 Data for Estimation", clear


egen i_id=group(business_id)

xtset i_id t_id

reghdfe tot_mkt_review L.G_review L.B_review, absorb(t_id i_id) cluster(i_id)

asdf



collapse H tot_review, by(market_id t_id)








su market_id
local n=r(max)




gen bG=.
gen bB=.
gen seG=.
gen seB=.
gen Htrend=.
forval i=1/`n' {
 cap reghdfe tot_review L.G_review L.G_review2 L.B_review c.L.B_review2 if market_id==`i', absorb(t_id)
	cap replace bG=_b[L.G_review2]   if market_id==`i'
	cap replace seG=_se[L.G_review2] if market_id==`i'
	cap replace bB=_b[L.B_review2]   if market_id==`i'
	cap replace seB=_se[L.B_review2] if market_id==`i'
	cap reghdfe H t_id market_id==`i'
	cap replace Htrend=_b[t_id] if market_id==`i'
}

replace bG=. if seG==0
replace seG=. if seG==.
replace bB=. if seB==0
replace seB=0

twoway scatter bG Htrend, mcol(blue) || scatter bG Htrend if abs(bG)-1.96*seG > 0 & bG !=. & Htrend != ., mcol(red)
	