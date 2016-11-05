GH_RELEASE_PATH="$(pwd)/deployment/bin/linux/amd64"
RELEASE_VERSION=`date +%Y-%m-%d`
GH_REPOSITORY="CosmologyWebsite"
export GH_USER="lucasgautheron"
export GITHUB_TOKEN="3b1aa9e0702392a3618798943f2547c47714d184"

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
	mkdir -p deployment
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
	firebase deploy && \
	tar -jcvf public.tar.bz2 public/
	
	if [ ! -f deployment/linux-amd64-github-release.tar.bz2 ]; then
  	    wget https://github.com/aktau/github-release/releases/download/v0.6.2/linux-amd64-github-release.tar.bz2 -P deployment/
	fi
	
	tar jxvf deployment/linux-amd64-github-release.tar.bz2 -o deployment/linux-amd64-github-release
	
	"$GH_RELEASE_PATH/github-release" delete \
	--user $GH_USER \
	--repo $GH_REPOSITORY \
	--tag $RELEASE_VERSION
	
	"$GH_RELEASE_PATH/github-release" release \
	--user $GH_USER \
	--repo $GH_REPOSITORY \
	--tag $RELEASE_VERSION \
	--name "Deployment ${RELEASE_VERSION}" \
	--description "" \
	
	"$GH_RELEASE_PATH/github-release" upload \
	--user $GH_USER \
	--repo $GH_REPOSITORY \
	--tag $RELEASE_VERSION \
	--name "public.tar.bz2" \
	--file public.tar.bz2

