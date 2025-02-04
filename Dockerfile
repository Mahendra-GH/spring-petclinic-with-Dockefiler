FROM maven:eclipse-temurin-17 As build
COPY ./spc
WORKDIR spc
RUN mvn package

FROM eclipse-temurin:17 As Final
LABEL project="learning" 
LABEL author="mahe"
ARG USERNAME=spc
RUN useradd -m -d /apps -s /bin/bash ${USERNAME}
USER ${USERNAME}
COPY --from=build --chown=${USERNAME}:${USERNAME}  /spc/target/spring-petclinic-3.4.0-SNAPSHOT.jar /apps/spring-petclinic-3.4.0-SNAPSHOT.jar
WORKDIR /apps
EXPOSE 8080
# CMD Executes when the container is started
CMD [ "java", "-jar", "spring-petclinic-3.4.0-SNAPSHOT.jar" ]
