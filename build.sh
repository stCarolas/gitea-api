#! /bin/sh
set -x -e

export

git clone https://github.com/go-gitea/gitea.git
sed -i s/{{AppSubUrl}}//g gitea/templates/swagger/v1_json.tmpl
curl https://repo1.maven.org/maven2/io/swagger/swagger-codegen-cli/2.4.5/swagger-codegen-cli-2.4.5.jar -O
java -jar swagger-codegen-cli-2.4.5.jar generate -l java -i gitea/templates/swagger/v1_json.tmpl -c config.json -o .
rm -rf src/test
rm -rf pom.xml
# use github variable to check and run only for github
mvn -B -q deploy -Ddeploy.token=${{ secrets.BINTRAY_API_KEY }} -s .github/workflows/settings.xml
