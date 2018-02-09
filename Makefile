temp-folder = /tmp/jekyll-temp-site/
repo = git@git.coding.net:iziy/iziy.git


s: 
	jekyll server
build:
	jekyll build -d ${temp-folder}

deploy: build
	cd ${temp-folder} ;\
	git init ${temp-folder} ;\
	git checkout -b coding-pages ;\
	git remote add origin ${repo} ;\
	git add -A ${temp-folder} ;\
	git commit -m "deployed by make" ;\
	git push origin coding-pages --force
	
push:
	git add -A
	git commit -m "pushed by make"
	git push


clean:
	rm -rf ${temp-folder}

