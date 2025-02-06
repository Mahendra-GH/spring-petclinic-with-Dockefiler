FROM maven:3.9-eclipse-temurin-17-alpine AS build
# copy all code . to spc
COPY . /spc
# Make spc as a working directory
WORKDIR /spc
# Run command for jar file
RUN mvn package

FROM eclipse-temurin:17
LABEL project="learning"
LABEL author="mahe"
#Create an Argument called USERNAME and give any username
ARG USERNAME=nonroot
# Add a non_root user and directory
RUN useradd -r -m -d /apps/${USERNAME} -s /bin/bash ${USERNAME}
#change root user to non_root user
USER ${USERNAME}
# copy jar file from build stage and copy to /apps
COPY --from=build --chown=${USERNAME}:${USERNAME}  /spc/target/spring-petclinic-3.4.0-SNAPSHOT.jar /apps/spring-petclinic-3.4.0-SNAPSHOT.jar
# make working directory apps
WORKDIR /apps
# SpringPetclinc application will runs on port 8080
EXPOSE 8080
# CMD Executes when the container is started
CMD [ "java", "-jar", "spring-petclinic-3.4.0-SNAPSHOT.jar" ]