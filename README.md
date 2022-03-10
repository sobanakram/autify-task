# Fetch Cli

Steps to run

1. Make sure you have [docker](https://www.docker.com/) installed in your system
2. Run command `docker build -t fetch-cli .` to build docket image
3. Run cli using this command `docker run -v $(pwd):/fetch fetch-cli https://www.google.com`
   1. Webpage would be downloaded in current directory
4. Run cli using this command `docker run -v $(pwd):/fetch fetch-cli --metadata https://www.google.com`
   1. It will display metadata