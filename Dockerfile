FROM openjdk:17
ADD target/stage-0.0.1-SNAPSHOT.jar /stage-0.0.1-SNAPSHOT.jar
ENTRYPOINT ["java","-jar","/stage-0.0.1-SNAPSHOT.jar"]