*insheet using "$path/data/datasets/business_ratings_month.csv", clear
insheet using "$path/data/datasets/restaurantbiz_month.csv", clear

rename _star star1
rename v13 star2
rename v14 star3
rename v15 star4
rename v16 star5
rename city_label city_id

gen city_name=""
replace city_name="Philadelphia" if city_id==1
replace city_name="Santa Barbara" if city_id==2
replace city_name="Edmonton" if city_id==3
replace city_name="Tucson" if city_id==4
replace city_name="Tampa" if city_id==5
replace city_name="Nashville" if city_id==6
replace city_name="New Orleans" if city_id==7
replace city_name="Indianapolis" if city_id==8
replace city_name="Boise" if city_id==9
replace city_name="Reno" if city_id==10
replace city_name="St. Louis" if city_id==11

gen tot_review=star1+star2+star3+star4+star5

gen t_id=(year-2005)*12+month
egen cat_id=group(primary_category)
egen market_id=group(cat_id city_id)

egen tot_mkt_review=total(tot_review), by(market_id t_id)
gen mkt_share=tot_review/tot_mkt_review
egen H=total(mkt_share^2), by(market_id t_id)

gen G_review=star4+star5
gen B_review=star1+star2

gen G_review2=G_review^2
gen B_review2=B_review^2

save "$path/data/datasets/100 Data for Estimation", replace