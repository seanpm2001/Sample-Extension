ifeq ($(origin JAVA_HOME), undefined)
  ifneq (,$(findstring Darwin,$(shell uname)))
    JAVA_HOME=`/usr/libexec/java_home -F -v1.7*`
  else
    JAVA_HOME=/usr
  endif
endif

ifneq (,$(findstring CYGWIN,$(shell uname -s)))
  JAVA_HOME := `cygpath -up "$(JAVA_HOME)"`
endif

ifeq ($(origin SCALA_JAR), undefined)
  SCALA_JAR=$(NETLOGO)/lib/scala-library.jar
endif

JAVAC=$(JAVA_HOME)/bin/javac
SRCS=$(wildcard src/*.java)

sample.jar: $(SRCS) manifest.txt Makefile NetLogoHeadless.jar
	mkdir -p classes
	$(JAVAC) -g -deprecation -Werror -Xlint:all -Xlint:-serial -Xlint:-path -encoding us-ascii -source 1.7 -target 1.7 -classpath NetLogoHeadless.jar:$(SCALA_JAR) -d classes $(SRCS)
	jar cmf manifest.txt sample.jar -C classes .

NetLogoHeadless.jar:
	curl -f -s -S 'http://ccl.northwestern.edu/devel/NetLogoHeadless-e2bba9de.jar' -o NetLogoHeadless.jar

sample.zip: sample.jar
	rm -rf sample
	mkdir sample
	cp -rp sample.jar README.md Makefile src manifest.txt sample
	zip -rv sample.zip sample
	rm -rf sample
