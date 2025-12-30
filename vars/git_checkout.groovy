def call(String url1 , String b){
	println"Check the Git repository"
	git url: "$url1", branch: "$b"
	println"Success !!!!"
}  
