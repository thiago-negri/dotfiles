export DEV_HOME=/usr/local
export M2_HOME=/usr/local/mvn
export ANT_HOME=/usr/local/ant
export GROOVY_HOME=/usr/local/groovy
export GRAILS_HOME=/usr/local/grails
export PHANTOMJS_HOME=/usr/local/phantomjs
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-21.jdk/Contents/Home

PATH="$PATH:$HOME/.fzf/bin"
PATH="$M2_HOME/bin:$PATH"
PATH="$ANT_HOME/bin:$PATH"
PATH="$GROOVY_HOME/bin:$PATH"
PATH="$GRAILS_HOME/bin:$PATH"
PATH="$PHANTOMJS_HOME/bin:$PATH"
PATH="$PATH:/usr/local/mysql/bin:/usr/local/groovy/bin:/usr/local/tomcat/bin:/usr/local/phantomjs/bin:/usr/local/ant/bin:/usr/local/mvn/bin:/usr/local/bin:/usr/bin"
PATH="/usr/local/opt/mysql-client/bin:$PATH"
PATH="$PATH:/usr/local/sbin"
PATH="$PATH:$HOME/.docker/bin"
PATH="$PATH:$HOME/.dotnet/tools"
PATH="$PATH:/Applications/WezTerm.app/Contents/MacOS"

# homebrew install stuff to /usr/local, make sure it goes before /usr/bin to override system defaults (e.g. vim)
PATH="/usr/local/bin:$PATH"

export PATH
