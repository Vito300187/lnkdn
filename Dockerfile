FROM ruby:2.7.0
LABEL autor="Vitaly Kuzminov" \
      maintainer="Repz2010@gmail.com"

EXPOSE 4444

# Install Google Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list && \
    apt-get update -y && \
    apt-get install -y google-chrome-stable

# Download and install Chromedriver
WORKDIR /tmp
RUN CHROMEDRIVER_VERSION=`curl -s chromedriver.storage.googleapis.com/LATEST_RELEASE` && \
    curl -s -o chromedriver.zip http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip && \
    unzip chromedriver.zip -d /usr/local/bin && \
    echo $CHROMEDRIVER_VERSION > chrome_version.txt && \
    rm /tmp/chromedriver.zip

RUN mkdir /home/linkedin
WORKDIR /home/linkedin
COPY . .
RUN bundle

ENTRYPOINT ["rspec", "main_linkedin.rb"]
