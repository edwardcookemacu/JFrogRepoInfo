FROM jfrog AS jfrog

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

ARG dotnetcmd=dotnet
ARG JFROG_CLI_BUILD_NAME=
ARG JFROG_CLI_BUILD_NUMBER=
ARG JFROG_CLI_BUILD_PROJECT=
ARG JFROG_CLI_BUILD_URL=
ARG JFROG_ENABLED=
ARG JFROG_TOKEN=
ARG JFROG_URL=
ARG JFROG_USERNAME=
ARG CI=true

ENV JFROG_CLI_BUILD_NAME=${JFROG_CLI_BUILD_NAME}
ENV JFROG_CLI_BUILD_NUMBER=${JFROG_CLI_BUILD_NUMBER}
ENV JFROG_CLI_BUILD_PROJECT=${JFROG_CLI_BUILD_PROJECT}
ENV JFROG_CLI_BUILD_URL=${JFROG_CLI_BUILD_URL}
ENV CI=${CI}

COPY --from=jfrog /jfrog /jfrog
RUN install /jfrog/jf /usr/bin

COPY hack /hack
RUN cat /hack/configure-package-managers.sh | bash
RUN cat /hack/jfrog-configure.sh | bash

# Actually build here
WORKDIR /app

# copy files needed for restore
COPY ./src/ConsoleApp1.sln ./src/ConsoleApp1.sln
COPY ./src/ConsoleApp1/ConsoleApp1.csproj ./src/ConsoleApp1/ConsoleApp1.csproj

RUN ${dotnetcmd} restore ./src/ConsoleApp1.sln

# build the binaries
COPY . .
WORKDIR /app/src
RUN ${dotnetcmd} build -c Release ./ConsoleApp1.sln

# publish
RUN ${dotnetcmd} publish ./ConsoleApp1/ConsoleApp1.csproj --no-build -c Release -o /out

#######

FROM build AS scanner

ARG JFROG_CLI_BUILD_NAME=
ARG JFROG_CLI_BUILD_NUMBER=
ARG JFROG_CLI_BUILD_PROJECT=
ARG JFROG_CLI_BUILD_URL=
ARG JFROG_VULNERABILITIES=true
ARG JFROG_FAIL_BUILD=false
ARG CI=true
ENV JFROG_CLI_BUILD_NAME=${JFROG_CLI_BUILD_NAME}
ENV JFROG_CLI_BUILD_NUMBER=${JFROG_CLI_BUILD_NUMBER}
ENV JFROG_CLI_BUILD_PROJECT=${JFROG_CLI_BUILD_PROJECT}
ENV JFROG_CLI_BUILD_URL=${JFROG_CLI_BUILD_URL}
ENV CI=${CI}

WORKDIR /app
RUN cat /hack/jfrog-bag.sh | bash
RUN jf rt bce ${JFROG_CLI_BUILD_NAME} ${JFROG_CLI_BUILD_NUMBER}
RUN jf rt bp ${JFROG_CLI_BUILD_NAME} ${JFROG_CLI_BUILD_NUMBER}
RUN jf bs ${JFROG_CLI_BUILD_NAME} ${JFROG_CLI_BUILD_NUMBER} --vuln=${JFROG_VULNERABILITIES} --fail=${JFROG_FAIL_BUILD} --extended-table

WORKDIR /app/src
RUN jf audit --licenses

#######

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS jfrogscan

WORKDIR /app
COPY --from=scanner /out .
CMD [ "dotnet", "ConsoleApp1.dll"]

#######

FROM mcr.microsoft.com/dotnet/aspnet:6.0

WORKDIR /app
COPY --from=build /out .
CMD [ "dotnet", "ConsoleApp1.dll"]