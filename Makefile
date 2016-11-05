#export GH_USER="lucasgautheron"
#export GITHUB_TOKEN=""

all:
	php compile.php -V -B -S

clean:
	find tmp/ ! -name '.gitignore' -type f -exec rm -f {} +
	find . -name "*.html" -type f -delete
	find . -type d -empty -delete

simulations:
	php compile.php -V -B

website:
	php compile.php -V

booklet:
	php compile.php -V -B

deploy:
	git archive --format=tar master -o deployment/master.tar
	rm -rf deployment/public
	mkdir deployment/public
	tar xvf deployment/master.tar -C deployment/public
	rm -rf deployment/master.tar
	cd deployment/public && \
	make all && \
	rm -rf data && \
	rm -rf tmp
	
	cd deployment && \
	firebase --project cosmology-c47d4 deploy && \
	tar -jcvf public.tar.bz2 public/
	
	if [ ! -f deployment/linux-amd64-github-release.tar.bz2 ]; then \
	    wget https://github.com/aktau/github-release/releases/download/v0.6.2/linux-amd64-github-release.tar.bz2 -P deployment/; \
	fi
	
	tar jxvf deployment/linux-amd64-github-release.tar.bz2 -C deployment
	
	-exec ./deployment/bin/linux/amd64/github-release delete --user lucasgautheron --repo CosmologyWebsite --tag `date +%Y-%m-%d`
	exec ./deployment/bin/linux/amd64/github-release release --user lucasgautheron --repo CosmologyWebsite --tag `date +%Y-%m-%d` --name "Deployment $${RELEASE_VERSION}" --description ""
	exec ./deployment/bin/linux/amd64/github-release upload --user lucasgautheron --repo CosmologyWebsite --tag `date +%Y-%m-%d` --name "public.tar.bz2" --file deployment/public.tar.bz2

